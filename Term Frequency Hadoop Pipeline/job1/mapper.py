#!/usr/bin/env python3
# In: line from a document
# Out: (docid, term, 1)

import sys
import re
import os

def termify(word):
    regex = re.compile('[^a-z]')
    return regex.sub('', word.lower())

for line in sys.stdin:
    # Hadoop provides the input filename via environment variable
    filename = os.getenv('map_input_file', '')
    docid = os.path.splitext(os.path.basename(filename))[0]

    for term in map(termify, line.strip().split()):
        if term:
            print(f"{docid}\t{term}\t1")
