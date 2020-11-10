---
owner_slack: "#re-govuk"
title: Environment data sync
section: Monitoring
type: learn
layout: manual_layout
parent: "/manual.html"
---

The [govuk_env_sync][] data sync is used for backup and sync tasks in the [GOV.UK AWS environments](/manual/environments.html). It replaces the now archived [env-sync-and-backup][] data sync.

## What it does

In this context:

* **Push** means *database dump and upload*.
* **Pull** means *download and database restore*.

The govuk_env_sync data sync works by `push`ing a source database to S3 and subsequently `pull`ing it down from there to a destination. There is a different process for the Elasticsearch databases, which [don't push/pull](https://github.com/alphagov/govuk-puppet/blob/cb9351f92456ccf132e776b3b9f7129c0e654697/modules/govuk_env_sync/files/govuk_env_sync.sh#L496-L504) but instead get [copied to another Elasticsearch](https://github.com/alphagov/govuk-puppet/blob/cb9351f92456ccf132e776b3b9f7129c0e654697/modules/govuk_env_sync/files/govuk_env_sync.sh#L321-L337).

The environment synchronisation is achieved by granting cross-account access of the `govuk-<environment>-database-backups` S3 buckets. Figure 1 below illustrates the intended data flow between environments.

![Schematic of the data flow of the govuk_env_sync data synchronisation](images/govuk_env_sync.png)
Figure 1:  Schematic of the data flow of the govuk_env_sync data synchronisation.

In practice, some Integration databases pull from Production (with data sanitisation - see below) rather than from Staging. This is done to reduce the number of cron job timing dependencies and to save resources where large databases do not need to be backed up from Staging.

### Data sanitisation

Data sanitisation (removal of sensitive data) for the Integration environment is done by SQL scripts which run as part of the restore transaction at the destination. While not ideal, this is the same approach as [env-sync-and-backup] used to use and allows reuse of the same sanitisation scripts.

Data sanitisation scripts are in the [`files/transformation_sql`][transformation-sql] directory. These are created under `/etc/govuk_env_sync/transformation_sql/` on the target machine.

## How it works

The code is in the govuk_env_sync module in the govuk-puppet repository. Most of the logic is in the [govuk_env_sync.sh][] file, provided as a Puppet file resource in the `files` directory. It is created as `/usr/local/bin/govuk_env_sync.sh`. Rollout of changes to this code happens as part of the the `Deploy_puppet` Jenkins job in each environment.

A [`govuk_env_sync::task` resource type](https://github.com/alphagov/govuk-puppet/blob/ba370cf5970eb9023c0de5153f6acbb31aceca6b/modules/govuk_env_sync/manifests/task.pp) creates a configuration file and a cron job, parameterising the govuk_env_sync.sh file with the values passed to `govuk_env_sync::task`. A [`create_resources(govuk_env_sync::task)` invocation](https://github.com/alphagov/govuk-puppet/blob/8195aa1483bc3030204e840b0b4f8a3cecab4d93/modules/govuk_env_sync/manifests/init.pp#L27) calls the `govuk_env_sync::task` for each `govuk_env_sync::tasks:` property in the hieradata. Most (but not all) of these are in `db_admin.yaml` under `hieradata_aws/class/{integration,staging,production}` (here's an [example of one](https://github.com/alphagov/govuk-puppet/blob/25aba8fcf206a0685c3628e1f30b423110fbe84f/hieradata_aws/class/staging/db_admin.yaml)). All can be found via `git grep govuk_env_sync::tasks` within the govuk-puppet repo.

There are separate backup and restore tasks for each database in each environment, all with different start times, so it is difficult to pinpoint exactly when the govuk_env_sync starts and ends. However, the data sync period is generally expected to run from around [10pm until 8am](https://github.com/alphagov/govuk-puppet/blob/cb9351f92456ccf132e776b3b9f7129c0e654697/modules/govuk/lib/puppet/parser/functions/data_sync_times.rb#L6-L9). For this reason:

> **Traffic replay using [GoReplay](alerts/goreplay.html) is disabled between 22:00 and
> 08:00 UTC daily whilst the data sync pull jobs take place. This is to prevent
> lots of errors while we are dropping databases.**

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

## Pausing a data sync

If you need to temporarily pause one of the data syncs, it can be done manually:

1. On the `db_admin` machine for the environment you want to disable the sync
   in, Puppet will need to be disabled so the paused jobs aren't
   automatically restarted:

   ```sh
   $ govuk_puppet --disable "paused for data sync"
   ```

1. You can then list the cron jobs to find the right `pull` job for the app(s),
   then edit the crontab and remove the corresponding line(s):

   ```sh
   # list
   $ sudo crontab -lu govuk-backup
   # edit
   $ sudo crontab -u govuk-backup -e
   ```

1. This will need to be done separately in each environment where the jobs need
   to be paused.

### Resuming a data sync

To resume the jobs again you can re-enable Puppet and run it manually:

```sh
$ govuk_puppet --enable
$ govuk_puppet --test
```

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

### Cron jobs and Icinga checks

If you get an Icinga alert about a failing task, check `/var/log/syslog` and `/var/log/syslog.1` on the machine which runs the job. If the logs don't help, you can try re-running the sync job.

The data sync operations are executed as cron-jobs attached to the `govuk-backup` user. Run the following commands to get an overview of the jobs being run on a machine.

```bash
$ sudo crontab -lu govuk-backup

# Puppet Name: pull_content_data_admin_production_daily
18 0 * * * /usr/bin/ionice -c 2 -n 6 /usr/local/bin/with_reboot_lock /usr/bin/envdir /etc/govuk_env_sync/env.d /usr/local/bin/govuk_env_sync.sh -f /etc/govuk_env_sync/pull_content_data_admin_production_daily.cfg
...

```

The cron job command does the following:

1. Runs the data sync job at low I/O priority:
   `/usr/bin/ionice -c 2 -n 6`. This only really matters when running on a database server, as opposed to a `db_admin` bastion host, but the command is the same in both cases.
2. Prevents reboot by `unattended-upgrades` while the sync job is running:
   `/usr/local/bin/with_reboot_lock`
3. Runs the data sync job with the appropriate configuration file:
   `/usr/local/bin/govuk_env_sync.sh -f /etc/govuk_env_sync/pull_content_data_admin_production_daily.cfg`

To re-run a given sync job, copy the part of the cron-job corresponding to (3) and examine the output for any errors.

```bash
sudo -u govuk-backup /usr/local/bin/govuk_env_sync.sh -f /etc/govuk_env_sync/pull_content_data_admin_production_daily.cfg
```

[env-sync-and-backup]: https://github.com/alphagov/env-sync-and-backup
[govuk_env_sync]: https://github.com/alphagov/govuk-puppet/tree/master/modules/govuk_env_sync
[govuk_env_sync.sh]: https://github.com/alphagov/govuk-puppet/blob/master/modules/govuk_env_sync/files/govuk_env_sync.sh
[transformation-sql]: https://github.com/alphagov/govuk-puppet/tree/master/modules/govuk_env_sync/files/transformation_sql
