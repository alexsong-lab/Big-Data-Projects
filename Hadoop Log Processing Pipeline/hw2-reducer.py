#!/usr/bin/env python3

import sys


def emit_row(minute_index, counters):
    print(
        f"{minute_index:02d}\t{counters['total']}\t{counters['INFO']}\t"
        f"{counters['WARN']}\t{counters['ERROR']}\t{counters['FATAL']}"
    )


def new_counters():
    return {"total": 0, "INFO": 0, "WARN": 0, "ERROR": 0, "FATAL": 0}


def main():
    known_levels = {"INFO", "WARN", "ERROR", "FATAL"}
    current_bucket = None
    minute_sequence = 0
    counters = new_counters()

    for incoming_line in sys.stdin:
        line_text = incoming_line.strip()
        if not line_text:
            continue

        fields = line_text.split("\t")
        if len(fields) != 2:
            continue

        minute_bucket, severity_name = fields
        if severity_name not in known_levels:
            continue

        if minute_bucket != current_bucket:
            if current_bucket is not None:
                emit_row(minute_sequence, counters)
            minute_sequence += 1
            current_bucket = minute_bucket
            counters = new_counters()

        counters["total"] += 1
        counters[severity_name] += 1

    if current_bucket is not None:
        emit_row(minute_sequence, counters)


if __name__ == "__main__":
    main()