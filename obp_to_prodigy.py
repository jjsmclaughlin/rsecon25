#!/usr/bin/python3

import os
from lxml import etree
import xml.sax
import re
import json

examples = []

class TEIHandler(xml.sax.ContentHandler):

    def __init__(self):
        self.text = ''
        self.labels = []
        self.inside = {}
        self.attributes = {}

    def startElement(self, tag, attributes):
        if tag != 'DIVS' and tag != 'DIV':
            self.inside[tag] = len(self.text)
            if attributes.__contains__('id'):
                self.attributes[tag] = attributes.getValue('id')

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

                    if tag in self.attributes:
                        jsn['uid'] = self.attributes[tag]
                        del self.attributes[tag]

                    jsn['start'] = startidx
                    jsn['end'] = endidx
                    jsn['label'] = tag
                    self.labels.append(jsn)
        if tag == 'DIV':
            
            #print('\n' + self.text)
            #for label in self.labels:
            #    print(label)
            #    print('**' + self.text[label[0]:label[1]] + '**')

            #examples = [
            #    ("Tokyo Tower is 333m tall.", [(0, 11, "BUILDING")]),
            #]

            #if self.text == None or self.labels == None:
            #    print('None')
            #    exit(1)

            jsn = {}
            #jsn['uid'] = ''
            jsn['text'] = self.text
            jsn['spans'] = self.labels
            #jsn['rels'] = relations

            #examples.append((self.text, self.labels))

            examples.append(jsn);

            self.text = ''
            self.labels = []
            self.intrial = False

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

    todo = todo[:1]

    for file in todo:

        print(file)
        root = etree.parse(file)
        xslt_version = xslt(root)

        data = etree.tostring(xslt_version, encoding='unicode', method='xml')
        print(data)

        xml.sax.parseString(data, Handler)

    print(len(examples))
    print(json.dumps(examples[0]))

    #jsonfile = open("ob.jsonl", "w")

    #for example in examples:

    #    jsonfile.write(json.dumps(example) + '\n')

