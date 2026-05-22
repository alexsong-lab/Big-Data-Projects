# AWS Serverless Document Search

An end-to-end document retrieval system that combines Hadoop-based indexing with a serverless query API.

## What This Project Does

- Processes a text corpus into TF-IDF scores with Hadoop Streaming + Hive.
- Stores indexed scores in DynamoDB for low-latency lookup.
- Serves ranked search results from an AWS Lambda function.
- Provides a minimal static frontend for browser-based querying.

## System Components

### Data Pipeline (EMR/Hadoop/Hive)
1. Job 1 builds `(docid, term, term_count)`.
2. Job 2 builds `(docid, doc_count)`.
3. Job 3 builds `(term, doc_freq)`.
4. Hive computes TF-IDF and exports `(docid, term, tfidf)`.

### Storage (DynamoDB)
- `tfidf` table
  - Partition key: `term`
  - Sort key: `docid`
  - Attribute: `tfidf`
- `doctitle` table
  - Partition key: `docid`
  - Attribute: `title`

### Query Service (Lambda)
- Reads query parameter `q`.
- Applies the same token normalization used during indexing.
- Collects candidate documents from DynamoDB.
- Computes and ranks relevance scores.
- Returns an HTML result page with up to 5 matches.

## Relevance Formula

The ranking strategy keeps the original scoring behavior:

\[
\text{score}(doc, Q) = \left\lfloor \frac{\sum_{t \in Q}\text{tfidf}(doc,t)}{|Q|} \right\rfloor
\]

## Repository Layout

```
AWS Serverless Document Search/
├── code/
│   ├── job1/
│   ├── job2/
│   ├── job3/
│   ├── hive/
│   ├── lamda_funtion/
│   └── search.html
├── data/
│   └── doctitle/
└── README.md
```

## Runtime Stack

- Python 3
- Hadoop Streaming
- Hive
- AWS EMR
- AWS DynamoDB
- AWS Lambda
- HTML/CSS
