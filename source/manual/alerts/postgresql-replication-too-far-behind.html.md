---
owner_slack: "#2ndline"
title: 'PostgreSQL: replication too far behind'
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2018-03-06
review_in: 6 months
---

> "replication on the PostgreSQL slave is too far behind master [value in bytes]"

When this alert fires, the Postgres slave replication process may be
struggling to keep up (due to load) or may have stopped altogether. Take
a look at the graph linked by Nagios historical information.

If one node is down (resulting in Graphite having NULL values for one
metric) then the reported lag will jump to size of the XLOG position on
the remaining node and raise a CRITICAL alert.

If both nodes are down then Graphite will return no data and an UNKNOWN
alert will be raised. This should correlate with other checks for server
and database health.

You can get a quick view of postgresql's wal by doing the following:

on a `postgresql-primary`: `ps -ef | grep sender`

on a `postgresql-standby`: `ps -ef | grep receiver`

If the slave has fallen too far behind or is in an otherwise
unrecoverable state then you may need to [resync
it](/manual/setup-postgresql-replication.html#syncing-a-standby).

If this is a new machine, or if you have recently resynced it, the issue may be that PostgreSQL replication is set up and running correctly, but `collectd` needs to be restarted on either the primary or standby to ensure that Graphite is receiving the metrics it needs.

```
sudo service collectd restart
```

The replication lag is measured by examining the difference in the [XLOG
location in
bytes](https://wiki.postgresql.org/wiki/Streaming_Replication).
