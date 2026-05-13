# **Hadoop Log Processing Pipeline**

> A Hadoop Streaming workflow that parses log files, aggregates counts by minute, and summarizes INFO/WARN/ERROR/FATAL events.

---

## **Project Overview**

This project processes a directory of log files using a Python-based Hadoop Streaming pipeline. The goal is to extract timestamps, bucket events by minute, and compute summary statistics for each log level. The workflow supports both local testing and full Hadoop execution.

- **Objective:**  
  Parse raw log files and produce a minute‑by‑minute summary of total events and log‑level counts.

- **Domain:**  
  Distributed Systems, Log Processing, Big Data

- **Key Techniques:**  
  Hadoop Streaming, Python mappers/reducers, HDFS automation, shell scripting

---

## **Project Structure**

```
hw2/
├── hw2-mapper.py              # Mapper: extracts minute + log level
├── hw2-reducer.py             # Reducer: aggregates counts per minute
├── process-log-file.sh        # End-to-end workflow for all logs
├── run-hadoop-streaming.sh    # Single-file Hadoop Streaming runner
├── logs/                      # Input log files (user-provided)
└── README.md
```

All log files must be placed inside the `logs/` directory.

---

## **Data**

- **Source:**  
  Log files provided as part of the assignment.

- **Description:**  
  Each log entry contains a timestamp and a log level (INFO, WARN, ERROR, FATAL).  
  The mapper extracts the minute and level; the reducer aggregates totals.

- **Format:**  
  Input: `.log` files  
  Output: tab‑separated summary lines

---

## **Analysis**

The project includes both local testing and Hadoop execution.

### **Local Test (no Hadoop)**  
Useful for verifying mapper/reducer logic before running on HDFS.

```
cd ~/hw2
cat logs/<logfile>.log | ./hw2-mapper.py | sort | ./hw2-reducer.py
```

Expected output format:

```
minute  total  INFO  WARN  ERROR  FATAL
```

Example:

```
01      157     157     0       0       0
02      278     278     0       0       0
```

### **Hadoop Streaming Test (single file)**  
1. Create HDFS directory:  
   `hdfs dfs -mkdir -p /hw2/test`

2. Upload one log file:  
   `hdfs dfs -put logs/<logfile>.log /hw2/test/`

3. Run Hadoop Streaming:

```
hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-*.jar \
    -files hw2-mapper.py,hw2-reducer.py \
    -input /hw2/test \
    -output /hw2/test-output \
    -mapper hw2-mapper.py \
    -reducer hw2-reducer.py
```

4. View results:  
   `hdfs dfs -cat /hw2/test-output/part-*`

### **Full Dataset (all logs)**  
Runs the entire workflow and cleans up HDFS automatically.

```
cd ~/hw2
./process-log-file.sh logs /hw2/full-output
```

The script will:

- Upload all logs to HDFS  
- Run Hadoop Streaming  
- Print the final summary  
- Remove temporary HDFS directories  

Example output:

```
--- Log summary by minute ---
01      157     157     0       0       0
02      278     278     0       0       0
...
28      88      0       88      0       0
-----------------------------------------------
Cleaned up HDFS input: /hw2/e2e/input/logs
Cleaned up HDFS output: /hw2/full-output
```

---

## **Results**

The final output is a clean, minute‑by‑minute breakdown of log activity across all files.  
This confirms the mapper, reducer, and Hadoop Streaming pipeline are functioning correctly.

---

## **Authors**

- Alex Song

---

## **License**

This project is for academic coursework.

---

## **Acknowledgements**

- Hadoop 3.x  
- Python 3  
- Shell scripting  
- Course‑provided log files  

---