---
owner_slack: "#govuk-search"
title: Opensearch cluster health
layout: manual_layout
parent: "/manual.html"
section: Search on GOV.UK
related_repos: [search-api]
type: learn
---

OpenSearch reports cluster health as one of three possible states, based on
the state of its [primary and replica shards][primary-and-replica-shards].

- `green` - all primary and secondary (replica) shards are allocated. There are
  two (or more) copies of all shards across the nodes on the cluster.
- `yellow` - all primary shards are allocated, but at least one replica shard
  is not allocated. Any shards that only exist as a primary are at risk of data
  loss _should another node in the cluster fail_.
- `red` - at least one primary shard is not allocated. This can happen when an
  entire cluster is cold started, before it's initially allocated the primary
  shards. If it happens at other times this may be a sign of data loss.

[primary-and-replica-shards]: https://docs.opensearch.org/latest/api-reference/cluster-api/cluster-health/

### Investigating problems

#### Grafana dashboard

Opensearch cluster health metrics are available on the [Search API v1 Grafana dashboard][search-api-v1-dashboard]
[search-api-v1-dashboard]: https://grafana.eks.production.govuk.digital/goto/sx8shj?orgId=default

#### AWS dashboards

Follow the [instructions to login to the AWS Console UI](/manual/access-aws-console.html).

There are tabs for 'Cluster health' and 'Instance health'.  The graphs in the
console link to AWS Cloudwatch, where historic metrics can be viewed over custom
time periods.

#### Use the OpenSearch API

An alternative to using the dashboard is accessing the OpenSearch health API
yourself. Start with the [`/_cluster/health` endpoint][cluster-health-endpoint]
and go from there.

[cluster-health-endpoint]: https://docs.opensearch.org/latest/api-reference/cluster-api/cluster-health/

Response JSON from the `/_cluster/health` endpoint looks like:

```json
{
  "cluster_name":"logging",
  "status":"green",
  "timed_out":false,
  "number_of_nodes":3,
  "number_of_data_nodes":3,
  "active_primary_shards":225,
  "active_shards":335,
  "relocating_shards":0,
  "initializing_shards":0,
  "unassigned_shards":0
}
```

### Access OpenSearch dashboard

See [Manage OpenSearch on AWS][manage-opensearch-on-aws]

[manage-opensearch]: ./manage-opensearch-on-aws.html.md

### Fixing issues with the cluster

GOV.UK have a Enterprise level support plan with AWS for staging and
production. Since we are using a managed service, AWS should be the first point
of contact for fixing issues with the OpenSearch cluster.  They can be
contacted by telephone, live chat or support request.

Response times are:

- General guidance: 24 hours
- System impaired: 12 hours
- Production system impaired: 4 hours
- Production system down: 1 hour
- Business-critical system down: 15 minutes

All requests are created through the [AWS Console](https://console.aws.amazon.com/support/home).
Be sure to assume the correct role first, for the environment in question.
