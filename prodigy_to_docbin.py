#!/usr/bin/python3

import sys
import json
#import random
#import spacy
#from spacy.tokens import DocBin
#import re

#def make_spacy_docbin(data_in, path):
#
#    nlp = spacy.blank("en")
#
#    db = DocBin()
#
#    for datum in data_in:
#
#        text = datum['text']
#
#        print('\n' + text)
#
#        doc = nlp(text)
#
#        ents = []
#
#        for adatum in datum['spans']:
#
#            start = adatum['start']
#            end = adatum['end']
#            label = adatum['label']
#
#            if label == 'INJURY' or label == 'BODYLOCATION':
#
#                print(start, end, label)
#                print('**' + text[start:end] + '**')
#
#                span = doc.char_span(start, end, label=label)
#                ents.append(span)
#
#        print()
#
#        doc.ents = ents
#        db.add(doc)
#
#    db.to_disk(path)

#def datum_is_suitable(datum):
#
#    # doc.char_span(start, end, label) returns None when the start and end character indexes provided don't align with token boundaries.
#    # So we have to detect the problematic punctuation patterns in advance and remove those records.
#    # https://stackoverflow.com/questions/74494620/spacy-doc-char-span-raises-error-whenever-there-is-any-number-in-string
#
#    if re.search(" [;,] "  , datum['text']): return  False
#    if re.search("[\\.,;\\)][^ ]"  , datum['text']): return  False
#    if re.search("[a-z] \\."  , datum['text']): return  False
#
#    return True

if ( __name__ == "__main__"):

    if len(sys.argv) > 2:
        infile = sys.argv[1]
        outfile = sys.argv[2]

        print(outfile)
    else:
        print('Need infile and outfile to do anything')
        exit(1)

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

        for idx, jsonl_str in enumerate(jsonl_list):

            if idx >= start and idx <= end:

                datum = json.loads(jsonl_str)
                #print(idx)


#    examples = []
#
#    with open('../dhi-annotator/data/output/skinandbone_train.jsonl', 'r') as json_file:
#
#        json_list = list(json_file)
#
#        random.shuffle(json_list)
#
#        for json_str in json_list:
#
#            datum = json.loads(json_str)
#
#            if datum_is_suitable(datum): examples.append(datum)
#
#    with open('../dhi-annotator/data/input/skinandbone.jsonl', 'r') as json_file:
#
#        json_list = list(json_file)
#
#        random.shuffle(json_list)
#
#        for json_str in json_list[:220]:
#
#            datum = json.loads(json_str)
#
#            if datum_is_suitable(datum): examples.append(datum)
#
#
#
#    random.shuffle(examples)
#
#    print(len(examples))
    #exit()

    # ~1000
    # 60% training      ~600
    # 20% validation    ~200
    # 20% testing       ~200

    # 394
    # 70% training      276
    # 30% validation    118

    # 10000
    # 70% training      7000
    # 30% validation    3000

#    train_data = examples[0:276]
#    valid_data = examples[276:395]
#    #test_data =  examples[800:1000]
#
#    print(len(train_data))
#    print(len(valid_data))
#    #print(len(test_data))
#
#    make_spacy_docbin(train_data, './docbin/skb/train.spacy')
#    make_spacy_docbin(valid_data, './docbin/skb/valid.spacy')

#    f = open("./docbin/skb/test.txt", "w")
#
#    for datum in test_data:
#
#        print(datum['text'])
#
#        f.write(datum['text'] + '\n')
#
#    f.close()

