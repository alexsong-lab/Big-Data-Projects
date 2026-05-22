#!/usr/bin/env python3

import sys


def parse_event(raw_line):
    segments = raw_line.split()
    if len(segments) < 3:
        return None, None

    event_date = segments[0]
    event_time = segments[1]
    severity_name = segments[2]
    minute_bucket = f"{event_date} {event_time[:5]}"
    return minute_bucket, severity_name


def main():
    allowed_levels = {"INFO", "WARN", "ERROR", "FATAL"}
    for incoming_line in sys.stdin:
        cleaned_line = incoming_line.strip()
        if not cleaned_line:
            continue

        minute_key, level = parse_event(cleaned_line)
        if minute_key and level in allowed_levels:
            print(f"{minute_key}\t{level}")


if __name__ == "__main__":
    main()

