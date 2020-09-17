---
owner_slack: "#govuk-2ndline"
title: 'PostgreSQL: replication too far behind'
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

> "replication on the postgres standby is too far behind primary [value in bytes]"

Replication from primary to secondary PostgreSQL machines is done using
Write Ahead Log (WAL) files, which represent a log of changes. The files
are streamed to standby machines, which replay the logs to keep in-sync.

When this alert fires, the Postgres standby replication process may be
struggling to keep up (due to load) or may have stopped altogether.

- If one node is down (resulting in Graphite having NULL values for one
  metric), you should see a CRITICAL alert.

- If both nodes are down then Graphite will return no data and an UNKNOWN
  alert will be raised.

The replication lag is measured by examining the difference in the [XLOG
location in bytes](https://wiki.postgresql.org/wiki/Streaming_Replication).
You can get a quick view of replication by doing the following:

- on a `postgresql-primary`: `ps -ef | grep sender`

- on a `postgresql-standby`: `ps -ef | grep receiver`

## Fix after an overload

If the slave has fallen too far behind or is in an otherwise
unrecoverable state then you may need to [resync
it](/manual/setup-postgresql-replication.html#syncing-a-standby).

## Fix after a restore

If a backup has recently been restored to the primary, it may be that
the primary did not keep enough WAL segments around to bring the
standby up to date. This can be fixed by restoring the backup to the
standby as well, after which normal replication will take over.

## Fix for a new machine

If this is a new machine, or if you have recently resynced it, the issue may be
that PostgreSQL replication is set up and running correctly, but `collectd`
needs to be restarted on either the primary or standby to ensure that Graphite
is receiving the metrics it needs.

```sh
$ sudo service collectd restart
```
