#!/usr/bin/python3

import sys
from tqdm import tqdm
import json
import spacy
from spacy.tokens import DocBin, Doc

# rels ###############################################################

MAP_LABELS = {
    #"Pos-Reg": "Regulates",
    #"Neg-Reg": "Regulates",
    #"Reg": "Regulates",
    #"No-rel": "Regulates",
    #"Binds": "Binds",
    "DEFVER": "Defver",
}

# end of rels ###########################################################

if ( __name__ == "__main__"):

    if len(sys.argv) > 2:
        infile = sys.argv[1]
        outfile = sys.argv[2]

    else:
        print('Need infile and outfile to do anything')
        exit(1)

    with open(infile, 'r') as jsonfile:

        jsonlist = list(jsonfile)

        start = 0

        if len(sys.argv) > 3:
            start = int(sys.argv[3])

        end = len(jsonlist)
        print(str(end) + ' lines')

        if len(sys.argv) > 4:
            end = int(sys.argv[4])

        print('Will process lines ' + str(start) + ' to ' + str(end))

        nlp = spacy.blank("en")
        Doc.set_extension("rel", default={}) # rels
        #db = DocBin()
        db = DocBin(store_user_data=True) # rels

        for jsonstr in tqdm(jsonlist[start:end], ascii=True, ncols=60):

            pdatum = json.loads(jsonstr)
                
            doc = nlp(pdatum['text'])

            ents = []
                
            for span in pdatum['spans']:
                
                ent = doc.char_span(span['start'], span['end'], label=span['label'])
                ents.append(ent)
                
            try:
     
                doc.ents = ents

            except ValueError as exception:

                print()
                print()
                print(exception)
                print()
                print(jsonstr)
                print()
                exit(1)

            # rels #################################################################

            #print()
            #print()
            #print(json.dumps(pdatum))

            span_starts = set()

            for ent in doc.ents:
                #print(str(ent) + ' : ' + str(ent.start) + ' : ' + str(ent.end) + ' : ' + str(ent.label))
                span_starts.add(ent.start)

            rels = {}

            for x1 in span_starts:
                for x2 in span_starts:
                    rels[(x1, x2)] = {}

            #print(rels)

            for rel in pdatum['rels']:

                # the 'head' and 'child' annotations refer to the end token in the span
                # but we want the first token
                # ... what?

                start = doc.ents[rel['head']].start
                end = doc.ents[rel['child']].start
                label = rel["label"]

                if label in MAP_LABELS:
                    rel_label = MAP_LABELS[label]
                    if rel_label not in rels[(start, end)]:
                        rels[(start, end)][rel_label] = 1.0

                #print(json.dumps(pdatum))
                #print(start)
                #print(end)
                #print(label)
                

            # The annotation is complete, so fill in zero's where the data is missing
            for x1 in span_starts:
                for x2 in span_starts:
                    for label in MAP_LABELS.values():
                        if label not in rels[(x1, x2)]:
                            rels[(x1, x2)][label] = 0.0

            #print()
            #print(rels)
            #print()
           
            doc._.rel = rels

            #print()
            #print(doc._.rel)
            #print()

            for rel in doc._.rel:

                pass
                #print(str(rel[0]) + ' : ' + str(rel[1]) + ' : ' + str(doc._.rel[(rel[0], rel[1])]) + ' : ' + str(span_start_to_ent[rel[0]]) + ' : ' + str(span_start_to_ent[rel[1]]))
                #print(str(rel[0]) + ' : ' + str(rel[1]) + ' : ' + str(doc._.rel[(rel[0], rel[1])]))


            #print()

            # end of rels ##########################################################

            db.add(doc)

        db.to_disk(outfile)

