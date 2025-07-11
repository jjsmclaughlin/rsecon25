#!/usr/bin/python3

import argparse
import spacy
import json
from spacy.tokens import DocBin, Doc
from spacy.training.example import Example

# make the factory work
from relation_extractor.rel_pipe import make_relation_extractor, score_relations

# make the config work
from relation_extractor.rel_model import create_relation_model, create_classification_layer, create_instances, create_tensors

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

            print(gold)
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
            if gold.ents:
                print("GOLD ENTS:")
                for ent in gold.ents:
                    print(str(ent.label_).ljust(20) + ' ' + str(ent.start).ljust(3) + '-> ' + str(ent.end).ljust(3) + ' ' + str(ent))
                print()

            # print the ents in pred
            if pred.ents and args.copyents is False:
                print("PRED ENTS:")
                for ent in pred.ents:
                    print(str(ent.label_).ljust(20) + ' ' + str(ent.start).ljust(3) + '-> ' + str(ent.end).ljust(3) + ' ' + str(ent))
                print()

            # Print the rels in gold
            if gold._.rel:
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
                            print(val + ' ' + str(vals[val]))
                            print('+ ' + str(headent.label_).ljust(20) + ' ' + str(headent.start).ljust(3) + '-> ' + str(headent.end).ljust(3) + ' ' + str(headent))
                            print('+ ' + str(childent.label_).ljust(20) + ' ' + str(childent.start).ljust(3) + '-> ' + str(childent.end).ljust(3) + ' ' + str(childent))
                            print()


            # Print the rels in pred
            if pred._.rel:
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
                            print(val + ' ' + str(vals[val]))
                            print('+ ' + str(headent.label_).ljust(20) + ' ' + str(headent.start).ljust(3) + '-> ' + str(headent.end).ljust(3) + ' ' + str(headent))
                            print('+ ' + str(childent.label_).ljust(20) + ' ' + str(childent.start).ljust(3) + '-> ' + str(childent.end).ljust(3) + ' ' + str(childent))
                            print()

    # We cannot use the SpaCy evaluate command to evaluate relation_extractor so let's do it here. Code is borrowed from relation_extrator tutorial itself.
    if pred._.rel:

        # Threshold is the cutoff to consider a prediction "positive". The docs for relation_extractor say this should be 0.5
        thresholds = [0.000, 0.050, 0.100, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 0.99, 0.999]

        print()
        print("Results of the trained model:")
        _score_and_format(examples, thresholds)

