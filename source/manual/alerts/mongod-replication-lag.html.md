---
owner_slack: "#govuk-2ndline-tech"
title: mongod replication lag
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

### Investigating the problem

Begin by [checking the Mongo cluster status](/manual/mongo-db-commands.html#check-cluster-status),
then [checking the replication info](/manual/mongo-db-commands.html#check-replication-info)

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