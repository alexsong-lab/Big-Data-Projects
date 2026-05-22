-- Reset reusable Hive tables for this pipeline run.
DROP TABLE IF EXISTS stage_term_counts;
DROP TABLE IF EXISTS stage_doc_totals;
DROP TABLE IF EXISTS term_frequency_result;

-- Stage map-reduce output from Job 1.
CREATE EXTERNAL TABLE stage_term_counts (
    docid STRING,
    term STRING,
    term_count INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE
LOCATION '/user/${hivevar:USER_NAME}/term-frequency/job1-out';

-- Stage map-reduce output from Job 2.
CREATE EXTERNAL TABLE stage_doc_totals (
    docid STRING,
    doc_count INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE
LOCATION '/user/${hivevar:USER_NAME}/term-frequency/job2-out';

-- Compute frequency of each term inside each document.
CREATE TABLE term_frequency_result AS
SELECT
    token_counts.docid AS document_id,
    token_counts.term AS term,
    CAST(token_counts.term_count AS DOUBLE) / CAST(doc_totals.doc_count AS DOUBLE) AS frequency_pct
FROM stage_term_counts token_counts
JOIN stage_doc_totals doc_totals
    ON token_counts.docid = doc_totals.docid;

-- Export final result set.
INSERT OVERWRITE DIRECTORY '/user/${hivevar:USER_NAME}/term-frequency/tf-hive-out'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
SELECT document_id, term, frequency_pct
FROM term_frequency_result;
