---
owner_slack: "#govuk-2ndline"
title: Search API app healthcheck not ok
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2019-05-09
review_in: 6 months
---

The [Search API][search-api] has a healthcheck endpoint which provides
information about the current system status.

When the healthcheck returns a 'warning' or 'critical' status, find the
particular check that caused the alert, then follow the actions below.

Note: The healthcheck endpoint is not publicly available.

## Redis connectivity is not OK

The Sidekiq queue (which uses Redis as a data store) contains documents to be
indexed. The Search API takes jobs off the queue and adds them to the search
indexes.

We use Amazon [Elasticache](https://aws.amazon.com/elasticache), which
provides managed redis instances.

If the Search API cannot connect to Redis, this means that new editions of
documents that are added to the queue will not enter the search indexes.
While this issue is ongoing new editions won't appear in search results.

Moreover, if the Search API doesn't take new jobs off the Sidekiq queue,
and jobs continue to be added to the queue (by the publishing-api), this
can cause Redis to run out of memory.

#### How do I investigate this?

You'll need to find out why the Search API can't connect to Redis.

General tips: reproduce the connectivity issue, check application logs, and
look at the redis cluster (Elasticache) in the AWS console.

[More information about Redis Alerts][redis]

## Sidekiq queue latency is not OK

This alert triggers when there are jobs in the Sidekiq queue that are waiting
too long to be processed. This could mean that documents aren't appearing
in search results after they've been published.

The thresholds are set in the Search API [Github repository][search-github-repo].

##### How do I investigate this?

The issue could be caused by a temporary spike in publishing activity, or
something being wrong with the Search API.

You can [check the Sidekiq Grafana dashboard for the Search API][sidekiq-grafana-dashboard]. Take a look at the "Retry set size" - this could mean that jobs are failing. You can then look at [Sentry][sentry] or [Sidekiq web][sidekiq-web] to see what's going on.

## Elasticsearch connectivity is not OK

The Search API uses elasticsearch as an underlying data store and search
engine.

If the application cannot connect to the elasticsearch cluster,
this will prevent end users performing searches.

Note: We use a managed elasticsearch, [Amazon Elasticsearch Service][aws-elasticsearch], rather than running our own.

To solve this issue, look at the logs of the application to see what
is wrong.

#### How do I investigate this?

Find out why the Search API can't connect to elasticsearch.

- Look at the Search API logs
- Look at the [elasticsearch cluster health][cluster-health]
- Check the status of the Elasticsearch cluster in the AWS console


[search-api]: /apps/search-api.html
[redis]: /manual/alerts/redis.html#header
[sidekiq-grafana-dashboard]: https://grafana.production.govuk.digital/dashboard/file/sidekiq.json?refresh=1m&orgId=1&var-Application=search-api&var-Queues=All
[sentry]: /manual/error-reporting.html
[sidekiq-web]: /manual/monitor-sidekiq-workers.html
[search-github-repo]: https://github.com/alphagov/search-api/
[cluster-health]: /manual/alerts/elasticsearch-cluster-health.html
[aws-elasticsearch]: https://aws.amazon.com/elasticsearch-service/
