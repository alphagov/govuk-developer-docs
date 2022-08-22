---
owner_slack: "#govuk-2ndline-tech"
title: MongoDB infra commands
section: Databases
layout: manual_layout
parent: "/manual.html"
---

## Check the MongoDB version

SSH into a `mongo` machine and run:

```
$ mongo --quiet --eval 'db.version()'
2.6.12
```

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

## Step down the primary

"Stepping down" the primary will change it to a secondary machine, and one of the secondary machines will become the new primary.

First, you'll need to SSH into the primary machine (see "[find the primary](#find-the-primary)").

Once on the machine, you can step it down with the following command:

```
mongo --quiet --eval 'printjson(rs.stepDown())'
```

You may see the following output (and an exit code of 252) but the command did in fact work. The machine may also disconnect the current console session after a short while.

```
2022-08-22T11:18:29.340+0000 DBClientCursor::init call() failed
2022-08-22T11:18:29.341+0000 Error: error doing query: failed at src/mongo/shell/query.js:81
```

You can verify that it worked by following the "find the primary" instructions again, noting that one of the other machines will be the new primary.

## Find the primary

To do this, SSH into each `mongo` machine in turn, i.e.

```
gds govuk connect -e staging ssh mongo:1
gds govuk connect -e staging ssh mongo:2
# ... etc
```

On each machine, run `mongo --quiet --eval 'JSON.stringify(rs.isMaster())' | jq '.ismaster'`.
When the output is `true`, you're on the primary machine.

## Force resync

> **WARNING**
>
> This process deletes all data from a MongoDB node and forces a full
> copy from the current primary member of the replica set. This causes
> additional load on the primary member of the replica set and reduces the
> number of available copies of the database, so is best performed at a quiet
> time. Try not to resync more than one secondary at a time.

To [resync](https://docs.mongodb.org/v2.4/tutorial/resync-replica-set-member/) a member of a MongoDB cluster:

1. Check that the member [isn't the primary](#find-the-primary). Again: **do not run this on the primary**.
1. Disable Puppet (`govuk_puppet --disable "Forcing mongodb resync"`)
1. Stop the app (`sudo service mongodb stop`)
1. Wait for the process to stop (`ps -C mongod` should show no processes)
1. Delete the data (`rm -rf /var/lib/mongodb/*`)
1. Start the app (`sudo service mongodb start`)
1. Re-enable Puppet (`govuk_puppet --enable`)
