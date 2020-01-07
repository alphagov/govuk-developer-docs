---
owner_slack: "#re-govuk"
title: "Datasync with govuk_env_sync"
section: Monitoring
type: learn
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2020-01-07
review_in: 6 months
---

The govuk_env_sync data sync has been created to replace the [env-sync-and-backup] data sync in context of the GOV.UK AWS migration work. It is currently in use for backup and sync tasks in the GOV.UK AWS environments.

## Overview

The govuk_env_sync data sync works by `push`ing a source database to S3 (except for Elasticsearch databases, which get copied to another Elasticsearch) and subsequently `pull`ing it down from there to a destination.

* **Push** means *database dump and upload*.
* **Pull** means *download and database restore*.

The environment synchronisation is achieved by granting cross-account access of the `govuk-<environment>-database-backups` S3 buckets. Figure 1 below illustrates the intended data flow between environments.

Data sanitisation (removal of sensitive data) for the Integration environment is done by SQL scripts which run as part of the restore transaction at the destination. While not ideal, this is the same approach as [env-sync-and-backup] and allows reuse of the same sanitisation scripts.


![Schematic of the data flow of the govuk_env_sync data synchronisation](images/govuk_env_sync.png)
Figure 1:  Schematic of the data flow of the govuk_env_sync data synchronisation.

In practice, some Integration databases pull from Production (with sanitisation) rather than from Staging. This is done to reduce the number of cron job timing dependencies and to save resources where large databases do not need to be backed up from Staging.

Unlike [env-sync-and-backup], govuk_env_sync currently has separate cron jobs for backup and restore, and for each database in each environments.

## Code base and deployment

The code is in the [govuk_env_sync module](
https://github.com/alphagov/govuk-puppet/tree/master/modules/govuk_env_sync) in the govuk-puppet repository.

Rollout happens as part of the the `Deploy_puppet` Jenkins job in each environment.

The [govuk_env_sync.sh] script is provided as a Puppet file resource in the `files` directory. It is created as `/usr/local/bin/govuk_env_sync.sh`.

Data sanitisation scripts are in the [`files/transformation_sql`][transformation-sql] directory. These are created under `/etc/govuk_env_sync/transformation_sql/` on the target machine.

## Configuration

The configuration of `govuk_env_sync` is done via hieradata entries for `govuk_env_sync::tasks`. Most (but not all) of these are in `db_admin.yaml` under `hieradata_aws/class/{integration,staging,production}`. All can be found via `git grep govuk_env_sync::tasks` within the govuk-puppet repo.

### Example configuration

```
govuk_env_sync::tasks:
  "pull_publishing_api_production_daily":
    ensure: "present"
    hour: "2"
    minute: "40"
    action: "pull"
    dbms: "postgresql"
    storagebackend: "s3"
    database: "publishing_api_production"
    temppath: "/tmp/publishing_api_production"
    url: "govuk-production-database-backups"
    path: "postgresql-backend"
    transformation_sql_filename: "sanitise_publishing_api_production.sql"
```

### Meanings of parameters

See [govuk_env_sync.sh] for full documentation of the parameters.

key                       | description |
--------------------------|-------------|
`title`                   | Free text used in monitoring alerts. |
`ensure`                  | One of `present`, `disabled` or `absent` to control the task. `disabled` creates the config file but removes the cron job and is used for configuring restores in Production. |
`hour`                    | Hour of (daily) cron-job execution. |
`minute`                  | Minute of (daily) cron-job execution. |
`action`                  | One of `push` (dump db and upload to store) or `pull` (download from store and restore db). |
`dbms`                    | One of `postgresql`, `mysql`, `mongo`, `elasticsearch`. |
`storagebackend`          | Must be `elasticsearch` if `dbms` is `elasticsearch`, otherwise must be `s3`. |
`database`                | Database name, as configured in the DBMS. |
`temppath`                | Temporary storage path on the machine which runs the cronjob. |
`url`                     | S3 bucket name or Elasticsearch snapshot name. |
`path`                    | Object-prefix (in S3) or directory path. |
`transformation_sql_file` | Optional path to a SQL script to run within the transaction when restoring a Postgres database, after the data has been inserted. |

On manual execution, the script takes the arguments:

flag | argument                  |
-----|---------------------------|
-f   | `configfile`              |
-a   | `action`                  |
-D   | `dbms`                    |
-S   | `storagebackend`          |
-T   | `temppath`                |
-d   | `database`                |
-u   | `url`                     |
-p   | `path`                    |
-s   | `transformation_sql_file` |
-t   | `timestamp`               |

Here the timestamp argument is optional and allow to specify which timestamp (iso-datetime string of the form `YYYY-MM-DDTHH:MM`) should be restored during a `pull` operation (default is using the latest available dump).

## Resources managed by Puppet

### Configuration files on machines
Puppet creates a configuration file in `/etc/govuk_env_sync/` for each job in hieradata `govuk_env_sync::tasks:`. These files consist of simple `source`-able variable assignments of the form:

```
action="pull"
dbms="postgresql"
storagebackend="s3"
temppath="/tmp/content_data_admin_production_pull"
database="content_data_admin_production"
url="govuk-production-database-backups"
path="postgresql-backend"
```

### Lock
The govuk_env_sync cron jobs prevent automated reboots by `unattended-upgrades` by running under `/usr/local/bin/with_reboot_lock`, which creates the file `/etc/unattended-reboot/no-reboot/govuk_env_sync` and removes it when the process exits.

### Cron job
The data sync operations are executed as cron-jobs attached to the `govuk-backup` user. Currently they are limited to daily execution at a given hour and minute. The crontab entries take the form

```
# Puppet Name: pull_content_data_admin_production_daily
18 0 * * * /usr/bin/ionice -c 2 -n 6 /usr/local/bin/with_reboot_lock /usr/bin/envdir /etc/govuk_env_sync/env.d /usr/local/bin/govuk_env_sync.sh -f /etc/govuk_env_sync/pull_content_data_admin_production_daily.cfg

```

The cron job command does the following:

1. Runs the data sync job at low I/O priority:
`/usr/bin/ionice -c 2 -n 6`. This only really matters when running on a database server, as opposed to a `db_admin` bastion host, but the command is the same in both cases.
2. Prevents reboot by `unattended-upgrades` while the sync job is running:
`/usr/local/bin/with_reboot_lock`
3. Runs the data sync job with the appropriate configuration file:
`/usr/local/bin/govuk_env_sync.sh -f /etc/govuk_env_sync/pull_content_data_admin_production_daily.cfg`

> **Traffic replay using [Gor](alerts/gor.html) is disabled between 23:00 and
> 05:45 daily whilst the data sync pull jobs take place. This is to prevent
> lots of errors while we are dropping databases.**

### Icinga checks
For every `govuk_env_sync::task:`, a passive Icinga alert `GOV.UK environment sync <title>` is created. They are updated on exit of the sync script.

If you get an Icinga alert about a failing task, check `/var/log/syslog` and `/var/log/syslog.1` on the machine which runs the job (usually `db_admin`). If the problem appears to be a one-off, consider acking the alert and seeing if it fails again the next day before investing time in debugging.


[env-sync-and-backup]: alerts/data-sync.html
[govuk_env_sync.sh]: https://github.com/alphagov/govuk-puppet/blob/master/modules/govuk_env_sync/files/govuk_env_sync.sh
[transformation-sql]: https://github.com/alphagov/govuk-puppet/tree/master/modules/govuk_env_sync/files/transformation_sql
