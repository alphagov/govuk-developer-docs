---
owner_slack: "#govuk-2ndline"
title: MongoDB rollback
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

### What is a rollback

Explanation from the [MongoDB
documentation](http://docs.mongodb.org/manual/core/replication/#replica-set-rollbacks):

> In some failover situations primaries will have accepted write
> operations that have not replicated to the secondaries after a
> failover occurs. This case is rare and typically occurs as a result of
> a network partition with replication lag. When this member (the former
> primary) rejoins the replica set and attempts to continue replication
> as a secondary the former primary must revert these operations or
> "roll back" these operations to maintain database consistency across
> the replica set.

### How to investigate

The rolled-back records can be viewed with
[bsondump](http://docs.mongodb.org/manual/reference/program/bsondump/)
which will output human readable JSON.

Some judgement is required to determine whether it is necessary to
recover the rolled-back data. In one example, we found that the user had
resubmitted the affected record(s) a few minutes later, presumably in
response to a UI error. Therefore recovery was not necessary.

### How to recover

If you are happy that the rolled-back data should be restored and
doesn't conflict with any existing records, then you can use
[mongorestore](http://docs.mongodb.org/manual/reference/program/mongorestore/).

The following arguments are necessary:

- `-h`: Hostname of the current `PRIMARY` node, from `rs.status()`.
- `-d`: Name of the database, from the BSON filename.
- `-c`: Name of the collection, from the BSON filename.
- `--objcheck`: Validate BSON. Not the default in MongoDB 2.2

For example:

```
dcarley@production-licensing-mongo-1:/var/lib/mongodb/rollback$ mongorestore -h licensing-mongo-2 -d licensify-audit -c audit --objcheck licensify-audit.audit.2013-05-30T12-45-42.1.bson
connected to: licensing-mongo-2
Thu May 30 13:56:52 licensify-audit.audit.2013-05-30T12-45-42.1.bson
Thu May 30 13:56:52 going into namespace [licensify-audit.audit]
1 objects found
```

Unfortunately `mongorestore` may not give any feedback about whether the
restore was successful. It is advisable to check the logs on the host
you referenced, and query MongoDB for the `_id` of the records you
expect.

When satisfied, the BSON files and rollback directory can be deleted.
This will resolve the Nagios alert.
