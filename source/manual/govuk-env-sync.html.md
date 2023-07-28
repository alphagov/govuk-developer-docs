---
owner_slack: "#govuk-2ndline-tech"
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

The environment synchronisation is achieved by granting cross-account access of the `govuk-<environment>-database-backups` S3 buckets.

* In production, databases _push_ to the `govuk-production-database-backups` S3 bucket.
* In staging, databases are replaced by _pulling_ data from `govuk-production-database-backups`.
* In integration, databases are generally replaced by _pulling_ data from `govuk-production-database-backups`. However, some databases have a [data sanitisation process](#data-sanitisation), which happens in staging. In those cases, databases are replaced by [_pulling_ from `govuk-staging-database-backups`](https://github.com/alphagov/govuk-puppet/blob/f9c6b136d058b6e0e20fba5d3716b36e60462e2f/hieradata_aws/class/integration/whitehall_db_admin.yaml#L12).
* In integration, databases are _pushed_ to `govuk-integration-database-backups` nightly - these are produced for developers to use [real data on their local machines](/repos/govuk-docker/how-tos.html#how-to-replicate-data-locally).

### Data sanitisation

Data sanitisation (removal of sensitive data) is done by SQL scripts in the [`files/transformation_sql`][transformation-sql] directory, which are created under `/etc/govuk_env_sync/transformation_sql/` on the target machine.

Data sanitisation is applied to the Integration environment for a number of data sources, including Publishing API and Email Alert API, as good security practice. It is not applied to Staging, which can [only be accessed by those who have Production access](/manual/rules-for-getting-production-access.html) and therefore have access to the Production equivalents anyway. Recreating the Production data on Staging allows us to test queries on real world data before we apply them in a Production environment.

## How it works

The code is in the govuk_env_sync module in the govuk-puppet repository. Most of the logic is in the [govuk_env_sync.sh][] file, provided as a Puppet file resource in the `files` directory. It is created as `/usr/local/bin/govuk_env_sync.sh`. Rollout of changes to this code happens as part of the the `Deploy_puppet` Jenkins job in each environment.

A [`govuk_env_sync::task` resource type](https://github.com/alphagov/govuk-puppet/blob/ba370cf5970eb9023c0de5153f6acbb31aceca6b/modules/govuk_env_sync/manifests/task.pp) creates a configuration file and a cron job, parameterising the govuk_env_sync.sh file with the values passed to `govuk_env_sync::task`. A [`create_resources(govuk_env_sync::task)` invocation](https://github.com/alphagov/govuk-puppet/blob/8195aa1483bc3030204e840b0b4f8a3cecab4d93/modules/govuk_env_sync/manifests/init.pp#L27) calls the `govuk_env_sync::task` for each `govuk_env_sync::tasks:` property in the hieradata.

The configuration for these tasks is found in the node hieradata for the db_admin machines, for example: [hieradata_aws/class/integration/db_admin.yaml](https://github.com/alphagov/govuk-puppet/blob/main/hieradata_aws/class/integration/db_admin.yaml). All can be found via `git grep govuk_env_sync::tasks` within the govuk-puppet repo.

There are separate backup and restore tasks for each database in each environment, all with different start times, so it is difficult to pinpoint exactly when the govuk_env_sync starts and ends. However, the data sync period is generally expected to run from around [10pm until 8am](https://github.com/alphagov/govuk-puppet/blob/cb9351f92456ccf132e776b3b9f7129c0e654697/modules/govuk/lib/puppet/parser/functions/data_sync_times.rb#L6-L9). For this reason:

> **Traffic replay using [GoReplay](alerts/goreplay.html) is disabled between 22:00 and
> 08:00 UTC daily whilst the data sync pull jobs take place. This is to prevent
> lots of errors while we are dropping databases.**

## Pausing a data sync

If you need to temporarily pause one of the data syncs, it can be done manually:

1. On the appropriate `db_admin` machine for the environment you want to disable the sync
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
[govuk_env_sync]: https://github.com/alphagov/govuk-puppet/tree/main/modules/govuk_env_sync
[govuk_env_sync.sh]: https://github.com/alphagov/govuk-puppet/blob/main/modules/govuk_env_sync/files/govuk_env_sync.sh
[transformation-sql]: https://github.com/alphagov/govuk-puppet/tree/main/modules/govuk_env_sync/files/transformation_sql
