---
owner_slack: "#govuk-2ndline"
title: Resync a MongoDB database
section: Databases
layout: manual_layout
parent: "/manual.html"
---

> **WARNING**
>
> This process deletes all data from a MongoDB node and forces a full
> copy from the current primary member of the replica set. This causes
> additional load on the primary member of the replica set and reduces the
> number of available copies of the database, so is best performed at a quiet
> time. Try not to resync more than one secondary at a time.

To
[resync](https://docs.mongodb.org/v2.4/tutorial/resync-replica-set-member/)
a member of a MongoDB cluster, run our `force_resync`
[Fabric](https://github.com/alphagov/fabric-scripts) script:

```
fab $environment -H $hostname mongo.force_resync
```

The `mongo.force_resync` command checks that you are not trying to
perform a resync on the primary member.

You can run `mongo.status` at any time to see the status of the cluster:

```
fab $environment -H $hostname mongo.status
```
