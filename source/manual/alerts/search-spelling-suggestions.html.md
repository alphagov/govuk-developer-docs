---
owner_slack: "#govuk-2ndline"
title: Check for spelling suggestions failed
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2018-08-31
review_in: 6 months
---

Indicates that the Jenkins [search_test_spelling_suggestions healthcheck job]
(https://deploy.publishing.service.gov.uk/job/search_test_spelling_suggestions/)
has failed.

This job sends queries to the search API and checks that the response
contains the expected spelling suggestions.

It will only fail if something actually goes wrong, like if a request to the
search API fails. The actual score will be less than 100%.
