---
title: Set up PostgreSQL replication
section: howto
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/infrastructure/howto/setup-postgresql-replication.md"
---



> **This page was imported from [the opsmanual on github.gds](https://github.gds/gds/opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.gds/gds/opsmanual/tree/master/infrastructure/howto/setup-postgresql-replication.md)


# Set up PostgreSQL replication

This how-to guide explains how to set-up PostgreSQL replication.

New servers can be created using the `govuk_postgresql::server::primary`
and `govuk_postgresql::server::standby` classes. This will prepare them,
but replication has to be initiated manually.

## Syncing a standby

To sync (or indeed resync) a standby from a primary run
`pg_resync_slave` as root.

By default, you should **not** be prompted for a password. If you are
prompted, then this password is stored in the [deployment
repo](https://github.gds/gds/deployment) under the
`govuk::node::s_postgresql_primary::standby_password` key and can be
read with:

`bundle exec rake 'eyaml:modify[edit,staging]'`

Where staging is the environment the server is in. This will sync data
from the primary and restart (resulting in some downtime) the service on
the standby with the new data and replication config.

For example (the notice is OK):

    vagrant@postgresql-standby-1:~$ sudo pg_resync_slave
    Password:
    36237/36237 kB (100%), 1/1 tablespace
    NOTICE:  WAL archiving is not enabled; you must ensure that all required WAL segments are copied through other means to complete the backup
    pg_basebackup: base backup completed
     * Stopping PostgreSQL 9.3 database server                                 [ OK ]
     * Starting PostgreSQL 9.3 database server                                 [ OK ]

## References

These tutorials give an overview of what's happening. Please don't
follow them verbatim though, because much of the process has been
automated by Puppet.

-   <http://www.rassoc.com/gregr/weblog/2013/02/16/zero-to-postgresql-streaming-replication-in-10-mins/>
-   <https://wiki.postgresql.org/wiki/Binary_Replication_Tutorial>


