#!/usr/bin/python3

import os
from lxml import etree
import xml.sax
import re
import json
import random

prodigy = []

class TEIHandler(xml.sax.ContentHandler):

    def __init__(self):
        self.text = ''
        self.labels = []
        self.rels = []
        self.inside = {}
        self.attributes = {}
        self.uid = ''


    def startElement(self, tag, attributes):

        if tag == 'DIV':

            if attributes.__contains__('id'):

                self.uid = attributes.getValue('id')

        if tag != 'DIVS' and tag != 'DIV':

            self.inside[tag] = len(self.text)

            if attributes.__contains__('id'):

                self.attributes[tag] = attributes.getValue('id')

            if tag == 'CHARGE':

                if attributes.__contains__('targets'):

                    targets = attributes.getValue('targets').split()

                    if len(targets) == 3:

                        relo = {}
                        relo['label'] = 'DEFOFF'
                        relo['headuid'] = targets[0]
                        relo['childuid'] = targets[1]

                        self.rels.append(relo)

                        relv = {}
                        relv['label'] = 'DEFVER'
                        relv['headuid'] = targets[0]
                        relv['childuid'] = targets[2]

                        self.rels.append(relv)

                    else:

                        print('bad charge targets: ' + str(targets))
                        #exit()

            if tag == 'PERSPLACE':

                if attributes.__contains__('targets'):

                    targets = attributes.getValue('targets').split()

                    rel = {}
                    rel['label'] = 'PERSPLACE'
                    rel['headuid'] = targets[0]
                    rel['childuid'] = targets[1]

                    self.rels.append(rel)

            if tag == 'PERSOCC':

                if attributes.__contains__('targets'):

                    targets = attributes.getValue('targets').split()

                    rel = {}
                    rel['label'] = 'PERSOCC'
                    rel['headuid'] = targets[0]
                    rel['childuid'] = targets[1]

                    self.rels.append(rel)

            if tag == 'OFFDATE':

                if attributes.__contains__('targets'):

                    targets = attributes.getValue('targets').split()

                    rel = {}
                    rel['label'] = 'OFFDATE'
                    rel['headuid'] = targets[0]
                    rel['childuid'] = targets[1]

                    self.rels.append(rel)

            if tag == 'OFFVIC':

                if attributes.__contains__('targets'):

                    targets = attributes.getValue('targets').split()

                    rel = {}
                    rel['label'] = 'OFFVIC'
                    rel['headuid'] = targets[0]
                    rel['childuid'] = targets[1]

                    self.rels.append(rel)

            if tag == 'DEFPUN':

                if attributes.__contains__('targets'):

                    targets = attributes.getValue('targets').split()

                    rel = {}
                    rel['label'] = 'DEFPUN'
                    rel['headuid'] = targets[0]
                    rel['childuid'] = targets[1]

                    self.rels.append(rel)


    def endElement(self, tag):

        if tag in self.inside:

            startidx = self.inside[tag]
            endidx = len(self.text)
            #print(str(startidx) + ' -> ' + str(endidx))
            #if startidx == None or endidx == None or tag == None:
            #    print('None')
            #    exit(1)

            if endidx > startidx: # ignore empty labels

                text = self.text[startidx:endidx]

                # Special process for offences
                #if tag == 'HOUSEBREAKING':
                #    res = re.search(r"breaking and entering", text)
                #    if res:
                #        startidx = startidx + res.span()[0]
                #        endidx = startidx + res.span()[1]
                #        text = self.text[startidx:endidx]

                numsearch = re.search(r"[0-9]", text) # Spacy does not like numbers in entities
                if numsearch:
                    #print(numsearch)
                    #print('**' + text + '**')
                    endidx = startidx + numsearch.span()[0] - 1
                    text = self.text[startidx:endidx]
                    #print('**' + text + '**')
                    #exit(1)
                #if self.text[startidx] == ' ': # Sometimes the tagging includes a space at the start
                #    startidx = startidx + 1

                if text.startswith(' '):
                    startidx = startidx + 1
                    text = self.text[startidx:endidx]

                if text.endswith(' '):
                    endidx = endidx - 1
                    text = self.text[startidx:endidx]

                #valid = True
                #if re.search(r"[0-9]", text): valid = False # Spacy does not seem to like entites with numbers in some configurations
                #if valid: self.labels.append((startidx, endidx, tag))

                if len(text) > 0: # Last check that we still have a label left

                    #self.labels.append((startidx, endidx, tag))
                    jsn = {}

                    jsn['label'] = tag
                    if tag in self.attributes:
                        jsn['uid'] = self.attributes[tag]
                        del self.attributes[tag]

                    jsn['start'] = startidx
                    jsn['end'] = endidx

                    self.labels.append(jsn)

        if tag == 'DIV':
            
            #print('\n' + self.text)
            #for label in self.labels:
            #    print(label)
            #    print('**' + self.text[label[0]:label[1]] + '**')

            #prodigy = [
            #    ("Tokyo Tower is 333m tall.", [(0, 11, "BUILDING")]),
            #]

            #if self.text == None or self.labels == None:
            #    print('None')
            #    exit(1)

            jsn = {}
            jsn['uid'] = self.uid
            jsn['text'] = self.text
            jsn['spans'] = self.labels
            jsn['rels'] = self.rels
            #jsn['rels'] = relations

            #prodigy.append((self.text, self.labels))

            prodigy.append(jsn)

            self.text = ''
            self.labels = []
            self.rels = []
            self.inside = {}
            self.attributes = {}
            self.uid = ''
            #self.intrial = False

    def characters(self, content):
        pass
        content = re.sub('\n', '', content).strip()
        if len(content) > 0:
            if content[0] != ',' and content[0] != '.' and len(self.text) > 0:
                content = ' ' + content
            self.text = self.text + content




