#!/usr/bin/python3

import argparse
from tqdm import tqdm
import json
import spacy
from spacy.tokens import DocBin, Doc

if ( __name__ == "__main__"):

    parser = argparse.ArgumentParser(description='Process a Protege-style jsonl file into a spacy DocBin file.', formatter_class=argparse.ArgumentDefaultsHelpFormatter)

    parser.add_argument('infile', help='The jsonl file to read from.')
    parser.add_argument('-o', '--outfile', help='The desired path and filename for the DocBin file which will be written. If this is not specified, the program will do a dry run, outputting debug information without saving a file.')
    parser.add_argument('-s', '--start', type=int, default=0, help='The line to begin reading the jsonl file from.')
    parser.add_argument('-e', '--end', type=int, help='The line on which to stop reading the jsonl file (defaults to the final line in the file).')
    parser.add_argument('-en', '--ents', help='Comma separated list of ents to read from the jsonl file and after a colon, the desired name of each in the DocBin file. eg. VICTIM:PER,DEFENDANT:PER . If you specify this option, a line will not be included in the DocBin unless it has at least one qualifying ent.')
    parser.add_argument('-re', '--rels', help='Comma separated list of rels to read from the jsonl file and after a colon, the desired name of each in the DocBin file. eg. PERSPLACE:PERPLACE,PERSOCC:PEROCC . If you specify this option, a line will not be included in the DocBin unless it has at least one qualifying rel')
    parser.add_argument('-max', '--maxlen', type=int, default=1000000,help='Maximum length in characters of the text field in each json line which will be included in the output DocBin. i.e. all lines with a longer text field will be omitted.')
    parser.add_argument('-min', '--minlen', type=int, default=4, help='Minimum length in characters of the text field in each json line which will be included in the output DocBin. i.e. all lines with a shorter text field will be omitted.')
    parser.add_argument('-rmt', '--relmaxtok', type=int, default=100, help='The maximum number of tokens which a rel should be allowed to span. Relationships which span more tokens than this will be ignored.')

    args = parser.parse_args()

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

    print('infile: ' + str(args.infile))

    with open(args.infile, 'r') as jsonfile:

        jsonlines = list(jsonfile)

        end = len(jsonlines)
        print(str(end) + ' lines')

        if args.end: end = int(args.end)

        print('Will process lines ' + str(args.start) + ' to ' + str(end))

        nlp = spacy.blank("en")

        db = None

        if len(rels) > 0:

            Doc.set_extension("rel", default={}) # rels
            db = DocBin(store_user_data=True) # rels

        else:

            db = DocBin()

        docs_attempted = 0
        docs_added = 0
        rejected_spans = [];

        for jsonline in tqdm(jsonlines[args.start:end], ascii=True, ncols=60):

            docs_attempted += 1
            suitable = True

            jd = json.loads(jsonline)
            
            if len(jd['text']) < args.minlen or len(jd['text']) > args.maxlen:

                suitable = False

            else:

                doc = nlp(jd['text'])

                if len(ents) > 0:

                    assigned_ents = 0

                    # We need to keep a separate array of the ents we actually add, so that we can refer to them by position later on when we are adding the rels.
                    filtered_spans = list(filter(lambda x: x['label'] in ents, jd['spans']))

                    # Find spans which overlap and alter the second span to have a start and end of -1
                    for span in filtered_spans:
                        for spanb in filtered_spans:
                            if span != spanb:
                                x_start = span['start']
                                x_end = span['end']
                                y_start = spanb['start']
                                y_end = spanb['end']
                                if x_start <= y_end and y_start <= x_end:
                                #if x2 >= y1 and x1 <= y2:
                                    #print('OVERLAP')
                                    #print(json.dumps(span))
                                    #print(json.dumps(spanb))
                                    spanb['start'] = -1
                                    spanb['end'] = -1
                                    #spanb['overlap'] = True;
                                    #print(json.dumps(pdatum))
                        
                    # Remove spans with zero length (should include the overlapping spans we just found)
                    filtered_spans = list(filter(lambda x: x['end'] - x['start'] > 0, filtered_spans))

                    spacy_ents = []
                    
                    for span in filtered_spans:               

                        spacy_ent = doc.char_span(span['start'], span['end'], label=ents[span['label']])

                        if spacy_ent is None:

                            rejected_spans.append(str(span) + ' Five chars either side: ***' + jd['text'][span['start'] - 5:span['end'] + 5] + '***')
                            jd['rels'] = []
                            suitable = False

                        else:

                            spacy_ents.append(spacy_ent)
                            assigned_ents += 1
                    

                    #print(spacy_ents)

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

                        assigned_rels = 0

                        # Filter out the rels which we are not interested in
                        filtered_rels = list(filter(lambda x: x['label'] in rels, jd['rels']))

                        # Add the correct head and child index values to each rel, using the uids to look them up                 
                        for rel in filtered_rels:                  
                    
                            try:
                                rel['head'] = next(i for i,x in enumerate(filtered_spans) if 'uid' in x and x['uid'] == rel['headuid'])
                            except StopIteration:
                                #print('FAILED REL HEAD:' + rel['headuid']);
                                rel['head'] = None                  
                    
                            try:
                                rel['child'] = next(i for i,x in enumerate(filtered_spans) if 'uid' in x and x['uid'] == rel['childuid'])
                            except StopIteration:
                                #print('FAILED REL CHILD:' + rel['childuid'])
                                rel['child'] = None

                        # Remove rels which no not have a valid head and child
                        filtered_rels = list(filter(lambda x: x['head'] is not None and x['child'] is not None, filtered_rels))

                        # Create a dictionary so we can look up each ent using its starting token
                        ent_starts_dict = {}
                        for ent in doc.ents: ent_starts_dict[ent.start] = ent

                        # The structure of the spacy rels is a dictonary where the key is a tuple of the fist token of the head and the child ent
                        # The value of each of these entries is a further dictionary where the keys are the relationship labels and the values are the likelihood of that relationship being correct
                        # eg: {(2, 2): {'PERPLA': 0.0, 'PEROCC': 0.0}, (2, 26): {'PERPLA': 0.0, 'PEROCC': 0.0}, (26, 2): {'PERPLA': 0.0, 'PEROCC': 0.0}, (26, 26): {'PERPLA': 0.0, 'PEROCC': 0.0}}
                        spacy_rels = {}

                        # First, use the ent_starts_dict to set up the empty dictionaries for each possible combination of entity start tokens
                        for x1 in ent_starts_dict:
                            for x2 in ent_starts_dict:
                                spacy_rels[(x1, x2)] = {}
        

                        # Work through the rels we are interested in, assigining a value of 1.0 to the relevant relationship label for key representing that combination of ent starting tokens in the spacy_rels dictionary.
                        for rel in filtered_rels:

                            start = doc.ents[rel['head']].start
                            end = doc.ents[rel['child']].start
                            label = rels[rel["label"]]

                            # Only assign the relationship if the total range of tokens the model will have to consider is not too large
                            relfirsttok = min(doc.ents[rel['head']].start, doc.ents[rel['head']].end, doc.ents[rel['child']].start, doc.ents[rel['child']].end);
                            rellasttok = max(doc.ents[rel['head']].start, doc.ents[rel['head']].end, doc.ents[rel['child']].start, doc.ents[rel['child']].end);
                            if rellasttok - relfirsttok <= args.relmaxtok:

                                spacy_rels[(start, end)][label] = 1.0
                                assigned_rels += 1

                        # When we have finished assigning 1.0s (representing a correct relationship) where needed, fill in the rest of the labels with 0.0s (no relationship)
                        for x1 in ent_starts_dict:
                            for x2 in ent_starts_dict:
                                for label in rels.values():
                                    if label not in spacy_rels[(x1, x2)]:
                                        spacy_rels[(x1, x2)][label] = 0.0

                        # If we didn't assign any correct relationships, then this document is not suitable for inclusion in the docbin.
                        if assigned_rels == 0: suitable = False

                        doc._.rel = spacy_rels

                if args.outfile is None:

                    # If we have no outfile then we display lots of useful informtaion about the finished doc
                    print()
                    print('----------------------------------------------------------------')
                    print()
                    print(doc)
                    print()
                    print('doc has ' + str(len(doc.ents)) + ' ents')
                    print()
                    for idx, ent in enumerate(doc.ents):
                        print(ents[filtered_spans[idx]['label']] + ' ' + str(ent.label).ljust(20) + ' ' + str(ent.start).ljust(3) + '-> ' + str(ent.end).ljust(3) + ' ' + str(ent) + ' ' + str(filtered_spans[idx]))
                    print()

                    if len(rels) > 0:
                        #print(str(doc._.rel))
                        #print()
                        print('doc has ' + str(assigned_rels) + ' assigned rels')
                        print()
                        for rel in doc._.rel:
                            head = rel[0]
                            child = rel[1]
                            vals = doc._.rel[(rel[0], rel[1])]
                            for val in vals:
                                if vals[val] > 0:
                                    headent = ent_starts_dict[head]
                                    childent = ent_starts_dict[child]
                                    headidx = doc.ents.index(headent)
                                    childidx = doc.ents.index(childent)
                                    headspan = filtered_spans[headidx]
                                    childspan = filtered_spans[childidx]
                                    print(val)
                                    print('+ ' + ents[headspan['label']] + ' ' + str(headent.label).ljust(20) + ' ' + str(headent.start).ljust(3) + '-> ' + str(headent.end).ljust(3) + ' ' + str(headent) + ' ' + str(headspan))
                                    print('+ ' + ents[childspan['label']] + ' ' + str(childent.label).ljust(20) + ' ' + str(childent.start).ljust(3) + '-> ' + str(childent.end).ljust(3) + ' ' + str(childent) + ' ' + str(childspan))
                                    print()                                  

                    if suitable:

                        print('Doc was added.')
                        print()

                    else:

                        print('Doc was not suitable.')
                        print()

            if suitable:

                db.add(doc)
                docs_added += 1

        print('Added ' + str(docs_added) + ' docs from ' + str(docs_attempted) + ' attempted (' + str((docs_added / docs_attempted) * 100) + '%).')

        print(str(len(rejected_spans)) + ' rejected spans:')
        for rejected_span in rejected_spans:
            print(rejected_span)

        if args.outfile is not None:

            print('outfile: ' + str(args.outfile))
            db.to_disk(args.outfile)

