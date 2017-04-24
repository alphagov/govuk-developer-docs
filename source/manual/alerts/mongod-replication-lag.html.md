---
owner_slack: '#2ndline'
review_by: 2017-05-27
title: 'mongod replication lag'
parent: /manual.html
layout: manual_layout
section: Icinga alerts
---

# 'mongod replication lag'

### Investigating the problem

There is a fabric task to show various mongo replication status
information.:

    fab <environment> -H mongo-?.backend mongo.status

-   The `db.printReplicationInfo()` section shows where the primary
    node's
    [oplog](http://docs.mongodb.org/manual/core/replica-set-oplog/) is
    up to.
-   The `db.printSlaveReplicationInfo()` section shows where each
    secondary is synced to and how far behind the master it is.
-   The `rs.status()` section shows the current status of each node and
    the last heartbeat error message for the secondaries.

### Possible fixes

-   Try restarting one of the lagging mongod secondaries:

        fab <environment> -H mongo-?.backend app.restart:mongodb

This may restart replication on that node, and also cause the other
lagging node to resync with the primary node and restart its own
replication.

-   If restarting doesn't solve the problem force a resync with fabric:

        fab <environment> -H mongo-?.backend mongo.force_resync

