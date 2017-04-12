---
title: 'PostgreSQL replication'
parent: /manual.html
layout: manual_layout
section: Icinga alerts
---

# PostgreSQL replication

### 'replication on the postgres slave is too far behind master \[value in bytes\]'

When this alert fires, the Postgres slave replication process may be
struggling to keep up (due to load) or may have stopped altogether. Take
a look at the graph linked by Nagios historical information.

If one node is down (resulting in Graphite having NULL values for one
metric) then the reported lag will jump to size of the XLOG position on
the remaining node and raise a CRITICAL alert.

If both nodes are down then Graphite will return no data and an UNKNOWN
alert will be raised. This should correlate with other checks for server
and database health.

If the slave has fallen too far behind or is in an otherwise
unrecoverable state then you may need to [resync
it](../infrastructure/howto/setup-postgresql-replication.html#syncing-a-standby).

If this is a new machine, the issue may be that PostgreSQL replication
is set up and running correctly, but `collectd` needs to be restarted on
either the primary or standby to ensure that Graphite is receiving the
metrics it needs.

The replication lag is measured by examining the difference in the [XLOG
location in
bytes](https://wiki.postgresql.org/wiki/Streaming_Replication).

