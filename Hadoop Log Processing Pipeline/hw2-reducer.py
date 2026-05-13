#!/usr/bin/env python3
# Output should have the followings:
# Minute number (not hh:mm)
# Total number of log entries for that minute
# Number of log entries for that minute with severity INFO
# Number of log entries for that minute with severity WARN
# Number of log entries for that minute with severity ERROR
# Number of log entries for that minute with severity FATAL

# Input: minute-key, severity (data minute, severity)
# Output: minute number, total, info, warn, error, fatal

import sys

current_key = None
minute_number = 0
total = info = warn = error = fatal = 0

# note on code: idx:02d
# idx ensures a minute number is always 2 digits
# e.g., minute number 1 = 01, 2 = 02... n = nn
# expands as needed; 1234 = 1234
def emit(idx, total, info, warn, error, fatal):
    print(f"{idx:02d}\t{total}\t{info}\t{warn}\t{error}\t{fatal}")

for line in sys.stdin:
    line = line.strip()
    if not line:
        continue

    parts = line.split("\t")
    if len(parts) != 2:
        continue

    key, severity = line.split("\t")

    if severity not in ("INFO", "WARN", "ERROR", "FATAL"):
        continue

    if current_key != key:
        if current_key is not None:
            emit(minute_number, total, info, warn, error, fatal)

        minute_number += 1              # create a minute number
        current_key = key
        total = info = warn = error = fatal = 0

    # counter the total and for each severity
    total += 1
    if severity == "INFO":
        info += 1
    elif severity == "WARN":
        warn += 1
    elif severity == "ERROR":
        error += 1
    elif severity == "FATAL":
        fatal += 1

if current_key is not None:
    emit(minute_number, total, info, warn, error, fatal)