#!/usr/bin/python3

#import sys
import argparse
import spacy
import json
from spacy.tokens import DocBin, Doc

# make the factory work
from scripts.rel_pipe import make_relation_extractor

# make the config work
from scripts.rel_model import create_relation_model, create_classification_layer, create_instances, create_tensors

if ( __name__ == "__main__"):

    parser = argparse.ArgumentParser(description='Read line(s) from a Protege-style jsonl and test a trained model on them.', formatter_class=argparse.ArgumentDefaultsHelpFormatter)

    parser.add_argument('modeldir', help='The model to test.')
    parser.add_argument('docbin', help='The docbin to read from.')
    parser.add_argument('-s', '--start', type=int, default=0, help='The line to begin reading the jsonl file from.')
    parser.add_argument('-e', '--end', type=int, help='The line on which to stop reading the jsonl file (defaults to the final line in the file).')

    args = parser.parse_args()

    


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

    for doc in docs:

        print(doc) # So we can just get the text yay

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

