---
owner_slack: "#govuk-2ndline"
title: Elasticsearch cluster health
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

Elasticsearch reports cluster health as one of three possible states, based on
the state of its [primary and replica shards][primary-and-replica-shards].

- `green` - all primary and secondary (replica) shards are allocated. There are
  two (or more) copies of all shards across the nodes on the cluster.
- `yellow` - all primary shards are allocated, but at least one replica shard
  is not allocated. Any shards that only exist as a primary are at risk of data
  loss _should another node in the cluster fail_.
- `red` - at least one primary shard is not allocated. This can happen when an
  entire cluster is cold started, before it's initially allocated the primary
  shards. If it happens at other times this may be a sign of data loss.

[primary-and-replica-shards]: https://www.elastic.co/guide/en/elasticsearch/reference/2.4/_basic_concepts.html#_shards_amp_replicas

More [comprehensive documentation on cluster health][cluster-health-endpoint]
can be found in the Elasticsearch documentation.

Make sure you understand the consequences of the problem before jumping to a
solution.

Icinga uses the `check_elasticsearch_aws` check from [nagios-plugins][] to
monitor the health of the AWS managed Elasticsearch cluster. This plugin uses
various endpoints of the Elasticsearch API, but also extrapolates additional
information to help you diagnose any problems.

[nagios-plugins]: https://github.com/alphagov/nagios-plugins/

### Investigating problems

#### View a live dashboard

Follow the [instructions to login to the AWS Console UI](/manual/access-aws-console.html).

There are tabs for 'Cluster health' and 'Instance health'.  The graphs in the
console link to AWS Cloudwatch, where historic metrics can be viewed over custom
time periods.

#### Use the Elasticsearch API

An alternative to using the dashboard is accessing the Elasticsearch health API
yourself. Start with the [`/_cluster/health` endpoint][cluster-health-endpoint]
and go from there.

[cluster-health-endpoint]: http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/cluster-health.html

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

A tunnel to Elasticsearch in a specific environment (e.g staging) can be created
using the following:

```
ssh -At jumpbox.staging.govuk.digital -L 9200:localhost:9200 "ssh -q \`govuk_node_list --single-node -c search\` -L 9200:elasticsearch6.blue.staging.govuk-internal.digital:80"
```

Elasticsearch will then be available at <http://localhost:9200>.

#### Logging

Access to logs is detailed in the [logging documentation](/manual/logging.html#elasticsearch).

### Fixing issues with the cluster

GOV.UK have a Enterprise level support plan with AWS for staging and
production. Since we are using a managed service, AWS should be the first point
of contact for fixing issues with the Elasticsearch cluster.  They can be
contacted by telephone, live chat or support request.

Response times are:

- General guidance: 24 hours
- System impaired: 12 hours
- Production system impaired: 4 hours
- Production system down: 1 hour
- Business-critical system down: 15 minutes

All requests are created through the [AWS Console](https://console.aws.amazon.com/support/home).
Be sure to assume the correct role first, for the environment in question.
