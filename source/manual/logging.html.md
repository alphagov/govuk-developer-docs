---
owner_slack: '#2ndline'
review_by: 2017-08-21
title: How logging works on GOV.UK
section: Logging
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/infrastructure/logging/index.md"
---



> **This page was imported from [the opsmanual on github.gds](https://github.gds/gds/opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.gds/gds/opsmanual/tree/master/infrastructure/logging/index.md)


# How logging works on GOV.UK

## Syslog

Each machine sends its syslog to a central `logging` machine (logging-1.management) which listens on UDP port 514.

The logging machine sends all the syslog messages it receives to a local logstash, which sends
those logs to `logs-elasticsearch`.

The logging machine keeps the logs at `/srv/log/year/month/date/server-name`

## Logstream, logship and redis

We have a defined type in our Puppet code which uses
[logship](https://github.com/alphagov/tagalog/blob/master/tagalog/command/logship.py)
to tail logfiles.

The tailed logs are sent to `logs-redis` machines. The logging Elasticsearch cluster has a
river to pull logs from redis.

logship provides multiple shippers. We're using the redis shipper and the statsd shipper
(for sending nginx status codes to Graphite).

## Logstash

Logstash runs on the `logging` machine. It listens for data on TCP and UDP ports which are specified
in its config and then applies filters to the log lines.

We use `grok` patterns for applying filters. A useful tool to test patterns is
[Grok Debugger](https://grokdebug.herokuapp.com/).

The output for logstash is our logging Elasticsearch cluster.

## Elasticsearch

We run a logging Elasticsearch cluster: `fab production class:logs_elasticsearch hosts`

We use [estools](https://github.com/alphagov/estools) to rotate Elasticsearch indices daily, and apply
an alias of `logs-current` for the current day's logs.

## Kibana

Kibana is the interface for viewing logs in Elasticsearch. We made
[kibana-gds](https://github.com/alphagov/kibana-gds) as a wrapper to put Kibana behind GOV.UK Signon.

It's deployed to the backend application servers.

There's some documentation on [useful Kibana queries for 2nd line](../2nd-line/kibana.html).
