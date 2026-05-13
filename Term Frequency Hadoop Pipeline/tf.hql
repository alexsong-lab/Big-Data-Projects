-- Drop old tables
DROP TABLE IF EXISTS job1_terms;
DROP TABLE IF EXISTS job2_docs;
DROP TABLE IF EXISTS tf_result;

-- Job 1 output: (docid, term, term_count)
CREATE EXTERNAL TABLE job1_terms (
    docid STRING,
    term STRING,
    term_count INT)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE
LOCATION '/user/${hivevar:USER_NAME}/term-frequency/job1-out';

-- Job 2 output: (docid, doc_count)
CREATE EXTERNAL TABLE job2_docs (
    docid STRING,
    doc_count INT)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE
LOCATION '/user/${hivevar:USER_NAME}/term-frequency/job2-out';

-- Compute term frequency
CREATE TABLE tf_result AS
SELECT t.docid AS document_id, t.term AS term, CAST(t.term_count AS DOUBLE) / CAST(d.doc_count AS DOUBLE) AS frequency_pct
FROM job1_terms t
JOIN job2_docs d
ON t.docid = d.docid;

-- Export results to HDFS
INSERT OVERWRITE DIRECTORY '/user/${hivevar:USER_NAME}/term-frequency/tf-hive-out'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
SELECT document_id, term, frequency_pct
FROM tf_result;
