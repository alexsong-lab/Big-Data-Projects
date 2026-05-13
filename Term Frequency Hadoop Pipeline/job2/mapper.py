#!/usr/bin/env python3

# In: (docid, term, term_count)
# Out: (docid, doc_count)

import sys

for line in sys.stdin:
    line = line.strip()
    if not line:
        continue

    # Input from Job 1 Reducer:
    # docid \t term \t term_count
    docid, term, term_count = line.split('\t')

    # Output key-value:
    # Only need docid and term_count
    # So reducer can sum the counts per document
    # Key: docid
    # Value: term_count
    print(f"{docid}\t{term_count}")
