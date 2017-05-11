---
owner_slack: "#2ndline"
title: Redis alerts
section: Icinga alerts
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/2nd-line/alerts/redis.md"
last_reviewed_on: 2017-03-12
review_in: 6 months
---

> **This page was imported from [the opsmanual on GitHub Enterprise](https://github.digital.cabinet-office.gov.uk/gds/opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.digital.cabinet-office.gov.uk/gds/opsmanual/tree/master/2nd-line/alerts/redis.md)


We have a few monitoring checks for Redis:

-  memory usage
-  number of connected clients
-  list length (for the `logs-redis` machines only)

Redis is configured to use 75% of the system memory. If Redis memory usage
reaches this limit it will stop accepting data input. Redis is also unable to
write its RDB data dumps when it's out of memory, so data loss is possible.

Since version 2.6, Redis [dynamically sets the maximum allowed number of
clients](http://redis.io/topics/clients) to 32 less than the number of file
descriptors that can be opened at a time.

## General Redis investigation tips

If Redis is using large amounts of memory you could use ``redis-cli --bigkeys``
to find out what those things might be.

## Redis for logs

### Investigation of the problem

For logs-redis, memory may be exhausted if the elasticsearch river is not
consuming data from redis for some reason. In this case, redis will accumulate
data up to its memory limit and then stop accepting log data. In this
condition log data will be lost from the logging pipeline because logship
discards data.

-  You should use graphite for looking at cpu load and used memory.
   (Pending: More graphite inputs)
-  Also check how does this impacts elasticsearch.
-  `redis-cli INFO` and `redis-cli CLIENT LIST` command helps to
   see present info. [Other commands may come handy](http://redis.io/commands).

### Redis rivers for elasticsearch

We use [elasticsearch-redis-river](https://github.com/leeadkins/elasticsearch-redis-river)
(a redis river for elasticsearch). This is a special process which reads data continuously from a redis queue (called `logs`) into elasticsearch.

There is a nagios alert (listed above) for when the `logs` redis list gets
too long. This might be because elasticsearch is unavailable or may be for
some other reason.

Generally this can be fixed by deleting and recreating the rivers. This is safe to do because the river pulls data from redis (rather than redis pushing data into elasticsearch).

Delete and recreate the rivers with this fabric command:

```
fab $environment -H logs-elasticsearch-1.management elasticsearch.delete:_river puppet
```

The `elasticsearch.delete:_river` command deletes all rivers, and `puppet`
runs puppet which will recreate them.

To manually check the length of the list, use:

```
fab $environment -H logs-redis-1.management do:'redis-cli LLEN logs'
```
