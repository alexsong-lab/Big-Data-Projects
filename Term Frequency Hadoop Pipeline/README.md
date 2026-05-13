# **Term Frequency Hadoop Pipeline**

> A full Hadoop Streaming and Hive workflow that processes a text corpus and compute per‑document term frequencies.

---

## **Project Overview**

This project builds a two‑stage MapReduce pipeline and Hive workflow processing text corpus to calculate how often each term appears in each document. The entire process runs on Hadoop and Hive, and the final output is a single file containing `(document_id, term, frequency_pct)` for the entire dataset.

- **Objective:**  
  Take raw text files, normalize the word/term, count each of them, compute document totals, and join everything to produce term frequencies.

- **Domain:**  
  Big Data Processing

- **Key Techniques:**  
  Python, MapReduce, Hadoop Streaming, Hive SQL, text normalization

---

## **Project Structure**

```
term-frequency/
├── job1/                     # Job 1: term counts per document 
│   ├── mapper.py
│   └── reducer.py
├── job2/                     # Job 2: total term count per document
│   ├── mapper.py
│   └── reducer.py
├── job1.sh                   # Runs Hadoop Streaming Job 1
├── job2.sh                   # Runs Hadoop Streaming Job 2
├── main.sh                   # Full pipeline (Job1 → Job2 → Hive → tf.txt)
├── tf.hql                    # Hive script for joining results
└── tf.txt                    # Final output (generated)
```

---

## **Data**

- **Source:**  
  The provided `textcorpora.zip` containing 16 text documents.

- **Description:**  
  Each file is treated as a separate document. The pipeline extracts terms, counts them, and compute frequencies.

- **Format:**  
  Input: `.txt`  
  Intermediate: tab‑separated values  
  Output: `tf.txt` (CSV‑style)

---

## **Analysis**

The workflow is split into two MapReduce jobs and one Hive step:

### **Job 1 — Term Counts**
- Mapper outputs `(docid, term, 1)`
- Reducer aggregates to `(docid, term, term_count)`

### **Job 2 — Document Totals**
- Mapper outputs `(docid, term_count)`
- Reducer aggregates to `(docid, doc_count)`

### **Hive Join**
- Loads both job outputs as external tables
- Computes:
  ```
  frequency_pct = term_count / doc_count
  ```
- Writes final results to HDFS, then merges into `tf.txt`

### **Execution Order**
1. `bash job1.sh`  
2. `bash job2.sh`  
3. `bash main.sh`  

---

## **Results**

The final output file `tf.txt` contains all `(document_id, term, frequency_pct)` rows.

To confirm everything worked correctly:

```
grep ,abhor, tf.txt
```

Expected output:

```
austen-emma,abhor,6.323990691085703E-6
austen-sense,abhor,8.430281571404485E-6
bible-kjv,abhor,2.4049750072465693E-5
milton-paradise,abhor,3.766714796911294E-5
```

If these match exactly, the pipeline is correct.

---

## **Authors**

- Alex S.

---

## **License**

This project is for academic use as part of coursework.

---

## **Acknowledgements**

- Hadoop 3.x  
- Hive 4.x  
- Python 3  
- Course‑provided text corpus  
- Instructor‑provided Job 1 mapper template  

---