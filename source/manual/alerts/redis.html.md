---
owner_slack: "#govuk-2ndline"
title: Redis alerts
section: Icinga alerts
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-01-26
review_in: 6 months
---

We have a few monitoring checks for Redis:

-  memory usage
-  number of connected clients

Redis is configured to use 75% of the system memory. If Redis memory usage
reaches this limit it will stop accepting data input. Redis is also unable to
write its RDB data dumps when it's out of memory, so data loss is possible.

Since version 2.6, Redis [dynamically sets the maximum allowed number of
clients](http://redis.io/topics/clients) to 32 less than the number of file
descriptors that can be opened at a time.

## General Redis investigation tips

If Redis is using large amounts of memory you can use ``redis-cli --bigkeys``
to find out what those things might be. If any of the returned keys are new, try and speak to the team responsible.

If there is an associated graph, it may also be worth checking as the alert could be a temporary spike, for example: due to running a rake task.
