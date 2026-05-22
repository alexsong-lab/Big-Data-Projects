import search


def _render_results_page(query_text, rows):
    html_parts = [
        """
    <html>
    <head>
        <title>Document Search</title>
        <style>
            body {
                font-family: sans-serif;
                max-width: 480px;
                margin: 80px auto;
                padding: 0 16px;
                color: #333;
            }
            h1 { margin-bottom: 24px; }
            ul { list-style-type: none; padding: 0; margin-top: 20px; }
            li {
                padding: 10px 0;
                border-bottom: 1px solid #ddd;
                display: flex;
                justify-content: space-between;
            }
            .score {
                color: #555;
                font-size: 0.9rem;
            }
        </style>
    </head>
    <body>
""",
        f"        <h1>Search results for: {query_text}</h1>",
        "        <ul>",
    ]

    for title_text, rank_score in rows:
        html_parts.append(
            f"<li><span>{title_text}</span><span class='score'>relevance score: {rank_score}</span></li>"
        )

    html_parts.append(
        """
        </ul>
    </body>
    </html>
"""
    )
    return "".join(html_parts)


def lambda_handler(event, context):
    request_params = event.get("queryStringParameters", {}) or {}
    query_text = request_params.get("q", "")
    ranked_results = search.search(query_text)
    html_output = _render_results_page(query_text, ranked_results)

    return {
        "statusCode": 200,
        "headers": {"Content-Type": "text/html"},
        "body": html_output,
    }