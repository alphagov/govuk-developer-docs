---
owner_slack: "#govuk-2ndline"
title: Enhanced ecommerce data export
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2019-05-17
review_in: 6 months
---

This process is related to collection of data for analytics and is run daily so that data can be uploaded to GA for newly created content. This process can be rerun multiple times without side effect.

[Enhanced Ecommerce](https://developers.google.com/analytics/devguides/collection/analyticsjs/enhanced-ecommerce)
is a Google Analytics tool which measures user interactions with lists of items.
We use it on GOV.UK to investigate search relevancy by looking at how often
links in search results are clicked compared to how often they are shown.

Ecommerce events only send the `content_id` to google analytics. In order to make the data valuable we upload additional data fields linked to the `content_id` which can then be used for reporting within GA. GA refers to this process as a [query time import](https://support.google.com/analytics/answer/6071511?hl=en).

This task is responsible for generating the data file on the production server `search-1.api` and deleting historical files - we currently keep the last 10 files on record.

The file is left in the `/data/export/enhanced_ecommerce` directory. It can be
copied from the server and manually uploaded into GA.

If the check fails:

- Inspect the [console
logs for the rake task](https://deploy.publishing.service.gov.uk/job/enhanced_ecommerce/).
- Escalate to the team responsible for [search-api](/apps/search-api.html).
