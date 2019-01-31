---
owner_slack: "#govuk-2ndline"
title: MySQL backups
section: Backups
type: learn
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-08-03
review_in: 6 months
---

## automysqlbackup

This is how MySQL backups have traditionally been taken on the GOV.UK Infrastructure.

A third-party script called [automysqlbackup](https://github.com/alphagov/govuk-puppet/blob/master/modules/govuk_mysql/templates/automysqlbackup) takes a `mysqldump` every night and stores them on disk
on a dedicated mount point on the MySQL backup machines (mysql-backup-1.backend and whitehall-mysql-backup-1.backend).

The onsite backup machine (backup-1.management) pulls the latest backup and stores it on disk. [Duplicity](http://duplicity.nongnu.org/)
runs each night to send encrypted backups to an Amazon S3 bucket.

To restore from this method:

 - Fetch a backup from either the dedicated mount point, the onsite machine or the S3 bucket [using duplicity](restore-from-offsite-backups.html) (to decrypt you may need a password kept in encrypted hieradata).
 - Unzip the file
 - Import into MySQL using `mysql < <file>`

## xtrabackup to S3

There is a requirement to have data backups which are taken more frequently. Streaming MySQL backups to S3 was created to satisfy this requirement.

To take the backup, we use a tool written by Percona called [Innobackupex](https://www.percona.com/doc/percona-xtrabackup/2.2/innobackupex/incremental_backups_innobackupex.html)
which is a wrapper for [Xtrabackup](https://www.percona.com/doc/percona-xtrabackup/2.3/index.html). This takes binary
"hot" backups and uses the [xbstream](https://www.percona.com/doc/percona-xtrabackup/2.3/xbstream/xbstream.html) tool to stream data to STDOUT. We redirect this output
into a file stored in an Amazon S3 bucket using a tool written in Go called [gof3r](https://github.com/rlmcpherson/s3gof3r). Xtrabackup has an encryption
function that we can use to encrypt the backups by providing an encryption key, and we also ensure we have serverside encryption in the S3 bucket. The way that
the backups are piped straight to S3 means that they never touch the disk so we do not have to worry about stuff like disk usage.

This method was inspired by this [blog post from MariaDB](https://mariadb.com/blog/streaming-mariadb-backups-cloud).

We use the concept of [incremental backups which are built in the toolset](https://www.percona.com/doc/percona-xtrabackup/2.2/xtrabackup_bin/incremental_backups.html).
Each night we take a "base" backup, and then every n time after that (default: 15 minutes) we take an "incremental" backup. To restore the backup we would be able to get
the "base" backup, and then apply any number of "incremental" backups on top of it.

The drawback of this method is that restores are more complicated.

To make this easier, a [script has been written](https://github.com/alphagov/govuk-puppet/blob/master/modules/govuk_mysql/templates/usr/local/bin/xtrabackup_s3_restore.erb) which will automatically get the very latest base backup, prepare it, and then fetch the latest incremental backup, prepare there and then copy them both back to the MySQL
data directory.

An advantage of this method is that because it is a binary type of backup, restores are much quicker than having to import SQL text based backups.

Related documentation:

- [Preparing a full backup with innobackupex](https://www.percona.com/doc/percona-xtrabackup/2.2/innobackupex/preparing_a_backup_ibk.html)
- [Preparing an incremental backup with innobackupex]( https://www.percona.com/doc/percona-xtrabackup/2.2/innobackupex/incremental_backups_innobackupex.html#preparing-an-incremental-backup-with-innobackupex)
