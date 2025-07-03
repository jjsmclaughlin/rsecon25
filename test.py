#!/usr/bin/python3

import sys
import spacy
import json

# make the factory work
from scripts.rel_pipe import make_relation_extractor

# make the config work
from scripts.rel_model import create_relation_model, create_classification_layer, create_instances, create_tensors

if ( __name__ == "__main__"):

    if len(sys.argv) > 2:
        modeldir = sys.argv[1]
        infile = sys.argv[2]

    else:
        print('Need model directory and jsonl file to read from to do anything')
        exit(1)

    trained_nlp = spacy.load(modeldir)

    with open(infile, 'r') as jsonl_file:

        jsonl_list = list(jsonl_file)
        print(infile)

        start = 0

        if len(sys.argv) > 3:
            start = int(sys.argv[3])

        end = len(jsonl_list)
        print(str(end) + ' lines')

        if len(sys.argv) > 4:
            end = int(sys.argv[4])

        print('Will process lines ' + str(start) + ' to ' + str(end))

        for jsonl_str in jsonl_list[start:end]:

            datum = json.loads(jsonl_str)

            text = datum['text']

            print(text)

            print()

            doc = trained_nlp(text)

            for ent in doc.ents:
                print(ent.text + ' ' + ent.label_ + '\n')

            for value, rel_dict in doc._.rel.items():
                print(value)
                print(rel_dict)
            #if (rel_dict['Injurybody'] > 0.001):
                #print(str(value) + ' : ' + str(span_start_to_ent[value[0]]) + ' : ' + str(span_start_to_ent[value[1]]) + ' : ' + str(rel_dict))



