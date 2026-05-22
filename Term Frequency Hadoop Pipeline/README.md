# Term Frequency Hadoop Pipeline

This project computes per-document term frequency from a corpus using two Hadoop Streaming jobs and one Hive transformation.

## Pipeline Summary

### Job 1: Term Counts Per Document
- Mapper emits `(docid, term, 1)`.
- Reducer aggregates to `(docid, term, term_count)`.

### Job 2: Document Token Totals
- Mapper emits `(docid, term_count)`.
- Reducer aggregates to `(docid, doc_count)`.

### Hive Step: Frequency Calculation
- Joins Job 1 and Job 2 outputs.
- Computes `frequency_pct = term_count / doc_count`.
- Exports records as `document_id,term,frequency_pct`.

## Repository Layout

```
Term Frequency Hadoop Pipeline/
├── job1/
│   ├── mapper.py
│   └── reducer.py
├── job2/
│   ├── mapper.py
│   └── reducer.py
├── job1.sh
├── job2.sh
├── main.sh
├── tf.hql
└── README.md
```

## Running the Workflow

From this directory:

1. `bash job1.sh`
2. `bash job2.sh`
3. `bash main.sh`

`main.sh` executes both MapReduce jobs, runs Hive, and writes `tf.txt` locally.

## Example Verification

```
grep ,abhor, tf.txt
```

Expected lines:

```
austen-emma,abhor,6.323990691085703E-6
austen-sense,abhor,8.430281571404485E-6
bible-kjv,abhor,2.4049750072465693E-5
milton-paradise,abhor,3.766714796911294E-5
```

## Stack

- Python 3
- Hadoop Streaming
- Hive / Beeline
- Bash