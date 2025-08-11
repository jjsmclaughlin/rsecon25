#!/usr/bin/python3

import argparse
import spacy
import json
from spacy.tokens import DocBin, Doc
from spacy.training.example import Example

from transformers import AutoTokenizer, AutoModelForCausalLM, pipeline
import torch
import re
import rapidfuzz

# make the factory work
from relation_extractor_context.rel_pipe import make_relation_extractor, score_relations

# make the config work
from relation_extractor_context.rel_model import create_relation_model, create_classification_layer, create_instances, create_tensors

def _score_and_format(examples, thresholds):
    for threshold in thresholds:
        r = score_relations(examples, threshold)
        results = {k: "{:.2f}".format(v * 100) for k, v in r.items()}
        print(f"threshold {'{:.2f}'.format(threshold)} \t {results}")


def matchent(string, ent, label):

    string_reg = string.lower().strip()
    ent_reg = str(ent).lower().strip()

    if label == 'VER' and 'not guilty' in string_reg: string_reg = 'acquitted'

    if label == 'DEFENDANT' and string_reg in ent_reg:
        #print('BIG MATCH: ***' + string_reg + '***' + ent_reg + '***')
        return (1.0, ent)

    score = rapidfuzz.distance.JaroWinkler.similarity(string_reg, ent_reg) 

    #print(string_reg, ent_reg, score)

    return (score, ent)

def findent(string, ents, entlabel):

    matches = []

    for ent in ents:

        if entlabel == None or ent.label_ == entlabel:

            matches.append(matchent(string, ent, entlabel))

            #if string == str(ent):

            #    return ent

    matches = sorted(matches, key=lambda x: x[0], reverse=True)

    if matches[0][0] < 0.7:

        print('Could not match: ***' + string + '*** ' + str(matches[0]))
        return None

    #print(matches)

    return(matches[0][1])



