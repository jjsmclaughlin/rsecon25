#!/usr/bin/python3

#import sys
import argparse
from tqdm import tqdm
import json
import spacy
from spacy.tokens import DocBin, Doc

#MAP_LABELS = {
#    #"Pos-Reg": "Regulates",
#    #"Neg-Reg": "Regulates",
#    #"Reg": "Regulates",
#    #"No-rel": "Regulates",
#    #"Binds": "Binds",
#    "DEFVER": "Defver",
#}

if ( __name__ == "__main__"):

    parser = argparse.ArgumentParser(description='Process a Protege-style jsonl file into a spacy DocBin file.')

    parser.add_argument('infile', help='The jsonl file to read from.')
    parser.add_argument('-o', '--outfile', help='The desired path and filename for the DocBin file which will be written. If this is not specified, the program will do a dry run, outputting debug information without saving a file.')
    parser.add_argument('-s', '--start', help='The line to begin reading the jsonl file from (defaults to 0).')
    parser.add_argument('-e', '--end', help='The line on which to stop reading the jsonl file (defaults to the final line in the file).')
    parser.add_argument('-en', '--ents', help='Comma separated list of ents to read from the jsonl file and after a colon, the desired name of each in the DocBin file. eg. VICTIM:PER,DEFENDANT:PER . If you specify this option, a line will not be included in the DocBin unless it has at least one qualifying ent.')
    parser.add_argument('-re', '--rels', help='Comma separated list of rels to read from the jsonl file and after a colon, the desired name of each in the DocBin file. eg. PERSPLACE:PERPLACE,PERSOCC:PEROCC . If you specify this option, a line will not be included in the DocBin unless it has at least one qualifying rel')
    parser.add_argument('-max', '--maxsize', help='Maximum size in characters of the text field in each json line which will be included in the output DocBin. i.e. all lines with a longer text field will be omitted.')
    parser.add_argument('-min', '--minsize', help='Minimum size in characters of the text field in each json line which will be included in the output DocBin. i.e. all lines with a shorter text field will be omitted.')

    args = parser.parse_args()

#    print('  start: ' + str(args.start))
#    print('    end: ' + str(args.end))
#    print('   ents: ' + str(args.ents))
#    print('   rels: ' + str(args.rels))
    print('maxsize: ' + str(args.maxsize))
    print('minsize: ' + str(args.minsize))

    ents = {}

    if args.ents:
        entdefs = args.ents.split(',')
        for entdef in entdefs:
            entkv = entdef.split(':')
            ents[entkv[0]] = entkv[1]

        print('ents: ' + str(ents))

    rels = {}

    if args.rels:
        reldefs = args.rels.split(',')
        for reldef in reldefs:
            relkv = reldef.split(':')
            rels[relkv[0]] = relkv[1]

        print('rels: ' + str(rels))


