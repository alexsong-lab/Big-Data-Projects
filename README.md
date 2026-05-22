# Data Engineering Portfolio Projects

This repository contains three independent data-processing projects built around Hadoop, Hive, and AWS serverless components.

## Projects

### AWS Serverless Document Search
- Builds a TF-IDF index from a text corpus.
- Stores index and metadata in DynamoDB.
- Exposes search through an AWS Lambda endpoint and static HTML page.

### Hadoop Log Processing Pipeline
- Parses distributed log files with Hadoop Streaming.
- Aggregates severity counts in minute buckets.
- Provides shell scripts for end-to-end execution on HDFS.

### Term Frequency Hadoop Pipeline
- Runs a two-job MapReduce workflow for term counting.
- Joins intermediate outputs with Hive.
- Produces per-document term-frequency results.

## Tooling
- Python 3
- Hadoop Streaming
- Hive / Beeline
- Shell scripting
- AWS (EMR, DynamoDB, Lambda, S3)