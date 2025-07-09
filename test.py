#!/usr/bin/python3

#import sys
import argparse
import spacy
import json
from spacy.tokens import DocBin, Doc
from spacy.training.example import Example

# make the factory work
from scripts.rel_pipe import make_relation_extractor, score_relations

# make the config work
from scripts.rel_model import create_relation_model, create_classification_layer, create_instances, create_tensors



def _score_and_format(examples, thresholds):
    for threshold in thresholds:
        r = score_relations(examples, threshold)
        results = {k: "{:.2f}".format(v * 100) for k, v in r.items()}
        print(f"threshold {'{:.2f}'.format(threshold)} \t {results}")



if ( __name__ == "__main__"):

    parser = argparse.ArgumentParser(description='Read line(s) from a Protege-style jsonl and test a trained model on them.', formatter_class=argparse.ArgumentDefaultsHelpFormatter)

    parser.add_argument('modeldir', help='The model to test.')
    parser.add_argument('docbin', help='The docbin to read from.')
    parser.add_argument('-ce', '--copyents', action='store_true', default=False, help='If set, the ents are loaded from the docbin. Neccessary when testing a pipeline which has a relation_extractor but no ner')
    parser.add_argument('-s', '--start', type=int, default=0, help='The doc begin reading the docbin from.')
    parser.add_argument('-e', '--end', type=int, help='The doc on which to stop reading the docbin (defaults to the final doc in the docbin).')

    args = parser.parse_args()

    #print(args.copyents)
    #exit(1)


#    ents = {}
#
#    if args.ents:
#        entdefs = args.ents.split(',')
#        for entdef in entdefs:
#            entkv = entdef.split(':')
#            ents[entkv[0]] = entkv[1]
#
#        print('ents: ' + str(ents))
#
#
#
#    #if len(sys.argv) > 2:
#    #    modeldir = sys.argv[1]
#    #    infile = sys.argv[2]
#    #
#    #else:
#    #    print('Need model directory and jsonl file to read from to do anything')
#    #    exit(1)
#
#    trained_nlp = spacy.load(args.modeldir)

    trained_nlp = spacy.load(args.modeldir)
    db = DocBin(store_user_data=True).from_disk(args.docbin)

    docs = db.get_docs(trained_nlp.vocab)

    end = db.__len__()
    print(str(end) + ' docs.')

    if args.end: end = int(args.end)

    print('Will process docs ' + str(args.start) + ' to ' + str(end))

    examples = []

    for idx, gold in enumerate(docs):

        if idx >= args.start and idx < end:

            print(gold) # So we can just get the text yay
            print()

            pred = Doc(
                trained_nlp.vocab,
                words=[t.text for t in gold],
                spaces=[t.whitespace_ for t in gold],
            )

            if args.copyents:
                pred.ents = gold.ents

            for name, proc in trained_nlp.pipeline:
                pred = proc(pred)

            examples.append(Example(pred, gold))

            #print(pred._.rel)

            # print the ents in gold
            print("GOLD ENTS:")
            for idx, ent in enumerate(gold.ents):
                #print(ents[filtered_spans[idx]['label']] + ' ' + str(ent.label).ljust(20) + ' ' + str(ent.start).ljust(3) + '-> ' + str(ent.end).ljust(3) + ' ' + str(ent) + ' ' + str(filtered_spans[idx]))
                print(str(ent.label_).ljust(20) + ' ' + str(ent.start).ljust(3) + '-> ' + str(ent.end).ljust(3) + ' ' + str(ent))
            print()

            if args.copyents is False:

                # print the ents in pred
                print("PRED ENTS:")
                for idx, ent in enumerate(pred.ents):
                    #print(ents[filtered_spans[idx]['label']] + ' ' + str(ent.label).ljust(20) + ' ' + str(ent.start).ljust(3) + '-> ' + str(ent.end).ljust(3) + ' ' + str(ent) + ' ' + str(filtered_spans[idx]))
                    print(str(ent.label_).ljust(20) + ' ' + str(ent.start).ljust(3) + '-> ' + str(ent.end).ljust(3) + ' ' + str(ent))
                print()

            if gold._.rel:

                # Print the gold rels
                print("GOLD RELS:")

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
                            #headspan = filtered_spans[headidx]
                            #childspan = filtered_spans[childidx]
                            print(val + ' ' + str(vals[val]))
                            #print('+ ' + ents[headspan['label']] + ' ' + str(headent.label).ljust(20) + ' ' + str(headent.start).ljust(3) + '-> ' + str(headent.end).ljust(3) + ' ' + str(headent) + ' ' + str(headspan))
                            print('+ ' + str(headent.label_).ljust(20) + ' ' + str(headent.start).ljust(3) + '-> ' + str(headent.end).ljust(3) + ' ' + str(headent))
                            #print('+ ' + ents[childspan['label']] + ' ' + str(childent.label).ljust(20) + ' ' + str(childent.start).ljust(3) + '-> ' + str(childent.end).ljust(3) + ' ' + str(childent) + ' ' + str(childspan))
                            print('+ ' + str(childent.label_).ljust(20) + ' ' + str(childent.start).ljust(3) + '-> ' + str(childent.end).ljust(3) + ' ' + str(childent))
                            print()


            if pred._.rel:

                # Print the pred rels
                print("PRED RELS:")

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
                            #headspan = filtered_spans[headidx]
                            #childspan = filtered_spans[childidx]
                            print(val + ' ' + str(vals[val]))
                            #print('+ ' + ents[headspan['label']] + ' ' + str(headent.label).ljust(20) + ' ' + str(headent.start).ljust(3) + '-> ' + str(headent.end).ljust(3) + ' ' + str(headent) + ' ' + str(headspan))
                            print('+ ' + str(headent.label_).ljust(20) + ' ' + str(headent.start).ljust(3) + '-> ' + str(headent.end).ljust(3) + ' ' + str(headent))
                            #print('+ ' + ents[childspan['label']] + ' ' + str(childent.label).ljust(20) + ' ' + str(childent.start).ljust(3) + '-> ' + str(childent.end).ljust(3) + ' ' + str(childent) + ' ' + str(childspan))
                            print('+ ' + str(childent.label_).ljust(20) + ' ' + str(childent.start).ljust(3) + '-> ' + str(childent.end).ljust(3) + ' ' + str(childent))
                            print()



    thresholds = [0.000, 0.050, 0.100, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 0.99, 0.999]

    print()
    print("Results of the trained model:")
    _score_and_format(examples, thresholds)


#    print(args.infile)
#
#    with open(args.infile, 'r') as jsonl_file:
#
#        jsonl_list = list(jsonl_file)
#
#        end = len(jsonl_list)
#        print(str(end) + ' lines')
#
#        if args.end:
#            end = args.end
#
#        print('Will process lines ' + str(args.start) + ' to ' + str(end))
#
#        for jsonl_str in jsonl_list[args.start:end]:
#
#            datum = json.loads(jsonl_str)
#
#            text = datum['text']
#
#            print(text)
#
#            print()
#
#            doc = trained_nlp(text)
#
#            for ent in doc.ents:
#                print(ent.text + ' ' + ent.label_ + '\n')
#
#            for value, rel_dict in doc._.rel.items():
#                print(value)
#                print(rel_dict)
#            #if (rel_dict['Injurybody'] > 0.001):
#                #print(str(value) + ' : ' + str(span_start_to_ent[value[0]]) + ' : ' + str(span_start_to_ent[value[1]]) + ' : ' + str(rel_dict))
#
#

