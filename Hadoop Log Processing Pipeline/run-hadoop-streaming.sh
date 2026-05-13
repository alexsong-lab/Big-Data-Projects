#!/usr/bin/bash
# Usage: ./run-hadoop-streaming.sh <hdfs-input-dir> <hdfs-output-dir>

INPUT=$1
OUTPUT=$2

$HADOOP_HOME/bin/hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-3.4.1.jar \
    -files   hw2-mapper.py,hw2-reducer.py \
    -input   $INPUT             \
    -output  $OUTPUT            \
    -mapper  hw2-mapper.py  \
    -reducer hw2-reducer.py
