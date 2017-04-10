---
title: 'Fetch analytics data for search failed'
parent: /manual.html
layout: manual_layout
section: Alerts
---

# Fetch analytics data for search failed

This checks the latest build state of [a job in production
Jenkins](https://deploy.publishing.service.gov.uk/job/search-fetch-analytics-data/)
which runs every night and populates the search index with the latest data from
Google Analytics.

The only downside of this not running is that the popularity data is slightly
out of date. The search index is locked while it runs so it shouldn’t be re-run
whilst people are publishing.

If the job is failing often, make sure the team currently responsible for search
are aware of the problem.

