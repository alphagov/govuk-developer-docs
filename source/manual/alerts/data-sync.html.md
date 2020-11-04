---
owner_slack: "#govuk-2ndline"
title: Data sync
section: Icinga alerts
layout: manual_layout
parent: "/manual.html"
---

## govuk_env_sync (the new way)

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

For more information, check the general manual for [govuk_env_sync](/manual/govuk-env-sync.html).

## env-sync-and-backup (the old way)

> **Note on AWS**
>
> For databases migrated to AWS RDS, the env-sync-and-backup was replaced by the [govuk_env_sync](/manual/govuk-env-sync.html).
> The env-sync-and-backup data synchronisation is still in use for synchronisation of non-migrated
> databases into the integration environment.

Data and assets/attachments are synced from production to staging and integration every night.

Check the output of the production Jenkins job to see which part of the sync failed. It may be safe to re-run part of the sync. You can specify which part of the job to run by selecting a `JOBLIST` argument when running the Jenkins job.

> **WARNING**
>
> The mysql backup will cause signon in staging to point to production until the
> `Data Sync Complete` job runs and renames the hostnames copied from production
> to back to their staging equivalents.  This means that any deploys to staging
> that rely on GDS API Adapters are likely to fail due to authentication
> failures, as well as Smokey tests that attempt to use Signon.
>
>  Running the [data_sync_complete](https://deploy.staging.publishing.service.gov.uk/job/Data_Sync_Complete/) job may fix this.

The Jenkins jobs included in the sync are:

* [Copy Data to Staging](https://deploy.publishing.service.gov.uk/job/Copy_Data_to_Staging/)
* [Copy Attachments to Staging](https://deploy.publishing.service.gov.uk/job/Copy_Attachments_to_Staging/)
* [Copy Data to Integration](https://deploy.publishing.service.gov.uk/job/Copy_Data_to_Integration/)
* [Copy Attachments to Integration](https://deploy.publishing.service.gov.uk/job/Copy_Attachments_to_Integration/)

See the [source code](https://github.com/alphagov/env-sync-and-backup/tree/master/jobs) of the jobs for more information about how they work.
