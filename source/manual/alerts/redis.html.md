---
owner_slack: "#govuk-2ndline"
title: Redis alerts
section: Icinga alerts
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-08-31
review_in: 6 months
---

We have a few monitoring checks for Redis:

-  memory usage
-  number of connected clients

Redis is configured to use 75% of the system memory. If Redis memory usage
reaches this limit it will stop accepting data input. Redis is also unable to
write its RDB data dumps when it's out of memory, so data loss is possible.

Since version 2.6, Redis [dynamically sets the maximum allowed number of
clients][redis-clients] to 32 less than the number of file
descriptors that can be opened at a time.

## General Redis investigation tips

If Redis is using large amounts of memory you can use ``redis-cli --bigkeys``
to find out what those things might be. If any of the returned keys are new, try and speak to the team responsible.

If there is an associated graph, it may also be worth checking as the alert could be a temporary spike, for example: due to running a rake task.

### Uniquejobs hash

We use a [custom fork][unique-jobs] of a gem called `sidekiq-unique-jobs` in some of our applications. This gem creates a key in Redis called `uniquejobs`

We have had an incident where the `uniquejobs` key has grown to the point that it caused high memory alerts for Redis. You can delete this key safely by runnning the following command on the associated Redis box:

```bash
$ redis-cli DEL uniquejobs
```

We have noticed that when this key grows on the redis box used by the Publishing
Api (currently `redis-1`), it can be accompanied by high Sidekiq queue latency
for Whitehall's queues. You can check the queue latency on the [Grafana
dashboard][whitehall-sidekiq-grafana].

[redis-clients]: https://redis.io/topics/clients
[unique-jobs]: https://github.com/alphagov/sidekiq-unique-jobs
[whitehall-sidekiq-grafana]: https://grafana.publishing.service.gov.uk/dashboard/file/sidekiq.json?refresh=1m&orgId=1&var-Application=whitehall&var-Queues=All
