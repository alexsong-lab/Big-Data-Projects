#!/usr/bin/env python3

# In: (docid, term, 1)
# Out: (docid, term, term_count)

import sys

# Current (document_id + term, count) key-value pair from mapper
current_docid = None        # docid (key part 1)
current_term = None         # term (key part 2)
current_term_count = 0      # accumulated count

for line in sys.stdin:
    line = line.strip()
    if not line:
        continue

    # Input from mapper: docid \t term \t 1
    docid, term, count_str = line.split('\t')
    term_count = int(count_str)

    # If this is the same (docid, term), accumulate
    if (docid, term) == (current_docid, current_term):
        current_term_count += term_count
    else:
        # Emit the previous key-value pair
        if current_docid is not None:
            print(f"{current_docid}\t{current_term}\t{current_term_count}")

        # Start a new (docid, term) pair
        current_docid = docid
        current_term = term
        current_term_count = term_count

# Emit the final key-value pair
if current_docid is not None:
    print(f"{current_docid}\t{current_term}\t{current_term_count}")
