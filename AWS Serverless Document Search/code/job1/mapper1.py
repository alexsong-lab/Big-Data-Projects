#!/usr/bin/env python3

import os
import sys

sys.path.append(os.getcwd())  # Allow importing local helper module.

from termify import termify


def _extract_document_id():
    mapper_source = os.environ.get("map_input_file") or os.environ.get("mapreduce_map_input_file")
    if not mapper_source:
        return "unknown"
    return os.path.splitext(os.path.basename(mapper_source))[0]


def main():
    document_id = _extract_document_id()
    for raw_line in sys.stdin:
        line_text = raw_line.strip()
        if not line_text:
            continue
        for token in termify(line_text):
            print(f"{document_id}\t{token}\t1")


if __name__ == "__main__":
    main()