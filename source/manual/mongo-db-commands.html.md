---
owner_slack: "#govuk-2ndline-tech"
title: Resync a MongoDB database
section: Databases
layout: manual_layout
parent: "/manual.html"
---

## Check cluster status

Check cluster status by SSH'ing into a `mongo` machine and running:

```
mongo --quiet --eval 'printjson(rs.status())'
```

This will output a JSON-like representation of the Mongo cluster. The `members` property contains an array of objects, each including:

- `stateStr`: "PRIMARY" for the primary machine, "SECONDARY" for secondary machines. There should only be one primary.
- `name`: the address of the machine, e.g. `mongo-3.staging.govuk-internal.digital:27017`.
- `health`: `1` if the machine is healthy.
- `lastHeartbeat`: shows the last heartbeat error message for the secondaries, or a timestamp if machine is healthy.

The command above cannot be parsed by JSON parsers. You can output true JSON by substituting `printjson` with `JSON.stringify`, which you can then manipulate on the command line using something like `jq`. For example, output just the `members` array by running:

```
mongo --quiet --eval 'JSON.stringify(rs.status())' | jq '.members'
```

## Check replication info

Find out where the primary node's [oplog](http://docs.mongodb.org/manual/core/replica-set-oplog/) is up to:

```
$ mongo --quiet --eval 'db.printReplicationInfo()'

configured oplog size:   14392MB
log length start to end: 19991secs (5.55hrs)
oplog first event time:  Mon Aug 22 2022 02:26:55 GMT+0000 (UTC)
oplog last event time:   Mon Aug 22 2022 08:00:06 GMT+0000 (UTC)
now:                     Mon Aug 22 2022 10:38:13 GMT+0000 (UTC)
```

Find out where each secondary is synced to and how far behind the primary they are:

```
$ mongo --quiet --eval 'db.printSlaveReplicationInfo()'

source: mongo-1.staging.govuk-internal.digital:27017
	syncedTo: Mon Aug 22 2022 08:00:06 GMT+0000 (UTC)
	0 secs (0 hrs) behind the primary 
source: mongo-2.staging.govuk-internal.digital:27017
	syncedTo: Mon Aug 22 2022 08:00:06 GMT+0000 (UTC)
	0 secs (0 hrs) behind the primary 
```

## Force resync

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
