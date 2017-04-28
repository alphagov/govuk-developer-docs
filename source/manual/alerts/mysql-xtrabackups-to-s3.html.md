---
owner_slack: "#2ndline"
title: MySQL Xtrabackups to S3
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_at: 2017-01-06
review_in: 6 months
---

# MySQL Xtrabackups to S3

We send backups to an Amazon S3 bucket every 15 minutes. This is
performed using a nightly "base" backup and "incremental" backups which
run every 15 minutes, which are linked to the base backup.

[Further detail on the implementation can be found
here](https://github.gds/pages/gds/opsmanual/infrastructure/backups/mysql.md)

### MySQL Xtrabackup daily base push

If this alert triggers it means the nightly base backup has failed to
run. Check the logs in Kibana using this query:

@source\_host:mysql-backup\* AND @fields.syslog\_program:xtrabackup\_s3\_base

As this runs on a slave, it is safe to rerun at anytime. Log into the
machine and run:

sudo -i /usr/bin/timeout 1h /usr/bin/setlock -N /var/run/mysql\_xtrabackup /usr/local/bin/xtrabackup\_s3\_base

If it errors you should be able to find out what the issue is.

### MySQL Xtrabackup incremental-push

When this alert triggers it means the incremental backups, which run
every 15 minutes, have had a problem. Check Kibana with the following
query:

@source\_host:mysql-backup\* AND @fields.syslog\_program:xtrabackup\_s3\_incremental

It is safe to run manually, though this will by nature run regularly so
you should be able to view what the problem is in the logs. If the
incremental backup is failing, it may be worth rerunning the base backup
job, and then running the incremental job. Other possible problems could
point to connectivity to Amazon S3.