if ( __name__ == "__main__"):

    todo = []
    teipath = os.path.expanduser("~/old-bailey/data/tei/sessionsPapers")
    teifiles = os.listdir(teipath)
    for file in teifiles:
        if file.startswith('173'): # For now we only process the 1730s
            todo.append(teipath + "/" + file)

    xsltfile = etree.parse('teiSessions.xslt')
    xslt = etree.XSLT(xsltfile)

    parser = xml.sax.make_parser()
    parser.setFeature(xml.sax.handler.feature_namespaces, 0)
    Handler = TEIHandler()
    parser.setContentHandler(Handler)

    #todo = todo[:1]

    for file in todo:

        print(file)
        root = etree.parse(file)
        xslt_version = xslt(root)

        data = etree.tostring(xslt_version, encoding='unicode', method='xml')
        #print(data)

        xml.sax.parseString(data, Handler)

    #print(len(prodigy))
    #print(json.dumps(prodigy[0]))

    # Remove the spans and rels we aren't interested in
    for pdatum in prodigy:
        pdatum['spans'] = list(filter(lambda x: x['label'] in ['DEFENDANT', 'GUILTY', 'NOTGUILTY'], pdatum['spans']))
        pdatum['rels'] = list(filter(lambda x: x['label'] in ['DEFVER'], pdatum['rels']))

    # Find spans which overlap and alter the second span to have a start and end of -1
    for pdatum in prodigy:
        for span in pdatum['spans']:
            for spanb in pdatum['spans']:
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
    for pdatum in prodigy:
        pdatum['spans'] = list(filter(lambda x: x['end'] - x['start'] > 0, pdatum['spans']))

    # Add the correct head and child index values to each rel, using the uids to look them up
    for pdatum in prodigy:

        for rel in pdatum['rels']:

            #print(rel['headuid'])

            try:
                rel['head'] = next(i for i,x in enumerate(pdatum['spans']) if 'uid' in x and x['uid'] == rel['headuid'])
            except StopIteration:
                #print('FAILED REL HEAD:' + rel['headuid']);
                rel['head'] = None

            #print(rel['childuid'])

            try:
                rel['child'] = next(i for i,x in enumerate(pdatum['spans']) if 'uid' in x and x['uid'] == rel['childuid'])
            except StopIteration:
                #print('FAILED REL CHILD:' + rel['childuid'])
                rel['child'] = None

    # Remove rels which no not have a valid head and child
    for pdatum in prodigy:
        pdatum['rels'] = list(filter(lambda x: x['head'] is not None and x['child'] is not None, pdatum['rels']))

    # Slim down the prodigy by removing fields which are not strictly neccessary
    for pdatum in prodigy:
        del pdatum['uid']
        for span in pdatum['spans']:
            if 'uid' in span: del span['uid']
        for rel in pdatum['rels']:
            del rel['headuid']
            del rel['childuid']

    #print(json.dumps(prodigy[0]))

    random.shuffle(prodigy)
    jsonfile = open("jsonl/obp.jsonl", "w")
    for pdatum in prodigy:
        jsonfile.write(json.dumps(pdatum) + '\n')

