---
owner_slack: "#govuk-2ndline"
title: Fetch analytics data for search failed
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2019-03-01
review_in: 6 months
---

This checks the latest build state of [a job in production
Jenkins](https://deploy.publishing.service.gov.uk/job/search-fetch-analytics-data/)
which runs every night and updates all documents in the search index with pageview data from
Google Analytics.

The only downside of this not running is that the popularity data is slightly
out of date. The search index is locked while it runs so it shouldn’t be re-run
whilst people are publishing.

The popularity data is used to promote more popular pages in search results.

If the job is failing often, make sure the team currently responsible for search
are aware of the problem (or Platform Health).
