---
owner_slack: "#govuk-2ndline"
title: Elasticsearch cluster health
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2018-08-31
review_in: 6 months
---

Elasticsearch reports cluster health as one of three possible states, based on
the state of its [primary and replica shards](https://www.elastic.co/guide/en/elasticsearch/reference/2.4/_basic_concepts.html#_shards_amp_replicas).

- `green` - all primary and secondary (replica) shards are allocated. There are
  two (or more) copies of all shards across the nodes on the cluster.
- `yellow` - all primary shards are allocated, but at least one replica shard
  is not allocated. Any shards that only exist as a primary are at risk of data
  loss _should another node in the cluster fail_.
- `red` - at least one primary shard is not allocated. This can happen when an
  entire cluster is cold started, before it's initially allocated the primary
  shards. If it happens at other times this may be a sign of data loss.

More [comprehensive documentation on cluster health][cluster-health-endpoint]
can be found in the Elasticsearch documentation.

Make sure you understand the consequences of the problem before jumping to a
solution.

Icinga uses the `check_elasticsearch` check from
[nagios-plugins](https://github.com/alphagov/nagios-plugins/) to
monitor the health of the Elasticsearch cluster. This plugin uses various
endpoints of the Elasticsearch API, but also extrapolates additional information
to help you diagnose any problems.

### Investigating problems

#### Find hosts in an Elasticsearch cluster

We use different Elasticsearch clusters for different applications. For example
the `rummager-elasticsearch` cluster powers the GOV.UK search API.

You can find hostnames by running:

```
fab production puppet_class:govuk_elasticsearch hosts
```

#### View a live dashboard

The [elasticsearch-head](http://mobz.github.io/elasticsearch-head/) plugin is a nice UI for looking at current state of Elasticsearch.

To use this, forward port 9200 from the Elasticsearch box to your localhost:

```
ssh -L9200:localhost:9200 rummager-elasticsearch-1.api.staging
```

Access the UI at <http://localhost:9200/_plugin/head/>

The tabs on top right corner for Cluster Status & Cluster Health come in handy

#### Use the Elasticsearch API

An alternative to using the dashboard is accessing the Elasticsearch health API yourself. Start with the
[`/_cluster/health` endpoint][cluster-health-endpoint] and go from there.

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

#### Other options

- Configuration files for Elasticsearch are in `/etc/elasticsearch/<name>/elasticsearch.yml`

- Elasticsearch logs live at `/var/log/elasticsearch/<name>/`

### How to fix unassigned shards in indices?

#### Before you do anything

Make sure a thorough analysis is done before fixing the problem,
as any down time of the Elasticsearch cluster can result in loss of data. In general, avoid shutting down a node when there isn't any other node available with replicas of its shards.

#### Unassigned replica shards

When the health is yellow, i.e. replica shards are not allocated, Elasticsearch should automatically allocate another node to create replicas on, given enough time.

You can manually interfere with this process using the [Cluster Reroute API](https://www.elastic.co/guide/en/elasticsearch/reference/2.4/cluster-reroute.html#cluster-reroute).

#### Unassigned primary shards
We can have a red status on Elasticsearch cluster health when you have
unassigned shards for some indices. (We have seen a similar scenario
occur on the integration environment, when logs-es-1/3 ran out of space
and logs-es-2 reached it load limit \[number of file open error\]).

This can be solved by:

Restarting Elasticsearch node in order giving elastic node enough time
to start up and reallocate the shards allocated to it before starting
the other Elasticsearch (this can be checked using elasticsearch-head or
using cluster health api). This should be enough to fix the issue.

An exception to the above case can happen after the restart of the
cluster, when some shards in indices can have both primary and replica
version unassigned. Then any further restarting would not fix the issue.
Closing and opening the index with such an issue should fix the problem:

```
curl -XPOST 'localhost:9200/<index_name>/_close?pretty=true'
curl -XPOST 'localhost:9200/<index_name>/_open?pretty=true'
```

### Split brain

Split brain occurs when two parts of the cluster lose connectivity with each
other and both independently elect new master nodes, and each part of the
cluster starts operating independently, allowing the data indexed to diverge.

We guard against split brain problem by following the
[recommended practice][blog]
of setting minimum number of master-eligible nodes to `([the size of the cluster] / 2) + 1` N/2+1.

This means that when adding or removing nodes you need to ensure that all
nodes get the updated configuration with the new value for this calculation.

If split brain does occur, you can use the following steps to fix it. But it is
**strongly** suggested to thoroughly investigate the problem first before
doing so.

- By stopping the node which considers itself to belong to two cluster
  and belongs to two different masters. example:

    cluster of three boxes: e1, e2, e3
    Clusters present after split brain:
      e1 <-> e2
      e2 <-> e3

    As per first cluster, e1 is the master, and the latter cluster e3 is the master

- Waiting for the cluster health to change to yellow before restarting
  the stopped Elasticsearch box.

[blog]: http://asquera.de/opensource/2012/11/25/elasticsearch-pre-flight-checklist/#avoiding-split-brain

### 'One or more indexes are missing replica shards.' despite cluster being green

For some reason the Elasticsearch plugin [does not consider a replica in the
`REALLOCATING` state to be
healthy](https://github.com/alphagov/nagios-plugins/blob/6534386f658ce573a8b65e0f9147f61b1b0fe964/plugins/command/check_elasticsearch.py#L453).

You can identify reallocating replica shards using Elasticsearch Head - they
will be displayed in purple (reallocating) and without a thick border (replica).

Alternatively, you can run check_elasticsearch directly on the Elasticsearch
box:

```
check_elasticsearch -vv
```

As long as the cluster health is green, Elasticsearch should be reasonably happy
and you can leave it to reallocate the replicas, which may take some time.

You can monitor the progress of shard (re)allocation using the [cat recovery
endpoint](https://www.elastic.co/guide/en/elasticsearch/reference/current/cat-recovery.html).
