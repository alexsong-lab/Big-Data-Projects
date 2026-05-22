#!/usr/bin/bash

SCRIPT_ROOT=$(dirname "$0")
LOCAL_INPUT_PATH=$1
HDFS_OUTPUT_PATH=$2

if [[ -z "$LOCAL_INPUT_PATH" || -z "$HDFS_OUTPUT_PATH" ]]; then
    echo "Usage: $0 <local-input-directory> <hdfs-output-dir>"
    exit 1
fi

DATASET_NAME=$(basename "$LOCAL_INPUT_PATH")
HDFS_INPUT_PATH="/hw2/e2e/input/$DATASET_NAME"
STREAMING_JAR="$HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-3.4.1.jar"

prepare_input_path() {
    hdfs dfs -rm -r -f "$HDFS_INPUT_PATH"
    hdfs dfs -mkdir -p "$HDFS_INPUT_PATH"
    hdfs dfs -put "$LOCAL_INPUT_PATH" /hw2/e2e/input/
}

run_pipeline() {
    "$HADOOP_HOME/bin/hadoop" jar "$STREAMING_JAR" \
        -files "$SCRIPT_ROOT"/hw2-mapper.py,"$SCRIPT_ROOT"/hw2-reducer.py \
        -input "$HDFS_INPUT_PATH" \
        -output "$HDFS_OUTPUT_PATH" \
        -mapper hw2-mapper.py \
        -reducer hw2-reducer.py
}

print_output() {
    echo "--- Log summary by minute ---"
    hdfs dfs -cat "$HDFS_OUTPUT_PATH"/part-* | sort -k1,1n
    echo "-----------------------------------------------"
}

cleanup_paths() {
    hdfs dfs -rm -r "$HDFS_INPUT_PATH"
    hdfs dfs -rm -r "$HDFS_OUTPUT_PATH"
}

prepare_input_path
echo "Input (from $LOCAL_INPUT_PATH) uploaded to HDFS: $HDFS_INPUT_PATH"
run_pipeline
echo "MapReduce job complete. Output at: $HDFS_OUTPUT_PATH"
print_output
cleanup_paths
echo "Cleaned up HDFS input: $HDFS_INPUT_PATH"
echo "Cleaned up HDFS output: $HDFS_OUTPUT_PATH"