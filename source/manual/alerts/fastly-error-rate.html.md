---
owner_slack: "#govuk-2ndline"
title: Fastly error rate for GOV.UK
section: Icinga alerts
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-08-31
review_in: 6 months
---

We get response code reporting from Fastly (with a 15 minute delay). It
averages out the last 15 minutes worth of 5xx errors. This is a useful
supplementary metric to highlight low-level errors that occur over a longer
period of time.

The alert appears on `monitoring-1.management`. A good starting point for
investigation is to examine the Fastly CDN logs.

- `ssh logs-cdn-1.management.production`
- `cd /mnt/logs_cdn` to access log files

Alternatively you can look in [Kibana](/manual/tools.html#kibana) with the query
`application:"govuk-cdn-logs-monitor"`

## `Unknown` alert

The alert appears on `monitoring-1.management`. Collectd uses the Fastly API to get statistics which it pushes to Graphite. If the alert is unknown, collectd likely cannot talk to Fastly so restart collectd.

```shell
$ sudo service collectd restart
```

To prove collectd is the problem, use this query in Kibana:

```rb
syslog_hostname:monitoring-1.management AND syslog_program:collectd
```

You will see many reports similar to:

```
cdn_fastly plugin: Failed to query service
```
