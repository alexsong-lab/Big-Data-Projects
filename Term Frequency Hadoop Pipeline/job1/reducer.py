#!/usr/bin/env python3

import sys


def emit_term_count(doc_id, token, count_total):
    print(f"{doc_id}\t{token}\t{count_total}")


def main():
    active_key = None
    running_total = 0

    for raw_line in sys.stdin:
        line_text = raw_line.strip()
        if not line_text:
            continue

        doc_id, token, count_text = line_text.split("\t")
        increment = int(count_text)
        parsed_key = (doc_id, token)

        if active_key is None:
            active_key = parsed_key
            running_total = increment
            continue

        if parsed_key == active_key:
            running_total += increment
            continue

        emit_term_count(active_key[0], active_key[1], running_total)
        active_key = parsed_key
        running_total = increment

    if active_key is not None:
        emit_term_count(active_key[0], active_key[1], running_total)


if __name__ == "__main__":
    main()
