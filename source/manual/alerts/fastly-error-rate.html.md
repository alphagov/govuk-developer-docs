---
owner_slack: "#2ndline"
title: Fastly error rate for GOV.UK
section: Icinga alerts
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/2nd-line/alerts/fastly-error-rate.md"
last_reviewed_on: 2017-01-07
review_in: 6 months
---

> **This page was imported from [the opsmanual on github.gds](https://github.gds/gds/opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.gds/gds/opsmanual/tree/master/2nd-line/alerts/fastly-error-rate.md)


## Error rate alert

We get response code reporting from Fastly (with a 15 minute delay). It
averages out the last 15 minutes worth of 5xx errors. This is a useful
supplementary metric to highlight low-level errors that occur over a longer
period of time.

The alert appears on `monitoring-1.management`. A good starting point for
investigation is to examine the Fastly CDN logs.

- `ssh logs-cdn-1.management.production`
- `cd /mnt/logs_cdn` to access log files

## `Unknown` alert

The alert appears on `monitoring-1.management`. Collectd uses the Fastly API to get statistics which it pushes to Graphite. If the alert is unknown, collectd likely cannot talk to Fastly so restart collectd.

- `sudo service collectd restart`

To prove collectd is the problem, use this query in Kibana:

`@source_host:monitoring-1.management AND @fields.syslog_program:collectd`

You will see many reports simlilar to:

`cdn_fastly plugin: Failed to query service`
