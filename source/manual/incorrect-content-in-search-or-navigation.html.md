---
title: Content that doesn't show up correctly in search or list pages
parent: "/manual.html"
layout: manual_layout
section: Publishing
owner_slack: "#2ndline"
last_reviewed_on: 2018-01-26
review_in: 3 months
related_applications: [rummager]
---

[Rummager](/apps/rummager.html) (the search API) often gets out of sync with
publishing applications. This affects any part of the site using it, including
navigation pages and related links.

### Root cause

For whitehall document formats (i.e. those that have not been [migrated to the
new index](https://github.com/alphagov/rummager/blob/master/config/govuk_index/migrated_formats.yaml)),
Rummager depends on requests from whitehall admin to stay up to date. This is a
"fire and forget" task that doesn't block the user's publishing action, and if
anything goes wrong, the search data will stay unchanged until the next time an
update is made to the document.

See [rummager ADR 004](https://github.com/alphagov/rummager/blob/master/doc/arch/adr-004-transition-mainstream-to-publishing-api-index.md)
for details of how we improved this for non-whitehall formats.

### Check if search is the problem

A page with URL [/council-tax](https://www.gov.uk/council-tax) can be queried using [/api/search.json?filter_link=/council-tax](https://www.gov.uk/api/search.json?filter_link=/council-tax). You can quickly
switch between the two using the [GOV.UK chrome
plugin](https://github.com/alphagov/govuk-toolkit-chrome).

You can compare the data returned with the publishing app to check if it's up
to date. An empty response means search has never received the content.

You can also request [different fields](/apis/search/fields.html), for example
[/api/search.json?filter_link=/council-tax&fields=format,content_id](https://www.gov.uk/api/search.json?filter_link=/council-tax&fields=format,content_id).

If the document is missing from the search API, check the search index itself to
see if it is present and has the expected fields:

0. ssh to an elasticsearch box with port-forwarding:

    ```
    ssh -L9200:localhost:9200 rummager-elasticsearch-1.api.staging
    ```

0. Go to the Any Request tab and use the panel on the left to send a `POST`
request to hostname `http://localhost:9200/` and path `govuk/_search`:

    ```
    {
      "filter": {
        "term": {
          "link": "/the/path/to/the/page"
        }
      }
    }
    ```

    Or search by content ID:

    ```
    {
      "filter": {
        "term": {
          "content_id": "638db33a-fe73-45fd-96e2-7dcf8281ff16"
        }
      }
    }
    ```

If the document is present and looks correct, it suggests that the problem is
that the document does not match the search query. You can debug the query by
adding the parameter `debug=show_query` to the search API URL, e.g.
<https://www.gov.uk/api/search.json?q=badgers&debug=show_query>.

### Correct the search data

Most search issues can be fixed by either republishing the content, or manually
reindexing via a rake task in the publishing app.

#### Published content is missing from search/finders/navigation

Try republishing the content.

#### Unpublished content is still showing up in search

Unpublished content can be removed from search manually using [search admin](https://search-admin.publishing.service.gov.uk/).

#### Content is duplicated in search results

This has happened before when either the elasticsearch document type or id
have changed.

You'll need to look at the [raw elasticsearch documents](https://docs.publishing.service.gov.uk/manual/alerts/elasticsearch-cluster-health.html#view-a-live-dashboard) to see what happened.

There is a [rake task](https://github.com/alphagov/rummager/blob/master/lib/tasks/delete.rake)
to remove unwanted duplicates.

#### There are blank options on finder pages

See the instructions for [fixing blank finder filter options](fix-blank-finder-filter-options.html).
