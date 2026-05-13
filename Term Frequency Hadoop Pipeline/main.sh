#!/bin/bash
set -e
export HADOOP_HOME=/opt/hadoop

USER_NAME=$(whoami)
HIVE_OUT=/user/$USER_NAME/term-frequency/tf-hive-out
LOCAL_OUT=tf.txt

echo "Running Job 1......"
bash job1.sh

echo "Running Job 2......"
bash job2.sh

echo "Cleaning Hive output directory......"
hdfs dfs -rm -r -f "$HIVE_OUT" >/dev/null 2>&1 || true

echo "Running Hive query..."
beeline -u jdbc:hive2://localhost:10000 \
  --hivevar USER_NAME="$USER_NAME" \
  -e "$(cat tf.hql)"

echo "Merging Hive output into tf.txt......"
rm -f "$LOCAL_OUT"
hdfs dfs -getmerge "$HIVE_OUT" "$LOCAL_OUT"

echo "Cleaning up HDFS temporary directories......"
hdfs dfs -rm -r -f "/user/$USER_NAME/term-frequency/job1-out"
hdfs dfs -rm -r -f "/user/$USER_NAME/term-frequency/job2-out"
hdfs dfs -rm -r -f "$HIVE_OUT"

echo "Output written to $LOCAL_OUT"
