---
owner_slack: "#govuk-searchandnav"
title: Content that doesn't show up correctly in search or list pages
parent: "/manual.html"
layout: manual_layout
section: Publishing
related_applications: [search-api]
---

The Elasticsearch cluster utilised by [Search API](/apps/search-api.html) can
get out of sync with publishing applications. This affects any part of the site
using it, including navigation pages and related links.

### Check if search is the problem

A page with URL [/council-tax](https://www.gov.uk/council-tax) can be queried using [/api/search.json?filter_link=/council-tax](https://www.gov.uk/api/search.json?filter_link=/council-tax). You can quickly
switch between the two using the [GOV.UK browser extension](https://github.com/alphagov/govuk-browser-extension).

You can compare the data returned with the publishing app to check if it's up
to date. An empty response means search has never received the content.

You can also request [different fields](/apis/search/fields.html), for example
[/api/search.json?filter_link=/council-tax&fields=format,content_id](https://www.gov.uk/api/search.json?filter_link=/council-tax&fields=format,content_id).

If the document is missing from the search API, check the search index itself to
see if it is present and has the expected fields:

0. SSH to a search box:

    ```
    gds govuk connect ssh -e integration search
    ```

0. Send a request to elasticsearch:

    ```
    govuk_setenv search-api \
    bash -c 'curl "$ELASTICSEARCH_URI/detailed,government,govuk/_search" -H "content-type: application/json" -d "
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

### Correct the search data

Most search issues can be fixed by either republishing the content, or manually
reindexing via a rake task in the publishing app.

#### Published content is missing from search/finders/navigation

Try republishing the content.

#### Unpublished, deleted, or redirected content is still showing up in search

Unpublished, deleted, or redirected content can be removed from search manually
using [search admin](https://search-admin.publishing.service.gov.uk/).
