# Hadoop Log Processing Pipeline

This project parses application log files with Hadoop Streaming and produces per-minute severity summaries.

## Output Contract

Each output line includes:

1. Minute sequence number (formatted with leading zeroes when needed)
2. Total event count
3. INFO count
4. WARN count
5. ERROR count
6. FATAL count

## Directory Layout

```
Hadoop Log Processing Pipeline/
├── hw2-mapper.py
├── hw2-reducer.py
├── run-hadoop-streaming.sh
├── process-log-file.sh
├── logs/
└── README.md
```

## Usage

### Local Stream Test

```
cat logs/<file>.log | ./hw2-mapper.py | sort | ./hw2-reducer.py
```

### Hadoop Streaming (single input folder)

```
./run-hadoop-streaming.sh <hdfs-input-dir> <hdfs-output-dir>
```

### End-to-End Run With Auto Cleanup

```
./process-log-file.sh logs /hw2/full-output
```

The script uploads input, runs streaming, prints sorted results, and removes temporary HDFS paths.

## Processing Logic

- Mapper extracts minute buckets from timestamps and emits `(minute_key, severity)`.
- Reducer groups by minute key and computes total/severity counters.
- Final output stays tab-delimited for easy downstream processing.

## Stack

- Python 3
- Hadoop Streaming
- HDFS CLI
- Bash