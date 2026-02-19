---
owner_slack: "#govuk-platform-engineering-team"
title: Environment data sync
section: Backups
type: learn
layout: manual_layout
parent: "/manual.html"
---

Production data is regularly copied to the [staging and integration environments](/manual/environments.html) - often referred to as the "env sync" or "data sync" process. This allows us to more easily test changes against real data, as well as acting as an automated test of our disaster recovery capabilities.

Staging is overwritten every night, whereas integration is overwritten [every Monday](https://github.com/alphagov/govuk-helm-charts/commit/5afb13081c60a94d487c2a360c4a4ce3cf789b19) (in order to better support content designers, who use the environment for training, so need longer data retention).

## Troubleshooting

To check whether the env sync has succeeded for a given app and environment, visit the 'db-backup' application in Argo in the relevant environment, and search for the corresponding cronjob (or use the `kubectl` command line). For example, to check Link Checker API on Integration, you could [visit the db-backup application in Argo Integration](https://argo.eks.integration.govuk.digital/applications/db-backup) and check the logs for the latest `db-backup-link-checker-api-postgres` job. Here's how you might do that:

```
# Find the relevant db-backup jobs
$ kubectl get jobs -n apps | grep db-backup-link-checker-api-postgres

db-backup-link-checker-api-postgres-29219143                  Complete   1/1           62s        33h
db-backup-link-checker-api-postgres-29220583                  Complete   1/1           58s        9h

# Get the status of the job
$ kubectl describe job db-backup-link-checker-api-postgres-29220583 | grep Status
Pods Statuses:            0 Active (0 Ready) / 1 Succeeded / 0 Failed

# Assuming the job has failed, get the pod name for the job...
$ kubectl get pods -n apps -l job-name=db-backup-link-checker-api-postgres-29220583
db-backup-link-checker-api-postgres-29220583-abcde

# ...then get the logs for the container (assuming the container inside the pod is named 0-restore)
$ kubectl logs -n apps db-backup-link-checker-api-postgres-29220583-abcde -c 0-restore
```

## How it works

The env sync process is made up of a lot of small Kubernetes cronjobs - one per app and environment - [configured in the 'db-backup' chart](https://github.com/alphagov/govuk-helm-charts/blob/main/charts/db-backup/values.yaml). There is also a [search-index-env-sync](https://github.com/alphagov/govuk-helm-charts/tree/main/charts/search-index-env-sync) chart for copying search index data.

The 'production' cronjobs back up their respective application's database data to a production S3 bucket called `govuk-production-database-backups` (using a 'backup' operation - see [example](https://github.com/alphagov/govuk-helm-charts/blob/4b922fc7eb79757080570d33b1ae668c4d9dbb4f/charts/db-backup/values.yaml#L107-L111)). The bucket is [configured to automatically replicate](https://github.com/alphagov/govuk-infrastructure/blob/4f451dd56d43042e3fe0477235e9f2126618c957/terraform/deployments/govuk-publishing-infrastructure/db_backup_s3.tf) to S3 buckets [in the other environments](https://github.com/alphagov/govuk-infrastructure/blob/4f451dd56d43042e3fe0477235e9f2126618c957/terraform/deployments/govuk-publishing-infrastructure/db_backup_iam.tf#L1-L8). You can read more about [how GOV.UK data backups are configured in AWS](/manual/backups.html).

The cronjobs in staging and integration pull from the backup S3 bucket in their environment, and replace the database contents of the given app. These are configured as ['restore' and 'backup' operations](https://github.com/alphagov/govuk-helm-charts/blob/4b922fc7eb79757080570d33b1ae668c4d9dbb4f/charts/db-backup/values.yaml#L490-L493) in the chart. Some apps on integration have [additional operations to sanitise their data](https://github.com/alphagov/govuk-helm-charts/blob/4b922fc7eb79757080570d33b1ae668c4d9dbb4f/charts/db-backup/values.yaml#L499-L504): this isn't applied to staging as staging can [only be accessed by those who have production access](/manual/rules-for-getting-production-access.html) (and who therefore have access to the production equivalents already).

## History

The Kubernetes cronjobs replace the old "[govuk_env_sync](https://github.com/alphagov/govuk-puppet/tree/main/modules/govuk_env_sync)" scripts, configured in Puppet and executed on Jenkins. That, in turn, replaced something called "[env-sync-and-backup](https://github.com/alphagov/env-sync-and-backup)".

## Alerts

There are alerts configured to notify us in the #govuk-platform-support channel in Slack if any of the environment syncs fails.

The scripts which perform the backups send metrics to Promtheus (via the Prometheus Pushgateway) for the following events:

* Script execution starts
* Script execution ends including whether the outcome was a success or failure
* The time of transition of a script to a new state (running, failed or succeeded)
* The size of the backup file on S3 (the file written in the case of a backup, or the file read in the case of a restore)
* The duration of an execution of the script

We have alerts for:

* Script has been running for a long time
* Script execution failed
* Backup/Restore operation has not completed recently

We have a Grafana Dashboard called "Database Backups & Syncs" in each environment ([integration](https://grafana.eks.integration.govuk.digital/d/jfc4fnp/database-backups-and-syncs), [staging](https://grafana.eks.staging.govuk.digital/d/jfc4fnp/database-backups-and-syncs), [production](https://grafana.eks.production.govuk.digital/d/jfc4fnp/database-backups-and-syncs)) which shows:

* Most Recent Backup, Transform, Restore State, Duration, and File size - Shows a row for each database within each database instance, the state of the most
  recent execution, how long that execution took, and the size of the file backed up/restored. The Restore, Transform, and Backup state columns will go Red if it was any state other than Succeeded.
* Time since last Restore/Transform/Backup - How long since each database within each database instance was restored, transformed, and backed up. These will go red if it is over 8 days.
* File Sizes Over Time - Graphs for every database instance showing how the file size for each operation has varied over time
* Durations Over Time - Graphs for every database instance showing how the duration of each operation has varied over time
* State Timeline - A state change chart for every database instance showing durations for each state the database enters. Note that because the metrics are pushed to a Prometheus Pushgateway which is scraped every 60 seconds
  any state which lasts for less than 60 seconds may not show, this mostly occurs when a database takes only a few seconds to back up or restore and the running state is missing. Both failed and succeeded states will persist
  since they are both the terminal outcome and will be easily visible.

### Database backup and sync operation failed

This indicates that the execution of a backup, transformation, or restore script exited unsuccessfully.

To diagnose this you should look at the container logs (the alert for this should have included a link to the logs in logit which you can follow).

You will need to diagnose why the failure occurred and decide [whether to launch a new sync operation](#whether-to-launch-a-new-sync-operation)

### Database backup taking a long time - Quicker Database

This alert is for databases which complete their backup within an hour. It will trigger if a backup has been in the running state for over 1 hour.

If the database frequently alerts you should move it into the Slower Databases group by editing the alert rule expressions.

See [Database operation taking a long time](#database-operation-taking-a-long-time)

### Database backup taking a long time - Slower Databases

This alert is for databases which complete their backup within 4 hours. It will trigger if a backup has been in the running state for over 4 hours.

See [Database operation taking a long time](#database-operation-taking-a-long-time)

### Database restore taking a long time - Quicker Databases

This alert is for databases which complete their restore within an hour. It will trigger if a restore has been in the running state for over 1 hour.

If the database frequently alerts you should move it into the Slower Databases group by editing the alert rule expressions.

See [Database operation taking a long time](#database-operation-taking-a-long-time)

### Database restore taking a long time - Slower Databases

This alert is for databases which complete their restore within 4 hours. It will trigger if a restore has been in the running state for over 4 hours.

If the database frequently alerts you should move it into the Slowest Databases group by editing the alert rule expressions.

See [Database operation taking a long time](#database-operation-taking-a-long-time)

### Database restore taking a long time - Slowest Databases

This alert is for databases which complete their restore within 13 hours. It will trigger if a restore has been in the running state for over 13 hours.

See [Database operation taking a long time](#database-operation-taking-a-long-time)

### Database transform taking a long time

This alert will trigger if transforms take longer than 45 minutes in staging, or 30 minutes in integration.

See [Database operation taking a long time](#database-operation-taking-a-long-time)

### Database operation taking a long time

Investigate to see if the job is still running. The alert notification will have included a link to logit which includes the Kubernetes pod name. You can see if that pod is still running.

#### If the pod is still running

If the pod is still running you will need to investigate why the operation (backup, transform, restore) is taking so long. You can look at the "Durations over time" graph in the Grafana dashboard to see if this has been a gradual trend, which might indicate normal growth of the database.
If it appears to be natural growrth you can increase the allowed time by moving the database into a slower category.

You could also speak to the team responsible for the application that uses the database.

#### If the pod is no longer running

It is possible for the pod to be terminated in such a way it cannot send the terminal (failed, succeeded) metric. In these instances you will
need to decide [whether to launch a new sync operation](#whether-to-launch-a-new-sync-operation).

### Database backup/restore not completed

This alert will trigger if a database which is backed up or restored daily did not successfully complete a backup/restore operation within the last 25 hours.

This can be because:

* The backup script has failed - It is likely you will have received an additional alert for [Database backup and sync operation failed](#database-backup-and-sync-operation-failed), in which case investigate it as such.
* The Kubernetes CronJob has been suspended - In this case you should either unsuspend the CronJob, or alert the alert expression to exclude the specific database or database instance.
* The Kuberentes CronJob is failing to successfully launch a Job - In this case you will need to investigate why the Job cannot start successfully. You should be able to see them in ArgoCD in the db-backup Application.
* The backup script is failing to execute before it can send any metric - You should look at the logs in logit (the alert will have included a link to the pods logs in logit), and if there aren't any then look at the job in ArgoCD to see why it is failing to execute.

#### Database backup/restore not completed - Weekly backups

This alert will trigger if a database which is backed up or restored weekly did not successfully complete a backup/restore operation within the last 1 week and 12 hours.

Investigate this by following [Database backup/restore not completed](#database-backuprestore-not-completed).

#### Database backup/restore not completed - Weekday backups

This alert will trigger on Tuesday to Saturday if a database which is backed up or restored on weekdays only did not successfully complete a backup/restore operation within the last 25 hours.

Investigate this by following [Database backup/restore not completed](#database-backuprestore-not-completed).

#### Database backup/restore not completed - Sunday to Thursday backups

This alert will trigger on Monday to Friday if a database which is backed up or restored on Sundays to Thursdays only did not successfully complete a backup/restore operation within the last 25 hours.

Investigate this by following [Database backup/restore not completed](#database-backuprestore-not-completed).

### Whether to launch a new sync operation

First and foremost you should speak to the team which is responsible for the application that uses that database instance. They can decide whether to launch a new sync.

You should consider how long it is likely to take, you can see how long it usually takes by looking at the Durations over time graphs on the Grafana dashboard.

If you launch a new sync:

* in production it will only create a new backup file, this may put extra load on the RDS instance but won't have any other side effects.
* in staging and integration it will restore the most recent backup from the higher environment, this may wipe out changes which the developers are testing
* For MySQL databases in staging and integration it will make their database unavailable for the entire time of the restore (but not any transformation or backup).
