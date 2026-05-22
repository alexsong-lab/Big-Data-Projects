#!/usr/bin/env python3

import os
import re
import sys

NON_ALPHA = re.compile(r"[^a-z]")


def normalize_token(raw_word):
    return NON_ALPHA.sub("", raw_word.lower())


def resolve_document_id():
    source_path = os.getenv("map_input_file", "")
    return os.path.splitext(os.path.basename(source_path))[0]


def main():
    doc_id = resolve_document_id()
    for raw_line in sys.stdin:
        tokens = raw_line.strip().split()
        for normalized_token in map(normalize_token, tokens):
            if normalized_token:
                print(f"{doc_id}\t{normalized_token}\t1")


if __name__ == "__main__":
    main()
