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

            if endidx > startidx: # ignore empty labels

                text = self.text[startidx:endidx]

                numsearch = re.search(r"[0-9]", text) # SpaCy does not like numbers in entities
                if numsearch:
                    endidx = startidx + numsearch.span()[0] - 1
                    text = self.text[startidx:endidx]

                # SpaCy does not like a space at the start or end of a span. It makes the token boundaries not correllate with the span start and end character positions.
                if text.startswith(' '):
                    startidx = startidx + 1
                    text = self.text[startidx:endidx]

                if text.endswith(' '):
                    endidx = endidx - 1
                    text = self.text[startidx:endidx]

                if len(text) > 0: # Last check that we still have a label left

                    jsn = {}

                    jsn['label'] = tag
                    if tag in self.attributes:
                        jsn['uid'] = self.attributes[tag]
                        del self.attributes[tag]

                    jsn['start'] = startidx
                    jsn['end'] = endidx

                    self.labels.append(jsn)

        if tag == 'DIV':         

            jsn = {}
            jsn['uid'] = self.uid
            jsn['text'] = self.text
            jsn['spans'] = self.labels
            jsn['rels'] = self.rels

            prodigy.append(jsn)

            self.text = ''
            self.labels = []
            self.rels = []
            self.inside = {}
            self.attributes = {}
            self.uid = ''

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

    for file in todo:

        root = etree.parse(file)

        transformed_version = xslt(root)

        transformed_version_as_string = etree.tostring(transformed_version, encoding='unicode', method='xml')

        xml.sax.parseString(transformed_version_as_string, Handler)

    # Spit out a list of the labels we found
    span_labels = {}

    for pdatum in prodigy:
        for span in pdatum['spans']:
            span_label = span['label']
            if span_label in span_labels:
                span_labels[span_label] += 1
            else:
                span_labels[span_label] = 1

    span_labels_by_value = dict(sorted(span_labels.items(), key=lambda item: item[1], reverse=True))

    print()
    print("Span Labels: ")
    for span_label in span_labels_by_value:
        print(span_label + ' ' + str(span_labels_by_value[span_label]))

    # Spit out a list of the rels we found
    rel_labels = {}

    for pdatum in prodigy:
        for rel in pdatum['rels']:
            rel_label = rel['label']
            if rel_label in rel_labels:
                rel_labels[rel_label] += 1
            else:
                rel_labels[rel_label] = 1

    rel_labels_by_value = dict(sorted(rel_labels.items(), key=lambda item: item[1], reverse=True))

    print()
    print("Rel Labels: ")
    for rel_label in rel_labels_by_value:
        print(rel_label + ' ' + str(rel_labels_by_value[rel_label]))

    # Save our jsonl
    random.shuffle(prodigy)
    jsonfile = open("jsonl/obp.jsonl", "w")
    for pdatum in prodigy:
        jsonfile.write(json.dumps(pdatum) + '\n')

