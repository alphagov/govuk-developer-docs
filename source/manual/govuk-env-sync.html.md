---
owner_slack: "#re-govuk"
title: "Datasync with govuk_env_sync"
section: Monitoring
type: learn
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-06-19
review_in: 6 months
---

The govuk_env_sync data sync has been created to replace the env-sync-and-backup data sync in context of the GOV.UK AWS migration work. It is currently in use for backup and sync tasks in the GOV.UK AWS environments.

## Overview

The govuk_env_sync datasync works by `push`ing a database to a data backend and subsequently `pull`ing it down from there. At the moment, we are using exclusively `s3`, but a `rsync` option for use with traditional file systems is available.

"Push" and "pull" perform "database dump and upload" and "download and database restore" respectively.

The environment synchronisation is achieved by granting cross-account access of the `govuk-<environment>-database-backups` buckets. Figure 1 below illustrates the intended data flow between environments.

The included data sanitisation in the staging environment is not currently active as databases requiring data sanitisation (removal of sensitive data) are still residing in the GOV.UK environments in Carrenza, where the [env-sync-and-backup]() is still in use for data synchronisation and sanitisation.

![Schematic of the data flow of the govuk_env_sync data synchronisaton](images/govuk_env_sync.png)
Figure 1:  Schematic of the data flow of the govuk_env_sync data synchronisaton.

## Code base and deployment

The data sync code is maintained in the [govuk-puppet repository as the govuk_env_sync module](
https://github.com/alphagov/govuk-puppet/tree/master/modules/govuk_env_sync).
It is deployed as part of the Deploy_puppet Jenkins job in the respective environments.

## Configuration

The configuration of `govuk_env_sync` is done via hieradata entries for `govuk_env_sync::tasks`

```
govuk_env_sync::tasks:
  "push_ckan_production_daily":
    ensure: "present"
    hour: "23"
    minute: "30"
    action: "push"
    dbms: "postgresql"
    storagebackend: "s3"
    database: "ckan_production"
    temppath: "/tmp/ckan_production"
    url: "govuk-production-database-backups"
    path: "postgresql-backend"
```
The parameters used therein are described below, please do also check the in-code documentation and update them as well as this doc as appropriate

key             |description|
----------------|--------------------------------------------------------------|
title:          | Free text used in monitoring alerts.|
ensure:         | One of 'present', 'disabled' or 'absent' to control the task.|
hour:           | Hour of (daily) cron-job execution.|
minute:         | Minute of (daily) cron-job execution|
action:         | One of 'push' (dump db and upload to store) or 'pull' (download from store and restore db).|
dbms:           | One of 'postgresql', 'mysql', 'mongo', 'elasticsearch5'.|
storagebackend: | One of 's3','rsync','es_snapshot'.|
database:       | Database name.|
temppath:       | Temporary storage path on the local machine.|
url             |Bucket name or file server URL.|
path:           |Object-prefix (in S3) or directory path.|

## Resources

### Sync script
The sync scipt is provided as a simple files resource by Puppet ([link](https://github.com/alphagov/govuk-puppet/blob/master/modules/govuk_env_sync/files/govuk_env_sync.sh)). It is created as `/usr/local/bin/govuk_env_sync.sh`
On manual execution, the script takes the arguments:

flag|argument|
----|------------|
-f  |configfile|
-a  |action|
-D  |dbms|
-S  |storagebackend|
-T  |temppath|
-d  |database|
-u  |url|
-p  |path|
-t  |timestamp|

Here the timestamp argument is optional and allow to specify which timestamp (iso-datetime string of the form YYYY-MM-DDTHH:MM) should be restored druing a `pull` operation (default is using the latest available dump).

### Configuration file
A configuration file providing the job parametrisation given in the hieradata `govuk_env_sync::tasks:` block is created in the directory `/etc/govuk_env_sync/`. It consists of simple `source`-able variable assignments of the form:

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
The data sync script locks reboots by `unattended-upgrades` by creating the file `/etc/unattended-reboot/no-reboot/govuk_env_sync`.

### Cron-job
The data sync operations are executed as cron-jobs attached to the `govuk-backup` user. Currently they are limited to daily execution at a given hour and minute. The crontab entries take the form

```
# Puppet Name: pull_content_data_admin_production_daily
18 0 * * * /usr/bin/ionice -c 2 -n 6 /usr/bin/setlock /etc/unattended-reboot/no-reboot/govuk_env_sync /usr/bin/envdir /etc/govuk_env_sync/env.d /usr/local/bin/govuk_env_sync.sh -f /etc/govuk_env_sync/pull_content_data_admin_production_daily.cfg

```

Wherein we are 

1. Executing the data sync job ionice:
`/usr/bin/ionice -c 2 -n 6`
2. Preventing reboot by `unattended-upgrades` during the synchronisation:
`/usr/bin/setlock /etc/unattended-reboot/no-reboot/govuk_env_sync`
3. Execute the data sync job with the configuration file as argument
`/usr/local/bin/govuk_env_sync.sh -f /etc/govuk_env_sync/pull_content_data_admin_production_daily.cfg`

### Icinga checks
For every `govuk_env_sync::task:`, a passive Icinga alert `GOV.UK environment sync <title>` is created. They are updated on exit of the sync script.

If you get an Icinga alert about a failing task, investigate whether there were any new problems as it does occasionally fail. If not, it can be acked for 24 hours and left to run overnight again.
