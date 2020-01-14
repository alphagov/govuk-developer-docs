---
owner_slack: "#govuk-2ndline"
title: Enhanced Ecommerce ETL from Search API to Google Analytics
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2020-01-14
review_in: 6 months
---

This process is related to collection of data for analytics and is run daily to
ensure Google Analytics (GA) is in sync with Search API. This process can be
rerun multiple times without side effect.

[Enhanced Ecommerce](https://developers.google.com/analytics/devguides/collection/analyticsjs/enhanced-ecommerce)
is a Google Analytics tool which measures user interactions with lists of items.
We use it on GOV.UK to investigate search relevancy by looking at how often
links in search results are clicked compared to how often they are shown.

Ecommerce events only send the `content_id` to google analytics. In order to make the data valuable we upload additional data fields linked to the `content_id` which can then be used for reporting within GA. GA refers to this process as a [query time import](https://support.google.com/analytics/answer/6071511?hl=en).

This task is responsible for generating the data file on a production
search server, deleting historical uploads, and then uploading a new file.

It uses the `analytics:export_indexed_pages_to_google_analytics` rake task
in Search API.

The uploaded file is a CSV containing documents stored in the search indexes,
in addition to lots of fields that we want GA to have access to, such as 'link'
and 'content_store_document_type'.

Previously, files would be stored in the `/data/export/enhanced_ecommerce`
directory on the server, and then manually uploaded into GA.
Currently, the rake task will generate the file and upload it in one step.

If the check fails:

- Inspect the [console logs for the rake task](https://deploy.blue.production.govuk.digital/job/enhanced_ecommerce_search_api/).
- Escalate to the team responsible for [search-api](/apps/search-api.html).
- It is safe to re-run the rake task to make the alert go away.
  You may see some 'high load' alerts while the task is running.
