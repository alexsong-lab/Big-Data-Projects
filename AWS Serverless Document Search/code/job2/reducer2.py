#!/usr/bin/env python3

import sys


def _emit_document_total(doc_id, document_count):
    print(f"{doc_id}\t{document_count}")


def main():
    active_doc_id = None
    accumulated_count = 0

    for raw_line in sys.stdin:
        line_text = raw_line.strip()
        if not line_text:
            continue

        doc_id, count_text = line_text.split("\t")
        token_count = int(count_text)

        if doc_id == active_doc_id:
            accumulated_count += token_count
            continue

        if active_doc_id is not None:
            _emit_document_total(active_doc_id, accumulated_count)

        active_doc_id = doc_id
        accumulated_count = token_count

    if active_doc_id is not None:
        _emit_document_total(active_doc_id, accumulated_count)


if __name__ == "__main__":
    main()
