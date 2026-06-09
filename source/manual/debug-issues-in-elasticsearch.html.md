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
to date. An empty response means no documents match the given query.

## Check the document is in elasticsearch

If the document is missing from the search API, you can check the search index itself to
see if it is present and has the expected fields, by sending a request to elasticsearch
[from a shell][open-a-shell] in `search-api`:

```
curl -X GET "$ELASTICSEARCH_URI/govuk/_search?pretty" -H "content-type: application/json" -d "
{
  \"query\": {
    \"match\": {
      \"link\": \"/the/path/to/the/page\"
    }
  }
}"
```

To search by content ID use `\"content_id\": \"...\"` instead.

If the document is present and looks correct, it suggests that the problem is
that the document does not match the search query. You can debug the query by
adding the parameter `debug=show_query` to the search API URL, e.g.
<https://www.gov.uk/api/search.json?q=badgers&debug=show_query>.

[open-a-shell]: https://docs.publishing.service.gov.uk/kubernetes/cheatsheet.html#open-a-shell-in-an-app-container
