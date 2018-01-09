---
title: Content that doesn't show up correctly in search or list pages
parent: "/manual.html"
layout: manual_layout
section: Publishing
owner_slack: "#2ndline"
last_reviewed_on: 2018-01-09
review_in: 3 months
related_applications: [rummager]
---

[Rummager](/apps/rummager.html) (the search API) often gets out of sync with
publishing applications. This affects any part of the site using it, including
navigation pages and related links.

### Root cause

For most document formats (those that have not been [migrated to the new
index](https://github.com/alphagov/rummager/blob/master/config/govuk_index/migrated_formats.yaml)),
Rummager depends on requests from publishing apps to stay
up to date. This is usually a "fire and forget" task that doesn't block
the user's publishing action, and if anything goes wrong, the search data
will stay unchanged until the next time an update is made to the document.

The search team are [working on improving
this](https://github.com/alphagov/rummager/blob/master/doc/arch/adr-004-transition-mainstream-to-publishing-api-index.md).

### Check if search is the problem

A page with URL [/council-tax](https://www.gov.uk/council-tax) can be queried using [/api/search.json?filter_link=/council-tax](https://www.gov.uk/api/search.json?filter_link=/council-tax). You can quickly
switch between the two using the [GOV.UK chrome
plugin](https://github.com/alphagov/govuk-toolkit-chrome).

You can compare the data returned with the publishing app to check if it's up
to date. An empty response means search has never received the content.

You can also request [different fields](/apis/search/fields.html), for example
[/api/search.json?filter_link=/council-tax&fields=format,content_id](https://www.gov.uk/api/search.json?filter_link=/council-tax&fields=format,content_id).

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

On finder pages, facets on the left hand side can be populated from "link"
fields in the search documents, like people, organisations, topics.

This can be detected by the Finder Frontend feature in Smokey (an
example error would be `And I should see a closed facet titled
"People" with non-blank values`).

If the pages for those things don't themselves exist in search, finder frontend
won't be able to fill in the titles.

To fix the issue:
- Inspect the blank options using browser developer tools to work out which
  people are affected
- Republish those people in whitehall

![People facet with blank options](/images/blank-facets.png)
