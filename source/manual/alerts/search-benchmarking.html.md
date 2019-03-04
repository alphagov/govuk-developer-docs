---
owner_slack: "#govuk-2ndline"
title: Benchmark search queries failed
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2019-03-16
review_in: 6 months
---

Indicates that the Jenkins [search_benchmark healthcheck job] (https://deploy.publishing.service.gov.uk/job/search_benchmark/) has failed.

The healthcheck sends queries to the search API and compares the results to the
expected pages. It will only fail if something actually goes wrong - for example, if a request to the search API fails. Check the output of the job on the relevant environment for more information.

The search benchmark checks if various terms appear at expected positions in search lists, however the pass mark is less than 100% as data moves around over time and some tests fail to pass as a result. The data is useful to analyse over time - it is not a point in time indication something is wrong.
