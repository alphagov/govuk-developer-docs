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

Try restarting one of the lagging mongodb secondaries.

SSH into a [non-primary machine](/manual/mongo-db-commands.html#find-the-primary) and run:

```
sudo service mongodb restart
```

This may restart replication on that node, and also cause the other lagging node to resync with the primary node and restart its own
replication.

If you need to restart mongodb on the other secondaries, do this one node at a time, as load on the primary mongo node may be increased by the replication.

If restarting doesn't solve the problem, you can [force a resync](/manual/mongo-db-commands.html#force-resync).
