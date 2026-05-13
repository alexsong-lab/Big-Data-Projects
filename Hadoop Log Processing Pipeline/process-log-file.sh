#!/usr/bin/bash
# Usage: ./process-log-file.sh <local-input-directory> <hdfs-output-dir>

SCRIPT_DIR=$(dirname "$0")
LOCAL_INPUT_DIR=$1
HDFS_OUTPUT_DIR=$2

# ensure non-empty LOCAL_INPUT_DIR and HDFS_OUTPUT_DIR
if [[ -z "$LOCAL_INPUT_DIR" || -z "$HDFS_OUTPUT_DIR" ]]; then
    echo "Usage: $0 <local-input-directory> <hdfs-output-dir>"
    exit 1
fi


DATA_DIR_NAME=$(basename $LOCAL_INPUT_DIR)   # basename extracts the last component, e.g. "data" from "../../data"

HDFS_INPUT_DIR=/hw2/e2e/input/"$DATA_DIR_NAME"

# remove the folder if it exists.
hdfs dfs -rm -r -f $HDFS_INPUT_DIR
# make the parent folder.
hdfs dfs -mkdir -p $HDFS_INPUT_DIR

# Upload input to HDFS
hdfs dfs -put "$LOCAL_INPUT_DIR" /hw2/e2e/input/

echo "Input (from $LOCAL_INPUT_DIR) uploaded to HDFS: $HDFS_INPUT_DIR"

# Run word count via Hadoop Streaming
$HADOOP_HOME/bin/hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-3.4.1.jar \
    -files "$SCRIPT_DIR"/hw2-mapper.py,"$SCRIPT_DIR"/hw2-reducer.py \
    -input  $HDFS_INPUT_DIR  \
    -output $HDFS_OUTPUT_DIR              \
    -mapper  hw2-mapper.py \
    -reducer hw2-reducer.py

echo "MapReduce job complete. Output at: $HDFS_OUTPUT_DIR"

echo "--- Log summary by minute ---"

# Stream output through local post-processing: filter, sort by frequency, top 10
hdfs dfs -cat $HDFS_OUTPUT_DIR/part-* \
  | sort -k1,1n

echo "-----------------------------------------------"

# clean up.
hdfs dfs -rm -r $HDFS_INPUT_DIR
hdfs dfs -rm -r $HDFS_OUTPUT_DIR

echo "Cleaned up HDFS input: $HDFS_INPUT_DIR"
echo "Cleaned up HDFS output: $HDFS_OUTPUT_DIR"