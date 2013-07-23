#!/usr/bin/env python
import sys
import cStringIO
import xml.etree.ElementTree as xml

def clean(element):
    result = None
    if element is not None and element.text is not None:
        result = element.text
        result = result.strip()
    else:
        result = ""
    return result

def count(val):
    return len(val.split())

def process(val):
    root = xml.fromstring(val)

    title = clean(root.find('title'))
    text = clean(root.find('revision/text'))

    returnval = ("%s\t%s") % (title,count(text))
    return returnval.strip()

if __name__ == '__main__':
    buff = None

    for line in sys.stdin:
        line = line.strip()
        if line.find("<page>") != -1:
            buff = cStringIO.StringIO()
            buff.write(line)
        elif line.find("</page>") != -1:
            buff.write(line)
            val = buff.getvalue()
            buff.close()
            buff = None
            print process(val).encode('ascii', 'ignore')
        else:
            if buff is not None:
                buff.write(line)
