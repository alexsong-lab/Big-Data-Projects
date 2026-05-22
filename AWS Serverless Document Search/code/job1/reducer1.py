#!/usr/bin/env python3

import sys


def _emit_pair(doc_id, token, count_total):
    print(f"{doc_id}\t{token}\t{count_total}")


def main():
    previous_key = None
    running_count = 0

    for raw_line in sys.stdin:
        line_text = raw_line.strip()
        if not line_text:
            continue

        doc_id, token, count_text = line_text.split("\t")
        parsed_count = int(count_text)
        current_key = (doc_id, token)

        if previous_key is None:
            previous_key = current_key
            running_count = parsed_count
            continue

        if current_key == previous_key:
            running_count += parsed_count
            continue

        _emit_pair(previous_key[0], previous_key[1], running_count)
        previous_key = current_key
        running_count = parsed_count

    if previous_key is not None:
        _emit_pair(previous_key[0], previous_key[1], running_count)


if __name__ == "__main__":
    main()
