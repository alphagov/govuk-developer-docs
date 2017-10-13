---
owner_slack: "#2ndline"
title: Useful Kibana queries
layout: manual_layout
parent: "/manual.html"
section: Logging
important: true
last_reviewed_on: 2017-08-23
review_in: 6 months
---

All logs for GOV.UK are collected in Kibana:

- <https://kibana.publishing.service.gov.uk>
- <https://kibana.staging.publishing.service.gov.uk>
- <https://kibana.integration.publishing.service.gov.uk>

Kibana can be searched using the [Lucene search syntax][lucene].

## Examples

### 5xx errors returned from cache layer

```rb
host:cache* AND @fields.status:[500 TO 504]
```

### Puppet runs

```rb
# both agent and master
syslog_program:puppet

# agent only
syslog_program:"puppet-agent"

# master only
syslog_program:"puppet-master"
```

### Syslog logs

```rb
application:"syslog"
```

### Syslog logs filtered by program

```rb
application:"syslog" AND syslog_program:"rsync"
```

### Nginx logs

```rb
tags:"nginx"
```

Nginx logs for frontend:

```rb
tags:"nginx" AND application:frontend*
```

Note: the `@timestamp` field records the request END time. To calculate request start time subtract `@fields.request_time`.

### CDN logs

```rb
application:"govuk-cdn-logs-monitor"
```

### Application upstart logs

```rb
tags:"upstart"

tags:"upstart" AND tags:"stdout"

tags:"upstart" AND tags:"stderr"

tags:"upstart" AND application:"licensify"
```

### Application production.log files

```rb
tags:"application"

tags:"application" AND application:"smartanswers"
```

### MongoDB slow queries

```rb
application:"mongodb" AND message:"command"
```

### Audit/access logs

```rb
application:"syslog" AND syslog_program:"audispd"
```

### Mirrrorer logs

```rb
syslog_program:"mirrorer"
```

### Publishing API timeouts

```rb
@fields.error:"TimedOutException" AND (application:"specialist-publisher" OR application:"whitehall" OR application:"content-tagger")
```

## Syslog program names

If you're looking for specific program outputs, use `syslog_program:FOO`:

- `audispd`:	This is used to see all audit logs from various servers. You can refer to README for searching particular types of audit logs. The program name with combination of source_host and message can be helped for looking at various specific audit log lines on a server.
- `clamd`	 
- `cron`	 
- `mirrorer`: Records information from govuk_mirrorer script. It contains INFO, WARN and ERROR information
- `puppet-agent`:	Records output for govuk_puppet script on various servers
- `puppet-master`	 
- `smokey`

## Gotchas

- Score: does a aggregation of field on last 2000 results
- Terms is not an aggregation of field, it is an aggregation of terms in the field across 1 recent indices
- For more elaborate searching, [read about the Lucene syntax][lucene]
- `@timestamp` of nginx log entries records [request end time is sometimes confusing][end]

[lucene]: http://lucene.apache.org/core/old_versioned_docs/versions/2_9_1/queryparsersyntax.html
[end]: http://serverfault.com/questions/438880/what-does-nginxs-time-local-logging-variable-mean-specifically/438891#438891
