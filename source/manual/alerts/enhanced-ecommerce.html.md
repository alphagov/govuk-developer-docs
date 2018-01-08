---
owner_slack: "#2ndline"
title: Enhanced ecommerce data export
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2017-11-14
review_in: 3 months
---

This process is related to collection of data for analytics and is run daily so that data can be uploaded to GA for newly created content. This process can be rerun multiple times without side effect.

Ecommerce events only send the `content_id` to google analytics. In order to make the data valuable we upload additional data fields linked to the `content_id` which can then be used for reporting within GA. GA refers to this process as a [query time import](https://support.google.com/analytics/answer/6071511?hl=en).

This task is responsible for generating the data file on the production server `search-1.api` and deleting historical files - we currently keep the last 10 files on record.

Currently the file is left on the server to be manually uploaded into GA.

If the check fails:

- Inspect the [console
logs for the rake task](https://deploy.publishing.service.gov.uk/job/enhanced_ecommerce/).
- Escalate to search team.
