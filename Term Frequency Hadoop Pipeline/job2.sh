#!/bin/bash
set -e
export HADOOP_HOME=/opt/hadoop

CURRENT_USER=$(whoami)
STREAMING_JAR="$HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-3.4.1.jar"
INPUT_PATH="/user/$CURRENT_USER/term-frequency/job1-out"
OUTPUT_PATH="/user/$CURRENT_USER/term-frequency/job2-out"

cleanup_output() {
  hdfs dfs -rm -r -f "$OUTPUT_PATH" >/dev/null 2>&1 || true
}

run_streaming_job() {
  "$HADOOP_HOME/bin/hadoop" jar "$STREAMING_JAR" \
    -files job2/mapper.py,job2/reducer.py \
    -mapper mapper.py \
    -reducer reducer.py \
    -input "$INPUT_PATH" \
    -output "$OUTPUT_PATH"
}

cleanup_output
run_streaming_job
