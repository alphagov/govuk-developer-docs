---
owner_slack: "#re-govuk"
title: MySQL backups
section: Backups
type: learn
layout: manual_layout
parent: "/manual.html"
---

> Deprecation note:
> This page should be removed after all machines in Carrenza have been shutdown
> as we are using a different process for backups in AWS.

## automysqlbackup

### Backing up

We use a third-party script called [automysqlbackup](https://github.com/alphagov/govuk-puppet/blob/master/modules/govuk_mysql/templates/automysqlbackup) to take MySQL backups of GOV.UK infrastructure.

This script takes a nightly `mysqldump` and stores it on a dedicated mount point on the MySQL backup machines (`mysql-backup-1.backend`).

The on-site backup machine (`backup-1.management`) pulls the latest backup and stores it on disk. [Duplicity](http://duplicity.nongnu.org/) runs nightly to send encrypted backups to an Amazon S3 bucket.

### Restoring

To restore from this method:

- Using [duplicity](restore-from-offsite-backups.html), fetch a backup from either the dedicated mount point, the on-site machine, or the S3 bucket. To decrypt this you may need a password kept in encrypted hieradata.
- Unzip the file
- Import into MySQL using `mysql < file` - see these [MySQL docs on using file imports](https://dev.mysql.com/doc/refman/8.0/en/mysql-batch-commands.html).

## xtrabackup to S3

We are required to have frequent data backups so we created a way to stream MySQL backups to S3.

We use a tool called [Innobackupex](https://www.percona.com/doc/percona-xtrabackup/2.2/innobackupex/incremental_backups_innobackupex.html) which is a wrapper for [Xtrabackup](https://www.percona.com/doc/percona-xtrabackup/2.3/index.html).

### Backing up

Innobackupex takes binary "hot" backups and uses the [xbstream](https://www.percona.com/doc/percona-xtrabackup/2.3/xbstream/xbstream.html) tool to stream data to STDOUT. We redirect this output into a file stored in an Amazon S3 bucket using a tool written in Go called [gof3r](https://github.com/rlmcpherson/s3gof3r).

Each night we take a "base" backup, and then every _n_ time after that (default: 15 minutes) we take an "incremental" backup.

### Restoring

To restore the backup we use a [script to retrieve the base backup](https://github.com/alphagov/govuk-puppet/blob/master/modules/govuk_mysql/templates/usr/local/bin/xtrabackup_s3_restore.erb) and then apply any number of incremental backups on top of it.

Under the hood the script completes the following steps:

- Retrieve the latest base backup.
- Fetch the latest incremental backups.
- Copy the consolidated backup (base plus incremental) to the MySQL data directory.

### Why this approach

The streaming method was inspired by this [blog post from MariaDB](https://mariadb.com/blog/streaming-mariadb-backups-cloud). We also drew on the [incremental backups concept provided by the toolset](https://www.percona.com/doc/percona-xtrabackup/2.2/xtrabackup_bin/incremental_backups.html).

The streaming method is advantageous because it's a binary backup and restores are faster than having to import SQL text-based backups.

Note: we use [Xtrabackup's encryption functionality](https://www.percona.com/doc/percona-xtrabackup/2.2/innobackupex/encrypted_backups_innobackupex.html) to encrypt the backups by providing an encryption key. The S3 bucket is also encrypted.

Related documentation:

- [Preparing a full backup with innobackupex](https://www.percona.com/doc/percona-xtrabackup/2.2/innobackupex/preparing_a_backup_ibk.html)
- [Preparing an incremental backup with innobackupex]( https://www.percona.com/doc/percona-xtrabackup/2.2/innobackupex/incremental_backups_innobackupex.html#preparing-an-incremental-backup-with-innobackupex)
