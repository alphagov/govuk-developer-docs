---
owner_slack: '#2ndline'
review_by: 2017-04-12
title: 'Elasticsearch Cluster Health'
parent: /manual.html
layout: manual_layout
section: Icinga alerts
---

# Elasticsearch Cluster Health

Elasticsearch reports cluster health as one of three possible states, based on
the state of its primary and replica shards.

- `green` - all primary and secondary (replica) shards are allocated. There are
  two (or more) copies of all shards across the nodes on the cluster.
- `yellow` - all primary shards are allocated, but at least one replica shard
  is not allocated. Any shards that only exist as a primary are at risk of data
  loss _should another node in the cluster fail_.
- `red` - at least one primary shard is not allocated. This can happen when an
  entire cluster is cold started, before it's initially allocated the primary
  shards. If it happens at other times this may be a sign of data loss.

More [comprehensive documentation on cluster
health](https://www.elastic.co/guide/en/elasticsearch/guide/current/_cluster_health.html)
can be found in the Elasticsearch documentation.

Make sure you understand the consequences of the problem before jumping to a
solution.

Nagios uses the `check_elasticsearch` check from
[nagios-plugins](https://github.com/alphagov/nagios-plugins/) to
monitor the health of the Elasticsearch cluster. This plugin uses various
endpoints of the Elasticsearch API, but also extrapolates additional information
to help you diagnose any problems.

You can also access the Elasticsearch health API directly. Start with the
[`/_cluster/health` endpoint](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/cluster-health.html)
and go from there.

| Response json from the `/_cluster/health` endpoint looks like

    { "cluster_name":"logging",
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

### Investigating problems

Some tools available to investigate problems include:

[elasticsearch-head](http://mobz.github.io/elasticsearch-head/)

:   a plugin that helps you have a nice UI for looking at current state
    of elasticsearch.

    To use this following steps might be handy

    -   forward port 9200 from the elasticsearch box to your localhost

        One way to do this is
        `ssh -L9200:localhost:9200 logs-elasticsearch-1.management.staging`
    -   access at <http://localhost:9200/_plugin/head/>

    The tabs on top right corner for Cluster Status & Cluster Health
    come handy

You can find our Elasticsearch clusters by running
`fab production puppet_class:govuk_elasticsearch hosts`.

Configuration files for elasticsearch are in
`/var/apps/<name>/config/elasticsearch.yml`

Elasticsearch logs live at
`/var/logs/elasticsearch/<logging|govuk-production>.log`

**Note:** If you have had a health alert for the logs-elasticsearch
cluster you may need to change where LogStash writes to to ensure we can
keep getting getting syslog entries (see section [Manual repointing of
LogStash to logs-elasticsearch cluster]()).

### How to fix unassigned nodes in indices?

We can have a red status on elasticsearch cluster health when you have
unassigned shards for some indices. (We have seen a similar scenario
occur on the integration environment, when logs-es-1/3 ran out of space
and logs-es-2 reached it load limit \[number of file open error\]).

This can be solved by:

Restarting elasticsearch node in order giving elastic node enough time
to start up and reallocate the shards allocated to it before starting
the other elasticsearch (this can be checked using elasticsearch-head or
using cluster health api). This should be enough to fix the issue

An exception to the above case can happen after the restart of the
cluster, when some shards in indices can have both primary and replica
version unassigned. Then any further restarting would not fix the issue.
Closing and opening the index with such an issue should fix the problem:

    curl -XPOST 'localhost:9200/<index_name>/_close?pretty=true'
    curl -XPOST 'localhost:9200/<index_name>/_open?pretty=true'

**NB**: Make sure a thorough analysis is done before fixing the problem,
as any down time to es cluster can result in loss of data.

### Split Brain

Split brain occurs when two parts of the cluster lose connectivity with each
other and both independently elect new master nodes, and each part of the
cluster starts operating independently, allowing the data indexed to diverge.

We guard against split brain problem by following the
[recommended practise](http://asquera.de/opensource/2012/11/25/elasticsearch-pre-flight-checklist/#avoiding-split-brain)
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

### Manual repointing of LogStash to logs-elasticsearch cluster

Currently logstash (logging-1.management) talks only to
logs-elasticsearch-cluster (which is mapped through a dns entry to
logs-elasticsearch-1.management) for sending logs.

If logs-elasticsearch-1.management is not available, we need to tell
logstash on logging-1 to send its syslog data to a different
elasticsearch node. This is done by changing the /etc/hosts file on
logging-1.management

### 'One or more indexes are missing replica shards.' despite cluster being green

For some reason the elasticsearch plugin [does not consider a replica in the
`REALLOCATING` state to be
healthy](https://github.com/alphagov/nagios-plugins/blob/6534386f658ce573a8b65e0f9147f61b1b0fe964/plugins/command/check_elasticsearch.py#L453).

You can identify reallocating replica shards using Elasticsearch Head - they
will be displayed in purple (reallocating) and without a thick border (replica).

Alternatively, you can run check_elasticsearch directly on the
logs-elasticsearch box:

```
check_elasticsearch -vv
```

As long as the cluster health is green, Elasticsearch should be reasonably happy
and you can leave it to reallocate the replicas, which may take some time.

You can monitor the progress of shard (re)allocation using the [cat recovery
endpoint](https://www.elastic.co/guide/en/elasticsearch/reference/current/cat-recovery.html).
