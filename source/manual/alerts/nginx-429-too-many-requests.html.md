---
owner_slack: "#govuk-2ndline"
title: Nginx 429 too many requests
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2019-07-30
review_in: 6 months
---

Nginx is configured with a rate limit in the cache servers to stop
unusual load from being redirected to the rest of the systems. Sometimes
a robot or a malicious client could hit the cache servers above the
rate limit, in which case Nginx will reject requests, log an error message
in the error log file and generate an HTTP 429 response code.

The alert should link to a Graphite graph. If you determine this is a spike,
it is best to check the Nginx logs in Kibana to determine why Nginx is rejecting
requests (for instance, too many requests coming from a single IP, or the same
page being requested at a high rate).
