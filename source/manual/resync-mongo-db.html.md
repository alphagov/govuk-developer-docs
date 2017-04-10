---
title: Resync a Mongo database
section: Databases
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/infrastructure/howto/resync-mongo-db.md"
---



> **This page was imported from [the opsmanual on github.gds](https://github.gds/gds/opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.gds/gds/opsmanual/tree/master/infrastructure/howto/resync-mongo-db.md)


# Resync a Mongo database

To
[resync](https://docs.mongodb.org/v2.4/tutorial/resync-replica-set-member/)
a member of a mongo cluster, run our force\_resync
[fabric](https://github.com/alphagov/fabric-scripts) script:

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
