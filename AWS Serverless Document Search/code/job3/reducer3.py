#!/usr/bin/env python3

import sys


def main():
    active_term = None
    running_frequency = 0

    for raw_line in sys.stdin:
        line_text = raw_line.strip()
        if not line_text:
            continue

        token, count_text = line_text.split("\t")
        parsed_count = int(count_text)

        if token == active_term:
            running_frequency += parsed_count
            continue

        if active_term is not None:
            print(f"{active_term}\t{running_frequency}")

        active_term = token
        running_frequency = parsed_count

    if active_term is not None:
        print(f"{active_term}\t{running_frequency}")


if __name__ == "__main__":
    main()
