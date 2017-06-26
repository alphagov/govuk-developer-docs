---
owner_slack: "#search-team"
title: Check for spelling suggestions failed
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2016-12-26
review_in: 6 months
---

Indicates that the Jenkins [search_test_spelling_suggestions healthcheck job]
(https://deploy.publishing.service.gov.uk/job/search_test_spelling_suggestions/)
has failed.

The healthcheck sends queries to the search API and checks that the response
contains the expected spelling suggestions.

The Jenkins job will still succeed even if the search results are poor and will
only fail if something actually goes wrong. For example, if a request to the
search API fails.

Check the output of the job on the relevant environment for more information.

It's common to see 'freshness threshold exceeded' alerts in integration on a
Monday morning for this check, because integration is switched off over the
weekend so the job has not been run for a couple of days.
