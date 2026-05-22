#!/usr/bin/env python3

import sys


def main():
    for raw_line in sys.stdin:
        line_text = raw_line.strip()
        if not line_text:
            continue

        _, token, _ = line_text.split("\t")
        print(f"{token}\t1")


if __name__ == "__main__":
    main()
