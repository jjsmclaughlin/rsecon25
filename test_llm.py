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


def defabr(string):

    # Just take the first two words of defendant names (to remove aliases or other extraneous information)
    string = " ".join(string.split()[:2])
    string = string.replace(',', '')

    return string.strip()

def matchent(string, ent, label):

    string_reg = string.lower().strip()
    ent_reg = str(ent).lower().strip()

    if label == 'DEFENDANT':
        string_reg = defabr(string_reg)
        ent_reg = defabr(ent_reg)

    if label == 'VER' and 'not guilty' in string_reg: string_reg = 'acquitted' # The LLM sometimes likes to say "Not Guilty" but the Proceedings almost always says "Acquitted".
    if label == 'VER' and 'pleaded guilty' in ent_reg: ent_reg = 'guilty' # The LLM never says "Pleaded Guily" but the Proceedings usually do.

    if label == 'DEFENDANT' and string_reg in ent_reg: return (1.0, ent) # If the LLM's output for defendant is fully present in the entity text, call it a match. eg. "Sarah Clark" should match "Sarah Clark , otherwise West"

    score = rapidfuzz.distance.JaroWinkler.similarity(string_reg, ent_reg) 

    return (score, ent)

def findent(string, ents, entlabel):

    matches = []

    for ent in ents:

        if entlabel == None or ent.label_ == entlabel:

            matches.append(matchent(string, ent, entlabel))

    matches = sorted(matches, key=lambda x: x[0], reverse=True)

    if matches[0][0] < 0.7: # Try to avoid false matches

        print('Could not match: ***' + string + '*** ' + str(matches[0]))
        return None

    return(matches[0][1])



if ( __name__ == "__main__"):

    parser = argparse.ArgumentParser(description='Read line(s) from a Protege-style jsonl and test a trained model on them.', formatter_class=argparse.ArgumentDefaultsHelpFormatter)

    parser.add_argument('docbin', help='The docbin to read from.')
    parser.add_argument('-s', '--start', type=int, default=0, help='The doc begin reading the docbin from.')
    parser.add_argument('-e', '--end', type=int, help='The doc on which to stop reading the docbin (defaults to the final doc in the docbin).')

    args = parser.parse_args()

    # Initialise LLM
    model_id = "microsoft/phi-2"

    print("Loading tokenizer...")
    tokenizer = AutoTokenizer.from_pretrained(model_id)

    print("Loading model (this may take a minute)...")
    model = AutoModelForCausalLM.from_pretrained(
        model_id,
        torch_dtype=torch.float16,  # Need to fit in 6GB GPU
        device_map="auto"           # Automatically use GPU if available
    )

    # Build text generation pipeline
    generator = pipeline("text-generation", model=model, tokenizer=tokenizer)

    db = DocBin(store_user_data=True).from_disk(args.docbin)

    nlp = spacy.blank("en")
    nlp.add_pipe('sentencizer') # We use this to help build the verdicts section of our prompt.
    docs = db.get_docs(nlp.vocab)

    end = db.__len__()
    print(str(end) + ' docs.')

    if args.end: end = int(args.end)

    print('Will process docs ' + str(args.start) + ' to ' + str(end))

    examples = []

    for idx, gold in enumerate(docs):

        if idx >= args.start and idx < end:

            doctxt = str(gold)

            print()
            print('---------------- DOC ' + str(idx) + ' ----------------')
            print(doctxt)
            print()

            # Now we mangle the doctxt to make it more likely the LLM will give us good results.

            pred = Doc(
                nlp.vocab,
                words=[t.text for t in gold],
                spaces=[t.whitespace_ for t in gold],
            )

            pred.ents = gold.ents

            for name, proc in nlp.pipeline: pred = proc(pred) # Run the sentencizer on the doc

            # Create a list of defendants.

            deflist = ''

            for ent in pred.ents:

                if ent.label_ == 'DEFENDANT':

                    deflist = deflist + defabr(str(ent)) + '. '

            # Create a list of the sentences which contain verdicts.

            versents = []

            for ent in pred.ents:

                if ent.label_ == 'VER':

                    if ent.sent not in versents:

                        versents.append(ent.sent)

            vertxt = ''

            for sent in versents:

                vertxt = vertxt + '' + str(sent) + ' '

            # We create a fake document text which is just our defendants list followed by the verdict sentences. 

            doctxt = 'Defendants: ' + deflist + 'Verdicts: ' + vertxt
            
            if 'Transportation' in doctxt: doctxt = doctxt.replace('Transportation', '') # The references to punishments can confuse the LLM
            if 'Death' in doctxt: doctxt = doctxt.replace('Death', '')
            if ' [' in doctxt: doctxt = doctxt.replace(' [', '')

            # Print our mangled doctxt
            print(doctxt)
            print()

            # Query the LLM

            prompt = (
                "Instruct: You are an expert Natural Language Processing system. Your task is to extract structured information from the following legal case text. "
                "For each defendant, output one line in the following format: [Defendant Name]: [Verdict]. Do not put any other text in your answer. "
                "Text to analyze: "
                "\""
                + str(doctxt) + 
                "\"\nOutput:"
            )

            output = generator(prompt, max_new_tokens=256, temperature=0.1, do_sample=True, pad_token_id=tokenizer.eos_token_id)
            otext = output[0]["generated_text"]

            # Parse the LLM result into a spaCy rel structure 

            spacy_rels = {}
            # First, use the gold ents to set up the empty dictionaries for each possible combination of entity start tokens
            for x1 in gold.ents:
                for x2 in gold.ents:
                    spacy_rels[(x1.start, x2.start)] = {}

            if "Output:" in otext:

                otext = otext.rsplit("Output:", 1)[1].strip() # The LLM's output follows the string "Output:"
                print('--------- LLM SAYS: --------')
                print(otext)
                print('----------------------------')
                print()

                opairs = re.split("\n|\\.", otext) # We asked for one defendant per line but sometimes we get one defendant per sentence

                for opair in opairs:

                    if ':' in opair:

                        defver = opair.strip().split(':')
                    
                        defs = defver[0].strip()
                        vers = defver[1].strip()

                        defe = findent(defs, gold.ents, 'DEFENDANT') # Find the ents which match the LLM's output most closely. Something of a dark art.
                        vere = findent(vers, gold.ents, 'VER')

                        if defe and vere:

                            # Add the appropriate relationship to the spaCy rel structure
                            spacy_rels[(defe.start, vere.start)]['DEFVER'] = 1.0


            # When we have finished assigning 1.0s (representing a correct relationship) where needed, fill in the rest of the labels with 0.0s (no relationship)
            for x1 in gold.ents:
                for x2 in gold.ents:
                    for label in ['DEFVER']:
                        if label not in spacy_rels[(x1.start, x2.start)]:
                            spacy_rels[(x1.start, x2.start)]['DEFVER'] = 0.0

            pred._.rel = spacy_rels # Add the rel structure to the pred document

            examples.append(Example(pred, gold)) # Record the gold and pred doc so the pred doc can form part of the evauation later

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
    # Threshold is the cutoff to consider a prediction "positive". The docs for relation_extractor say this should be 0.5
    thresholds = [0.000, 0.050, 0.100, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 0.99, 0.999]

    print()
    print("Results of the trained model:")
    _score_and_format(examples, thresholds)

