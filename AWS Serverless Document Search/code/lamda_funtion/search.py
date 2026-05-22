import boto3
import termify

dynamodb = boto3.resource("dynamodb")
tfidf_table = dynamodb.Table("tfidf")
docid_table = dynamodb.Table("doctitle")

MAX_RESULTS = 5


def get_docids_for_terms(query_terms):
    matched_doc_ids = set()
    for query_term in query_terms:
        resp = tfidf_table.query(
            KeyConditionExpression=boto3.dynamodb.conditions.Key("term").eq(query_term)
        )
        for item in resp.get("Items", []):
            matched_doc_ids.add(item["docid"])
    return matched_doc_ids


def get_tfidf(query_term, doc_id):
    resp = tfidf_table.get_item(Key={"docid": doc_id, "term": query_term})
    item = resp.get("Item")
    if not item:
        return 0.0
    return float(item["tfidf"])


def get_doc_title(doc_id):
    resp = docid_table.get_item(Key={"docid": doc_id})
    item = resp.get("Item")
    if not item:
        return None
    return item["title"]


def search(query_line):
    normalized_terms = termify.termify(query_line)
    candidate_doc_ids = get_docids_for_terms(normalized_terms)
    scored_docs = [
        (doc_id, compute_doc_relevance(doc_id, normalized_terms))
        for doc_id in candidate_doc_ids
    ]
    return sort_and_limit(scored_docs)


def compute_doc_relevance(doc_id, query_terms):
    if not query_terms:
        return 0.0

    tfidf_total = 0.0
    for query_term in query_terms:
        tfidf_total += get_tfidf(query_term, doc_id)

    if tfidf_total == 0.0:
        return 0.0
    return int(tfidf_total / len(query_terms))


def sort_and_limit(doc_score_pairs):
    positive_scores = [(doc_id, score) for doc_id, score in doc_score_pairs if score > 0]
    ranked_scores = sorted(positive_scores, key=lambda pair: pair[1], reverse=True)

    top_scored = ranked_scores[:MAX_RESULTS]
    presentation_rows = []
    for doc_id, score in top_scored:
        resolved_title = get_doc_title(doc_id) or doc_id
        presentation_rows.append((resolved_title, score))
    return presentation_rows