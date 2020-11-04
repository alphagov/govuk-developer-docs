---
owner_slack: "#govuk-2ndline"
title: 'Carrenza/6DG PostgreSQL: S3 Backups'
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

There are two passive checks related to PostgreSQL S3 backups:

- PostgreSQL WAL-E base backup push
- PostgreSQL WAL-E archiving to S3

### PostgreSQL WAL-E base backup push

Every morning WAL-E will push a "base backup" to an S3 bucket. This base
backup represents the point in time when, if a restore is required, the
data is taken from. The WAL logs will be restored and replayed from that
time.

This means that if this base backup fails but the WAL archiving
continues successfully, we aren't losing backup data, but it would take
longer to restore and replay the WAL logs from an older checkpoint.

If it fails check Kibana to see if you can see the error using the
following query:

```
syslog_program:wal-e_postgres_base_backup_push
```

There may be a problem with PostgreSQL or it may have trouble connecting
to the S3 bucket.

You can try to re-take the base backup. In theory this is a "hot"
backup, which means it should not impact, but as it's running on the
Primary machine some caution is advised. As detailed above, you could
wait until the next morning for the backup to try again since we are not
losing data due to the archiving process:

```sh
sudo -iu postgres /usr/local/bin/wal-e_postgres_base_backup_push
```

### PostgreSQL WAL-E archiving to S3

[PostgreSQL has a concept of WAL
archiving](http://www.postgresql.org/docs/9.3/static/continuous-archiving.html)
which means it makes a copy of a WAL log to the chosen destination. If
this job fails it means that archiving may not correctly be uploading to
the S3 bucket.

Fortunately if it is unable to correctly archive a log, it will not just
"miss" the log, but will error until that log has been successfully
archived. This means that we won't have missing data, but we won't have
an offsite backup from the point that it errors, which subsequently
means **the WAL archiving is more important to offsite backups than the
base backup itself**.

WAL logs will continue to write on the filesystem of the local server.
Check the status of the archiving with the following Kibana query:

```
message:"*wal-e_postgres_archiving_wrapper*"
```