if ( __name__ == "__main__"):

    parser = argparse.ArgumentParser(description='Read line(s) from a Protege-style jsonl and test a trained model on them.', formatter_class=argparse.ArgumentDefaultsHelpFormatter)

    parser.add_argument('docbin', help='The docbin to read from.')
    parser.add_argument('-ce', '--copyents', action='store_true', default=False, help='If set, the ents are loaded from the docbin. Neccessary when testing a pipeline which has a relation_extractor but no ner')
    parser.add_argument('-s', '--start', type=int, default=0, help='The doc begin reading the docbin from.')
    parser.add_argument('-e', '--end', type=int, help='The doc on which to stop reading the docbin (defaults to the final doc in the docbin).')

    args = parser.parse_args()




    ## Initialise LLM
    # Load tokenizer and model
    model_id = "microsoft/phi-2"

    print("Loading tokenizer...")
    tokenizer = AutoTokenizer.from_pretrained(model_id)

    print("Loading model (this may take a minute)...")
    model = AutoModelForCausalLM.from_pretrained(
        model_id,
        torch_dtype=torch.float16,  # Needed to fit in 6GB GPU
        device_map="auto"           # Automatically use GPU if available
    )

    # Build text generation pipeline
    generator = pipeline("text-generation", model=model, tokenizer=tokenizer)






    #trained_nlp = spacy.load(args.modeldir)
    db = DocBin(store_user_data=True).from_disk(args.docbin)

    #docs = db.get_docs(trained_nlp.vocab)
    nlp = spacy.blank("en")
    docs = db.get_docs(nlp.vocab)

    end = db.__len__()
    print(str(end) + ' docs.')

    if args.end: end = int(args.end)

    print('Will process docs ' + str(args.start) + ' to ' + str(end))

    rels_to_evaluate = False
    examples = []

    for idx, gold in enumerate(docs):

        if idx >= args.start and idx < end:

            print()
            print('---------------- DOC ' + str(idx) + ' ----------------')
            print(gold)
            print()

            doctxt = str(gold)

            if '[Transportation. See summary.]' in doctxt:

                doctxt = doctxt.replace('[Transportation. See summary.]', '')

            #print(len(doctxt))

            doctxt = re.sub(r'[0-9]', r'', doctxt)


            if (len(doctxt) > 1000):
                doctxt = doctxt[0:500] + '. ' + doctxt[-500:]

            print(doctxt)
            print()

            pred = Doc(
                #trained_nlp.vocab,
                nlp.vocab,
                words=[t.text for t in gold],
                spaces=[t.whitespace_ for t in gold],
            )

            if args.copyents:
                pred.ents = gold.ents

            #for name, proc in trained_nlp.pipeline:
            #    pred = proc(pred)
            # This is where we will apply our LLM

            spacy_rels = {}
            # First, use the gold ents to set up the empty dictionaries for each possible combination of entity start tokens
            for x1 in gold.ents:
                for x2 in gold.ents:
                    spacy_rels[(x1.start, x2.start)] = {}

            prompt = (
                "Instruct: You are an expert Natural Language Processing system. Your task is to extract structured information from the following legal case text. "
                "For each defendant, output one line in the following format: [Defendant Name], [Verdict]. Do not put any other text in your answer. "
                "Text to analyze: "
                "\""
                #"Robert Nowland, of Christ-Church, was indicted, and Patrick Nowland (his Father) of the same Parish, was a 2d time indicted for breaking and entering the House of William Durant. At the Prisoner Patrick's House. It appear'd that Trevors was a most notorious Rogue, and belong'd to Patrick's Gang; and that last Sessions he was try'd for robbing the Dog Tavern in Newgate-street, when Patrick was an Evidence for him. The Evidence not being sufficient against Robert Nowland, the Jury acquitted him, and found Patrick Guilty. Death."
                + str(doctxt) + 
                "\"\nOutput:"
            )

            # Generate output
            #print("\nGenerating...")
            output = generator(prompt, max_new_tokens=256, temperature=0.1, do_sample=True, pad_token_id=tokenizer.eos_token_id)
            otext = output[0]["generated_text"]

            # Display result
            #print("\n--- Output ---")
            #print(otext)
            #print()

            if "Output:" in otext:

                otext = otext.rsplit("Output:", 1)[1].strip()
                print('--------- LLM SAYS: --------')
                print(otext)
                print('----------------------------')
                print()

                opairs = re.split("\n|\\.", otext)

                #print(opairs)
                #print()

                for opair in opairs:

                    if ',' in opair:

                        defver = opair.strip().split(',')
                    
                        defs = defver[0].strip()
                        vers = defver[1].strip()

                        #print('***' + defs + '***' + vers + '***')

                        defe = findent(defs, gold.ents, 'DEFENDANT')
                        vere = findent(vers, gold.ents, 'VER')

                        #print(str(defe))
                        #print(str(vere))

                        if defe and vere:

                            spacy_rels[(defe.start, vere.start)]['DEFVER'] = 1.0


            # When we have finished assigning 1.0s (representing a correct relationship) where needed, fill in the rest of the labels with 0.0s (no relationship)
            for x1 in gold.ents:
                for x2 in gold.ents:
                    for label in ['DEFVER']:
                        if label not in spacy_rels[(x1.start, x2.start)]:
                            spacy_rels[(x1.start, x2.start)]['DEFVER'] = 0.0

            pred._.rel = spacy_rels




            examples.append(Example(pred, gold))

            # print the spans in gold
            if 'sc' in gold.spans:
                print("GOLD SPANS:")
                for span in gold.spans['sc']:
                    print(str(span.label_).ljust(20) + ' ' + str(span.start).ljust(3) + '-> ' + str(span.end).ljust(3) + ' ' + str(span))
                print()

            # print the spans in pred
            if 'sc' in pred.spans:
                print("PRED SPANS:")
                for span, confidence in zip(pred.spans['sc'], pred.spans['sc'].attrs["scores"]):
                    print(str(span.label_).ljust(20) + ' ' + str(confidence).ljust(12) + ' ' + str(span.start).ljust(3) + '-> ' + str(span.end).ljust(3) + ' ' + str(span))
                print()

            # print the ents in gold
            #if gold.ents:
            #    print("GOLD ENTS:")
            #    for ent in gold.ents:
            #        print(str(ent.label_).ljust(20) + ' ' + str(ent.start).ljust(3) + '-> ' + str(ent.end).ljust(3) + ' ' + str(ent))
            #    print()

            # print the ents in pred
            if pred.ents and args.copyents is False:
                print("PRED ENTS:")
                for ent in pred.ents:
                    print(str(ent.label_).ljust(20) + ' ' + str(ent.start).ljust(3) + '-> ' + str(ent.end).ljust(3) + ' ' + str(ent))
                print()

            # Print the rels in gold
            if gold._.rel:
                print("-------- GOLD RELS: --------")

                # Create a dictionary so we can look up each ent using its starting token
                gold_ent_starts_dict = {}
                for ent in gold.ents: gold_ent_starts_dict[ent.start] = ent

                for rel in gold._.rel:
                    head = rel[0]
                    child = rel[1]
                    vals = gold._.rel[(rel[0], rel[1])]
                    for val in vals:
                        if vals[val] > 0.1:
                            headent = gold_ent_starts_dict[head]
                            childent = gold_ent_starts_dict[child]
                            headidx = gold.ents.index(headent)
                            childidx = gold.ents.index(childent)
                            print(val + ' ' + str(vals[val]))
                            print('+ ' + str(headent.label_).ljust(20) + ' ' + str(headent.start).ljust(3) + '-> ' + str(headent.end).ljust(3) + ' ' + str(headent))
                            print('+ ' + str(childent.label_).ljust(20) + ' ' + str(childent.start).ljust(3) + '-> ' + str(childent.end).ljust(3) + ' ' + str(childent))
                            print()


            # Print the rels in pred
            if pred._.rel:
                rels_to_evaluate = True
                print("-------- PRED RELS: --------")

                # Create a dictionary so we can look up each ent using its starting token
                pred_ent_starts_dict = {}
                for ent in pred.ents: pred_ent_starts_dict[ent.start] = ent

                for rel in pred._.rel:
                    head = rel[0]
                    child = rel[1]
                    vals = pred._.rel[(rel[0], rel[1])]
                    for val in vals:
                        if vals[val] > 0.1:
                            headent = pred_ent_starts_dict[head]
                            childent = pred_ent_starts_dict[child]
                            headidx = pred.ents.index(headent)
                            childidx = pred.ents.index(childent)
                            print(val + ' ' + str(vals[val]))
                            print('+ ' + str(headent.label_).ljust(20) + ' ' + str(headent.start).ljust(3) + '-> ' + str(headent.end).ljust(3) + ' ' + str(headent))
                            print('+ ' + str(childent.label_).ljust(20) + ' ' + str(childent.start).ljust(3) + '-> ' + str(childent.end).ljust(3) + ' ' + str(childent))
                            print()

    # We cannot use the SpaCy evaluate command to evaluate relation_extractor so let's do it here. Code is borrowed from relation_extrator tutorial itself.
    if rels_to_evaluate:

        # Threshold is the cutoff to consider a prediction "positive". The docs for relation_extractor say this should be 0.5
        thresholds = [0.000, 0.050, 0.100, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 0.99, 0.999]

        print()
        print("Results of the trained model:")
        _score_and_format(examples, thresholds)

