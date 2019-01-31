---
owner_slack: "#govuk-2ndline"
title: MongoDB backups
layout: manual_layout
parent: "/manual.html"
section: Backups
type: learn
last_reviewed_on: 2018-07-27
review_in: 6 months
---

We have 2 ways of taking MongoDB backups.

## automongodbbackup

This is how MongoDB backups have traditionally been taken on the GOV.UK
Infrastructure.

A third-party script called [automongodbbackup](https://github.com/micahwedemeyer/automongobackup) takes a `mongodump` every night and stores them on disk
on a dedicated mount point on one of the MongoDB machines. This is likely [the first in the replicaset as defined in the Puppet manifest](https://github.com/alphagov/govuk-puppet/blob/master/modules/mongodb/manifests/backup.pp#L40-L44).

The onsite backup machine (backup-1.management) pulls the latest backup and stores it on disk. [Duplicity](http://duplicity.nongnu.org/)
runs each night to send encrypted backups to an Amazon S3 bucket.

To restore from this method:

 - Fetch a backup from either the dedicated mount point, the onsite machine or the S3 bucket [using duplicity](restore-from-offsite-backups.html) (to decrypt you may need a password kept in the encrypted hieradata.
 - Unzip the file. This will produce a directory of data.
 - `mongo restore --drop <directory>`

## mongodumps to S3

We also take backups that are sent to an Amazon S3 bucket. The timings are defined by parameters [set in the manifest](https://github.com/alphagov/govuk-puppet/blob/master/modules/mongodb/manifests/s3backup/cron.pp),
but for important MongoDB clusters these may be taken every 15 minutes. The machines which take the backups are defined in hiera node classes.
These backups are encrypted using GPG, but the functionality is just a straightforward mongodump.

To restore the very latest backup, there is a script available to use: `/usr/local/bin/mongodb-restore-s3`. The function essentially grabs the latest backup from the S3 bucket, decrypts and unpacks it, and does a `mongo restore`.
