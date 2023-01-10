---
owner_slack: "#govuk-2ndline-tech"
title: Query Kibana (includes useful queries)
layout: manual_layout
parent: "/manual.html"
section: Logging
important: true
---
All logs for GOV.UK on all environments are collected in Kibana, which you can
access through [Logit](logit.html).

Kibana can be [searched using the Lucene search syntax or full JSON-based
Elasticsearch queries][kibana-search]. See an [example Elasticsearch query](#example-elasticsearch-query) below.

## Set up the UI

The default view for Kibana includes a timestamp and a grouped `_source` column of all information per log. Depending on what you're trying to achieve, you may find it beneficial to re-organise your view.

You can specify a field in the logs list by navigating the "Available Fields" list on the left hand side, hovering over a field you want to interrogate and clicking "add". Some useful fields include:

- application
- controller
- route
- path
- status
- request
- tags

You can additionally remove fields by following the same steps above for "Selected Fields" and clicking "remove".

You can also manage the timeline bar chart at the top fo the view by changing the dropdown above the bar chart from "auto" to whichever delimitater suits your needs (hourly, daily, weekly etc) and specify the time frame of the bar chart by clicking the time range in the top right-hand corner.

## Examples

You can save and load queries using the buttons in the top right. You may want to use one of the existing queries as a starting point instead of writing a query from scratch.

![Kibana saved searches](images/kibana_saved_searches.png)

Every change to the query changes the URL in the browser. This URL is rather long and unfriendly, and often gets mangled by the Slack or Trello parser when trying to share it. Instead, you can generate a "short URL" by clicking the "Share" link in the top right, followed by "Short URL".

### All requests rendered by the content_items controller in government-frontend

```rb
application: government-frontend AND tags: request AND controller: content_items
```

### All requests within the /government/groups path

```rb
tags: request AND path: \/government\/groups\/*
```

### 5xx errors returned from cache layer

```rb
host:cache* AND (@fields.status:[500 TO 504] OR status:[500 TO 504])
```

### Puppet runs

```rb
# both agent and master
syslog_program:puppet*

# agent only
syslog_program:"puppet-agent"

# master only
syslog_program:"puppet-master"
```

### Syslog logs

```rb
application:"syslog"
```

### Syslog logs on a specific machine

```rb
source:"/var/log/syslog" AND beat.hostname:"ip-10-13-5-15"
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

> **Note**
>
> The `@timestamp` field records the request END time. To calculate request start time subtract `request_time`.

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

### Mirrorer logs

```rb
syslog_program:"govuk_sync_mirror"
```

### Publishing API timeouts

```rb
message:"TimedOutException" AND (application:"specialist-publisher" OR application:"whitehall" OR application:"content-tagger")
```

### Example Elasticsearch query

You can use Elasticsearch queries by clicking "Add a filter" and then specifying "Edit Query DSL".
Here is an example of finding all requests to the Transition Checker login page (ignoring URL query parameters) which resulted in a 410:

```json
{
  "query": {
    "bool": {
      "filter": [
        {
          "term": {
            "status": 410
          }
        },
        {
          "regexp": {
            "request": {
              "value": ".+transition-check/login.+"
            }
          }
        }
      ]
    }
  }
}
```

This has no advantage over using Lucene query syntax in the search bar, which is much simpler: `request:*transition-check\/login* AND status:410`.

However, if you wanted to count the number of unique IP addresses that were served this response, you need an [aggregation](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations.html), which requires the Elasticsearch syntax.

Choose "Dev Tools" in the menu on the left, then fill out your JSON search, ensuring that you retain the `GET _search` on line 1.
You'll probably want to specify your date range in JSON as there is no way to do this through the UI on this screen.

```json
GET _search
{
  "query": {
    "bool": {
      "filter": [
        {
          "term": {
            "status": 410
          }
        },
        {
          "range": {
            "@timestamp": {
              "time_zone": "+01:00",
              "gte": "2021-06-16T12:00:00",
              "lt": "2021-06-16T17:00:00"
            }
          }
        },
        {
          "regexp": {
            "request": {
              "value": ".+transition-check/login.+"
            }
          }
        }
      ]
    }
  },
  "aggs": {
    "unique-ips": {
      "terms": {
        "field": "remote_addr"
      }
    }
  }
}
```

Press the "Play" icon to run the query, whose results will appear in the panel on the right.
You'll see a `hits` array for each matching record, and also an `aggregations` object where your aggregations are grouped into `buckets`.
From here it should be quite simple to count the number of unique IPs.

## Syslog program names

If you're looking for specific program outputs, use `syslog_program:FOO`:

- `audispd`: This is used to see all audit logs from various servers. You can refer to README for searching particular types of audit logs. The program name with combination of source_host and message can be helped for looking at various specific audit log lines on a server.
- `clamd`
- `cron`
- `govuk_sync_mirror`: Records information from govuk_sync_mirror script
- `puppet-agent`: Records output for govuk_puppet script on various servers
- `puppet-master`
- `smokey`

## Gotchas

- Score: does a aggregation of field on last 2000 results
- Terms is not an aggregation of field, it is an aggregation of terms in the field across 1 recent indices
- For more elaborate searching, [read about the Lucene and Elasticsearch syntax][kibana-search]
- `@timestamp` of nginx log entries records [request end time is sometimes confusing][end]

[kibana-search]: https://www.elastic.co/guide/en/kibana/current/search.html
[end]: http://serverfault.com/questions/438880/what-does-nginxs-time-local-logging-variable-mean-specifically/438891#438891
