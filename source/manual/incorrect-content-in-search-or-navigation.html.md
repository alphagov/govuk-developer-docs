---
owner_slack: "#govuk-searchandnav"
title: Content that doesn't show up correctly in search or list pages
parent: "/manual.html"
layout: manual_layout
section: Publishing
related_repos: [search-api]
---

The Elasticsearch cluster utilised by [Search API](/repos/search-api.html) can
get out of sync with publishing applications. This affects any part of the site
using it, including navigation pages and related links.

## Correct the search data

Most search issues can be fixed by either republishing the content, or manually
reindexing via a rake task in the publishing app.

### Published content is missing from search/finders/navigation

Try republishing the content.

### Unpublished, deleted, or redirected content is still showing up in search

Unpublished, deleted, or redirected content can be removed from search manually
using [search admin](https://search-admin.publishing.service.gov.uk/).
