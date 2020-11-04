---
owner_slack: "#re-govuk"
title: MongoDB backups
layout: manual_layout
parent: "/manual.html"
section: Backups
type: learn
---

There are two ways of taking MongoDB backups.

## automongodbbackup

This is how MongoDB backups have traditionally been taken on the GOV.UK Infrastructure.

A third-party script, [automongodbbackup](https://github.com/micahwedemeyer/automongobackup), takes a nightly `mongodump` and stores it on one of the MongoDB machines' dedicated mount points (likely [the first machine in the replicaset as defined in the Puppet manifest](https://github.com/alphagov/govuk-puppet/blob/master/modules/mongodb/manifests/backup.pp#L40-L44)).

The on-site backup machine (`backup-1.management`) pulls the latest backup and stores it on disk. [Duplicity](http://duplicity.nongnu.org/) runs nightly and sends encrypted backups to an AWS S3 bucket.

### Restoring

- Fetch a backup from either the dedicated mount point, the on-site machine, or the S3 bucket [using Duplicity](restore-from-offsite-backups.html) (you may need a password kept in the encrypted [hieradata](https://github.com/alphagov/govuk-secrets)).
- Unzip the file. This will produce a directory of data.
- Run the command: `mongo restore --drop <directory>`

## mongodumps to S3

We also backup to an AWS S3 bucket.

The timings are defined by parameters [set in the manifest](https://github.com/alphagov/govuk-puppet/blob/master/modules/mongodb/manifests/s3backup/cron.pp), but for important MongoDB clusters these may be taken every 15 minutes. The machines which take the backups are defined in hiera node classes.

These backups are encrypted using GPG, but the functionality is similar to mongodump.

### Restoring

Use the `/usr/local/bin/mongodb-restore-s3` script available on MongoDB machines which have S3 backup enabled.

This script grabs the latest backup from the S3 bucket, decrypts and unpacks it, and does a `mongo restore`.

Machines which have enabled S3 backups and contain the script will have `mongodb::backup::s3_backups` set to `true` in their yaml configuration (see [`govuk-puppet`](https://github.com/alphagov/govuk-puppet)).

### mongodumps via `govuk_env_sync` in AWS

In AWS environments, the mongodump to S3 has been replaced by a very similar mechanism as part of the [govuk-env-sync].

The dump is not GPG encrypted anymore, instead we rely on S3 for encryption at rest.

[govuk-env-sync]: govuk-env-sync.html
