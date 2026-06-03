---
owner_slack: "#govuk-search"
title: Debug issues in elasticsearch
parent: "/manual.html"
layout: manual_layout
section: Search on GOV.UK
related_repos: [search-api]
---

## Check the document returned by search API

A page with URL [/council-tax](https://www.gov.uk/council-tax) can be queried using [/api/search.json?filter_link=/council-tax](https://www.gov.uk/api/search.json?filter_link=/council-tax). You can quickly
switch between the two using the [GOV.UK browser extension](https://github.com/alphagov/govuk-browser-extension).

You can compare the data returned with the relevant publishing app or content store to check if it's up
to date. An empty response means search has never received the content.

## Check the document is in elasticsearch

If the document is missing from the search API, check the search index itself to
see if it is present and has the expected fields:

0. SSH to a search box:

    ```
    gds govuk connect ssh -e integration search
    ```

0. Send a request to elasticsearch:

    ```
    govuk_setenv search-api \
    bash -c 'curl "$ELASTICSEARCH_URI/govuk/_search" -H "content-type: application/json" -d "
    {
      \"post_filter\": {
        \"term\": {
          \"link\": \"/the/path/to/the/page\"
        }
      }
    }"' | json_pp
    ```

   To search by content ID use `\"content_id\": \"...\"` instead.

If the document is present and looks correct, it suggests that the problem is
that the document does not match the search query. You can debug the query by
adding the parameter `debug=show_query` to the search API URL, e.g.
<https://www.gov.uk/api/search.json?q=badgers&debug=show_query>.