#    if (args.infile and args.outfile):
#
#        print(' infile: ' + str(args.infile))
#        print('outfile: ' + str(args.outfile))
#
#    else:
#
#        print('Need infile and outfile to do anything')
#        parser.print_help()
#        exit(1)

    print('infile: ' + str(args.infile))

    with open(args.infile, 'r') as jsonfile:

        jsonlines = list(jsonfile)

        start = 0

        if args.start: start = int(args.start)

        end = len(jsonlines)
        print(str(end) + ' lines')

        if args.end: end = int(args.end)

        print('Will process lines ' + str(start) + ' to ' + str(end))

        nlp = spacy.blank("en")

        db = None

        if len(rels) > 0:

            Doc.set_extension("rel", default={}) # rels
            db = DocBin(store_user_data=True) # rels

        else:

            db = DocBin()

        for jsonline in tqdm(jsonlines[start:end], ascii=True, ncols=60):

            jd = json.loads(jsonline)
                
            doc = nlp(jd['text'])

            if len(ents) > 0:

                # We need to keep a separate array of the ents we actually add, so that we can refer to them by position later on when we are adding the rels.
                filtered_spans = list(filter(lambda x: x['label'] in ents, jd['spans']))

                spacy_ents = []
                
                for span in filtered_spans:               

                    spacy_ent = doc.char_span(span['start'], span['end'], label=ents[span['label']])
                    spacy_ents.append(spacy_ent)
                
                try:
     
                    doc.ents = spacy_ents

                except ValueError as exception:

                    print()
                    print()
                    print(exception)
                    print()
                    print(jsonstr)
                    print()
                    exit(1)


                if len(rels) > 0:

                    filtered_rels = list(filter(lambda x: x['label'] in rels, jd['rels']))

                    # Add the correct head and child index values to each rel, using the uids to look them up                 
                    for rel in filtered_rels:
                
                        #print(rel['headuid'])
                
                        try:
                            rel['head'] = next(i for i,x in enumerate(filtered_spans) if 'uid' in x and x['uid'] == rel['headuid'])
                        except StopIteration:
                            #print('FAILED REL HEAD:' + rel['headuid']);
                            rel['head'] = None
                
                        #print(rel['childuid'])
                
                        try:
                            rel['child'] = next(i for i,x in enumerate(filtered_spans) if 'uid' in x and x['uid'] == rel['childuid'])
                        except StopIteration:
                            #print('FAILED REL CHILD:' + rel['childuid'])
                            rel['child'] = None

                    # Remove rels which no not have a valid head and child
                    filtered_rels = list(filter(lambda x: x['head'] is not None and x['child'] is not None, filtered_rels))

                    print()
                    print(str(filtered_rels))
                    print()

    #                # rels #################################################################
    #
    #                #print()
    #                #print()
    #                #print(json.dumps(pdatum))
    #
                    ent_starts = set()
    #
                    print()
                    print()
                    for ent in doc.ents:
                        print(str(ent) + ' : ' + str(ent.start) + ' : ' + str(ent.end) + ' : ' + str(ent.label))
                        ent_starts.add(ent.start)
                    print()
                    print()
    #
                    spacy_rels = {}
    #
                    for x1 in ent_starts:
                        for x2 in ent_starts:
                            spacy_rels[(x1, x2)] = {}
    
                    print()
                    print()
                    print(str(spacy_rels))
                    print()
                    print()
    #
                    for rel in filtered_rels:
    #
    #                    if rel['label'] in rels:
    #
    #                    # the 'head' and 'child' annotations refer to the end token in the span
    #                    # but we want the first token
    #                    # ... what?

                            # you have headuid and childuid
                            # you need to know the first token of those ents

                        start = doc.ents[rel['head']].start
                        end = doc.ents[rel['child']].start
                        label = rels[rel["label"]]
    #
    #                    if label in MAP_LABELS:
    #                        rel_label = MAP_LABELS[label]
    #                        if rel_label not in rels[(start, end)]:
                        spacy_rels[(start, end)][label] = 1.0
    #
    #                    #print(json.dumps(pdatum))
    #                    #print(start)
    #                    #print(end)
    #                    #print(label)
    #                    
    #
                    # The annotation is complete, so fill in zero's where the data is missing
                    for x1 in ent_starts:
                        for x2 in ent_starts:
                            for label in rels.values():
                                if label not in spacy_rels[(x1, x2)]:
                                    spacy_rels[(x1, x2)][label] = 0.0
    #

                    print()
                    print()
                    print(str(spacy_rels))
                    print()
                    print()


    #                #print()
    #                #print(rels)
    #                #print()
    #               
                    doc._.rel = spacy_rels
    #
    #                #print()
    #                #print(doc._.rel)
    #                #print()
    #
    #                for rel in doc._.rel:
    #
    #                    pass
    #                    #print(str(rel[0]) + ' : ' + str(rel[1]) + ' : ' + str(doc._.rel[(rel[0], rel[1])]) + ' : ' + str(span_start_to_ent[rel[0]]) + ' : ' + str(span_start_to_ent[rel[1]]))
    #                    #print(str(rel[0]) + ' : ' + str(rel[1]) + ' : ' + str(doc._.rel[(rel[0], rel[1])]))
    #
    #
    #                #print()
    #
    #                # end of rels ##########################################################
    
            db.add(doc)

            if args.outfile is None:

                print()
                print()
                print(doc)
                print()
                print('doc has ' + str(len(doc.ents)) + ' ents')
                for ent in doc.ents:
                    print(str(ent.label) + ' ' + str(ent))
                print()
                print()
                print(str(doc._.rel))
                print()
                print()



        if args.outfile is not None:

            print('outfile: ' + str(args.outfile))
            db.to_disk(outfile)

