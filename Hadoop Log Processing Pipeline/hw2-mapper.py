#!/usr/bin/env python3
# Need to extract the following information for each log entry:
# Minute, Severity
# note: minute must be shown as a minute number
# Input: yyyy-mm-dd hh:mm:ss,ms, severity
# Key-value pair: minute-key, severity (data minute, severity)

import sys

for line in sys.stdin:
    line = line.strip()
    if not line:
        continue

    parts = line.split()
    if len(parts) < 3:
        continue

# Extract time(minute), severity (yyyy-mm-dd hh:mm:ss,ms, severity)
    try:
        date = parts[0]
        time = parts[1]
        severity = parts[2]
    except IndexError:
        continue

    # extract minute and store a key
    minute = time[:5]
    minute_key = f"{date} {minute}"

    if severity in ["INFO", "WARN", "ERROR", "FATAL"]:
        print(f"{minute_key}\t{severity}")


