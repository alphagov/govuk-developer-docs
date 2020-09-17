---
owner_slack: "#govuk-2ndline"
title: mongod replication lag
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

### Investigating the problem

There is a Fabric task to show various MongoDB replication status
information.:

  ```
  fab <environment> -H api-mongo-[n].api mongo.status
  ```

- The `db.printReplicationInfo()` section shows where the primary
  node's [oplog](http://docs.mongodb.org/manual/core/replica-set-oplog/)
  is up to.
- The `db.printSlaveReplicationInfo()` section shows where each
  secondary is synced to and how far behind the master it is.
- The `rs.status()` section shows the current status of each node and
  the last heartbeat error message for the secondaries.

### Possible fixes

> Be mindful that load on the primary mongo node may be increased by
> the replication and consider to limit restarts to one node at a time.

- Try restarting one of the lagging mongod secondaries:

  ```
  fab <environment> -H api-mongo-[n].api app.restart:mongodb
  ```

This may restart replication on that node, and also cause the other
lagging node to resync with the primary node and restart its own
replication.

- If restarting doesn't solve the problem force a resync with Fabric:

  ```
  fab <environment> -H api-mongo-[n].api mongo.force_resync
  ```
