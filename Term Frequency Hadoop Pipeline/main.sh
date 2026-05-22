#!/bin/bash
set -e
export HADOOP_HOME=/opt/hadoop

CURRENT_USER=$(whoami)
HIVE_EXPORT_PATH="/user/$CURRENT_USER/term-frequency/tf-hive-out"
LOCAL_OUTPUT_FILE=tf.txt

run_jobs() {
  echo "Running job 1..."
  bash job1.sh

  echo "Running job 2..."
  bash job2.sh
}

run_hive_step() {
  echo "Refreshing Hive output directory..."
  hdfs dfs -rm -r -f "$HIVE_EXPORT_PATH" >/dev/null 2>&1 || true

  echo "Executing Hive query..."
  beeline -u jdbc:hive2://localhost:10000 \
    --hivevar USER_NAME="$CURRENT_USER" \
    -e "$(cat tf.hql)"
}

collect_result_file() {
  echo "Merging Hive output into $LOCAL_OUTPUT_FILE..."
  rm -f "$LOCAL_OUTPUT_FILE"
  hdfs dfs -getmerge "$HIVE_EXPORT_PATH" "$LOCAL_OUTPUT_FILE"
}

cleanup_intermediate_data() {
  echo "Cleaning temporary HDFS paths..."
  hdfs dfs -rm -r -f "/user/$CURRENT_USER/term-frequency/job1-out"
  hdfs dfs -rm -r -f "/user/$CURRENT_USER/term-frequency/job2-out"
  hdfs dfs -rm -r -f "$HIVE_EXPORT_PATH"
}

run_jobs
run_hive_step
collect_result_file
cleanup_intermediate_data

echo "Output written to $LOCAL_OUTPUT_FILE"
