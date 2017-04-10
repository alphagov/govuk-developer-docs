---
title: PostgreSQL backups
section: backups
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/infrastructure/backups/postgresql.md"
---



> **This page was imported from [the opsmanual on github.gds](https://github.gds/gds/opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.gds/gds/opsmanual/tree/master/infrastructure/backups/postgresql.md)


# PostgreSQL backups

## autopostgresqlbackup

This is how PostgreSQL backups have traditionally been taken on the GOV.UK Infrastructure.

A third-party script called [autopostgresqlbackup](http://manpages.ubuntu.com/manpages/wily/man8/autopostgresqlbackup.8.html)
takes a `pg_dump` every night and stores them on disk on a dedicated mount point on the PostgreSQL primary machines.

The onsite backup machine (backup-1.management) pulls the latest backup and stores it on disk. [Duplicity](http://duplicity.nongnu.org/)
runs each night to send encrypted backups to an offsite backup machine (the location of this machine is dependent on the environment).

To restore from this method:

 - Fetch a backup from either the dedicated mount point, the onsite machine or the offsite machine (to decrypt you may need a password kept
  in the password store)
   - Unzip the file
   - Import into a PostgreSQL primary using `psql <dbname> < <file>`

## WAL-E Backups to S3

We use [WAL-E](https://github.com/wal-e/wal-e) to do continuous archiving to an Amazon S3 bucket. PostgreSQL uses a method of [archiving](https://www.postgresql.org/docs/9.3/static/continuous-archiving.html)
transaction logs: this means that transaction logs are copied to a place on disk, and are rotated by a set amount of time or disk usage.

WAL-E uses this function and makes it easy to upload the archived logs to a different location, using environmental variables to specify
where the logs should go. It also specifies encryption details.

The archived transactions logs are based upon a "base" backup, which is taken every night. By default we rotate a new transaction log every 5 minutes, so in theory
we can recover point in time backups to specific time and dates in this timeframe.

To restore we can use the commands specified in the documentation: `backup-fetch` and `wal-fetch`. To make this easier, a script has been written to automate the
restore of the very latest backup available(`/usr/local/bin/wal-e_restore`). The environmental variables which define the AWS credentials will need to be present.

