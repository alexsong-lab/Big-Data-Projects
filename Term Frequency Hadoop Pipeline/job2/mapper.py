#!/usr/bin/env python3

import sys


def main():
    for raw_line in sys.stdin:
        line_text = raw_line.strip()
        if not line_text:
            continue

        doc_id, _, token_count = line_text.split("\t")
        print(f"{doc_id}\t{token_count}")


if __name__ == "__main__":
    main()
