#!/bin/bash
set -e
export HADOOP_HOME=/opt/hadoop

USER_NAME=$(whoami)

HDFS_INPUT=/textcorpora
HDFS_OUTPUT=/user/$USER_NAME/term-frequency/job1-out

hdfs dfs -rm -r -f "$HDFS_OUTPUT" >/dev/null 2>&1 || true

$HADOOP_HOME/bin/hadoop jar \
  $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-3.4.1.jar \
    -D stream.num.map.output.key.fields=2 \
    -files job1/mapper.py,job1/reducer.py \
    -mapper mapper.py \
    -reducer reducer.py \
    -input "$HDFS_INPUT" \
    -output "$HDFS_OUTPUT"
