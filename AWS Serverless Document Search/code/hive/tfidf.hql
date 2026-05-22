-- Recreate all working tables for this run.
DROP TABLE IF EXISTS stage_term_counts;
DROP TABLE IF EXISTS stage_doc_lengths;
DROP TABLE IF EXISTS stage_doc_frequency;
DROP TABLE IF EXISTS tfidf_result;

-- Stage from Job 1 output: (docid, term, term_count)
CREATE EXTERNAL TABLE stage_term_counts (
    docid STRING,
    term STRING,
    term_count INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE
LOCATION '${hivevar:data}/job1-termcount';

-- Stage from Job 2 output: (docid, doc_count)
CREATE EXTERNAL TABLE stage_doc_lengths (
    docid STRING,
    doc_count INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE
LOCATION '${hivevar:data}/job2-doccount';

-- Stage from Job 3 output: (term, doc_freq)
CREATE EXTERNAL TABLE stage_doc_frequency (
    term STRING,
    doc_freq INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE
LOCATION '${hivevar:data}/job3-docfreq';

-- Compute final TF-IDF scores.
CREATE TABLE tfidf_result AS
SELECT
    term_rows.docid AS document_id,
    term_rows.term AS term,
    (CAST(term_rows.term_count AS DOUBLE) / CAST(doc_rows.doc_count AS DOUBLE))
    * LN(CAST(doc_total.total_documents AS DOUBLE) / CAST(freq_rows.doc_freq AS DOUBLE))
    * 1000000.0 AS tfidf
FROM stage_term_counts term_rows
JOIN stage_doc_lengths doc_rows
    ON term_rows.docid = doc_rows.docid
JOIN stage_doc_frequency freq_rows
    ON term_rows.term = freq_rows.term
CROSS JOIN (
    SELECT COUNT(DISTINCT docid) AS total_documents
    FROM stage_doc_lengths
) doc_total;

-- Export final dataset to HDFS/S3 location.
INSERT OVERWRITE DIRECTORY '${hivevar:data}/tfidf-out'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
SELECT document_id, term, tfidf
FROM tfidf_result;
