---
owner_slack: "#govuk-2ndline"
title: Fastly error rate for GOV.UK
section: Icinga alerts
layout: manual_layout
parent: "/manual.html"
---

We get response code reporting from Fastly (with a 15 minute delay). It
averages out the last 15 minutes worth of 5xx errors. This is a useful
supplementary metric to highlight low-level errors that occur over a longer
period of time.

The alert appears on `monitoring-1.management`.

It is possible to [query the CDN logs using AWS Athena][query-cdn-logs].
The following query gets a count of URLs where a 5xx error has been served
between the given timestamps:

```
SELECT url, status, COUNT(*) AS count
FROM fastly_logs.govuk_www
WHERE status >= 500 AND status <= 599
AND request_received >= TIMESTAMP '2018-11-26 11:00'
AND request_received < TIMESTAMP '2018-11-26 11:30'
AND date = 26 AND month = 11 AND year = 2018
GROUP BY url, status
ORDER BY count DESC
```

It is also possible to examine the raw Fastly CDN logs:

- `ssh monitoring-1.management.production`
- `cd /var/log/cdn` to access log files

## `Unknown` alert

The alert appears on `monitoring-1.management`. Collectd uses the Fastly
API to get statistics which it pushes to Graphite. If the alert is unknown,
collectd likely cannot talk to Fastly so restart collectd.

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

[query-cdn-logs]: /manual/query-cdn-logs.html
