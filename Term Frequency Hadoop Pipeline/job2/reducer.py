#!/usr/bin/env python3

import sys


def emit_document_total(doc_id, total_tokens):
    print(f"{doc_id}\t{total_tokens}")


def main():
    active_doc_id = None
    running_total = 0

    for raw_line in sys.stdin:
        line_text = raw_line.strip()
        if not line_text:
            continue

        doc_id, count_text = line_text.split("\t")
        token_count = int(count_text)

        if doc_id == active_doc_id:
            running_total += token_count
            continue

        if active_doc_id is not None:
            emit_document_total(active_doc_id, running_total)

        active_doc_id = doc_id
        running_total = token_count

    if active_doc_id is not None:
        emit_document_total(active_doc_id, running_total)


if __name__ == "__main__":
    main()
