---
owner_slack: "#re-govuk"
title: MySQL Xtrabackups to S3
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

We send backups to an Amazon S3 bucket every 15 minutes. This is
performed using a nightly "base" backup and "incremental" backups which
run every 15 minutes, which are linked to the base backup.

[Further detail on the implementation can be found here.](/manual/mysql.html)

### MySQL Xtrabackup daily base push

If this alert triggers it means the nightly base backup has failed to
run. Check the logs in Kibana using this query:

```rb
host:mysql-backup* AND syslog_program:xtrabackup_s3_base
```

As this runs on a slave, it is safe to rerun at anytime. Log into the
machine and run:

```sh
sudo -i /usr/bin/timeout 1h /usr/bin/setlock -N /var/run/mysql_xtrabackup /usr/local/bin/xtrabackup_s3_base
```

If it errors you should be able to find out what the issue is.

### MySQL Xtrabackup incremental-push

When this alert triggers it means the incremental backups, which run
every 15 minutes, have had a problem. Check Kibana with the following
query:

```rb
host:mysql-backup* AND syslog_program:xtrabackup_s3_incremental
```

It is safe to run manually, though this will by nature run regularly so
you should be able to view what the problem is in the logs. If the
incremental backup is failing, it may be worth rerunning the base backup
job, and then running the incremental job. Other possible problems could
point to connectivity to Amazon S3.
