#!/bin/bash
# Runs MapReduce Job 2: (docid, doc_count)

set -e
export HADOOP_HOME=/opt/hadoop

USER_NAME=$(whoami)

HDFS_INPUT=/user/$USER_NAME/term-frequency/job1-out
HDFS_OUTPUT=/user/$USER_NAME/term-frequency/job2-out

# Clean previous output
hdfs dfs -rm -r -f "$HDFS_OUTPUT" >/dev/null 2>&1 || true

$HADOOP_HOME/bin/hadoop jar \
  $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-3.4.1.jar \
    -files job2/mapper.py,job2/reducer.py \
    -mapper mapper.py \
    -reducer reducer.py \
    -input "$HDFS_INPUT" \
    -output "$HDFS_OUTPUT"
