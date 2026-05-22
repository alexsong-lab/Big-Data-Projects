#!/usr/bin/bash

INPUT_PATH=$1
OUTPUT_PATH=$2
STREAMING_JAR="$HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-3.4.1.jar"

"$HADOOP_HOME/bin/hadoop" jar "$STREAMING_JAR" \
    -files hw2-mapper.py,hw2-reducer.py \
    -input "$INPUT_PATH" \
    -output "$OUTPUT_PATH" \
    -mapper hw2-mapper.py \
    -reducer hw2-reducer.py
