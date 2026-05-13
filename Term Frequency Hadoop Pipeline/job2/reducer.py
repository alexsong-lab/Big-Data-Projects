#!/usr/bin/env python3

# In: (docid, term_count)
# Out: (doc_id, doc_count)

import sys

# Current key field
current_docid = None        # docid (key)
current_doc_count = 0       # doc_count (value)

for line in sys.stdin:
    line = line.strip()
    if not line:
        continue

    # Input from mapper: docid \t term_count
    # Key: document_id
    # Value: term_count
    docid, count_str = line.split('\t')
    term_count = int(count_str)

    if docid == current_docid:
        current_doc_count += term_count
    else:
        # Emit previous (document_id, doc_count)
        if current_docid is not None:
            print(f"{current_docid}\t{current_doc_count}")

        # Start a new (docid, doc_count) k-v pair
        current_docid = docid
        current_doc_count = term_count

# Emit output k-v pair
if current_docid is not None:
    print(f"{current_docid}\t{current_doc_count}")
