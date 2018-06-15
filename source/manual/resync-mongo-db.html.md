---
owner_slack: "#govuk-2ndline"
title: Resync a MongoDB database
section: Databases
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-06-14
review_in: 6 months
---

Warning: This process deletes all data from a MongoDB node and forces a full
copy from the current primary member of the replica set. This causes additional
load on the primary member of the replica set and reduces the number of
available copies of the database, so is best performed at a quiet time.

To
[resync](https://docs.mongodb.org/v2.4/tutorial/resync-replica-set-member/)
a member of a MongoDB cluster, run our force\_resync
[Fabric](https://github.com/alphagov/fabric-scripts) script:

    fab {env name} -H {host name} mongo.force_resync

The mongo.force\_resync command checks that you are not trying to
perform a resync on the primary member.

If you need to resync the
[primary](https://docs.mongodb.org/manual/core/replica-set-members/#replica-set-primary-member)
member, first resync all of the secondary members that require a resync,
then:

1.  Run mongo.step\_down\_primary:

        fab {env name} -H {host name} mongo.step_down_primary

2.  Run mongo.force\_resync against the former primary member

You can run mongo.status at any time to see the status of the cluster:

    fab {env name} -H {host name} mongo.status
