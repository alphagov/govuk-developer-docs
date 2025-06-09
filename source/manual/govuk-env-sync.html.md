---
owner_slack: "#govuk-platform-engineering"
title: Environment data sync
section: Backups
type: learn
layout: manual_layout
parent: "/manual.html"
---

Production data is regularly copied to the [staging and integration environments](/manual/environments.html) - often referred to as the "env sync" or "data sync" process. This allows us to more easily test changes against real data, as well as acting as an automated test of our disaster recovery capabilities.

Staging is overwritten every night, whereas integration is overwritten [every Monday](https://github.com/alphagov/govuk-helm-charts/commit/5afb13081c60a94d487c2a360c4a4ce3cf789b19) (in order to better support content designers, who use the environment for training, so need longer data retention).

## Troubleshooting

To check whether the env sync has succeeded for a given app and environment, visit the 'db-backup' application in Argo in the relevant environment, and search for the corresponding cronjob (or use the `kubectl` command line). For example, to check Contacts Admin on Integration, you could [visit the db-backup application in Argo Integration](https://argo.eks.integration.govuk.digital/applications/db-backup) and check the logs for the latest `db-backup-whitehall-mysql` job.

## How it works

The env sync process is made up of a lot of small Kubernetes cronjobs - one per app and environment - [configured in the 'db-backup' chart](https://github.com/alphagov/govuk-helm-charts/blob/main/charts/db-backup/values.yaml). There is also a [search-index-env-sync](https://github.com/alphagov/govuk-helm-charts/tree/main/charts/search-index-env-sync) chart for copying search index data.

The 'production' cronjobs back up their respective application's database data to a production S3 bucket called `govuk-production-database-backups` (using a 'backup' operation - see [example](https://github.com/alphagov/govuk-helm-charts/blob/4b922fc7eb79757080570d33b1ae668c4d9dbb4f/charts/db-backup/values.yaml#L107-L111)). The bucket is [configured to automatically replicate](https://github.com/alphagov/govuk-infrastructure/blob/4f451dd56d43042e3fe0477235e9f2126618c957/terraform/deployments/govuk-publishing-infrastructure/db_backup_s3.tf) to S3 buckets [in the other environments](https://github.com/alphagov/govuk-infrastructure/blob/4f451dd56d43042e3fe0477235e9f2126618c957/terraform/deployments/govuk-publishing-infrastructure/db_backup_iam.tf#L1-L8). You can read more about [how GOV.UK data backups are configured in AWS](/manual/backups.html).

The cronjobs in staging and integration pull from the backup S3 bucket in their environment, and replace the database contents of the given app. These are configured as ['restore' and 'backup' operations](https://github.com/alphagov/govuk-helm-charts/blob/4b922fc7eb79757080570d33b1ae668c4d9dbb4f/charts/db-backup/values.yaml#L490-L493) in the chart. Some apps on integration have [additional operations to sanitise their data](https://github.com/alphagov/govuk-helm-charts/blob/4b922fc7eb79757080570d33b1ae668c4d9dbb4f/charts/db-backup/values.yaml#L499-L504): this isn't applied to staging as staging can [only be accessed by those who have production access](/manual/rules-for-getting-production-access.html) (and who therefore have access to the production equivalents already).

## History

The Kubernetes cronjobs replace the old "[govuk_env_sync](https://github.com/alphagov/govuk-puppet/tree/main/modules/govuk_env_sync)" scripts, configured in Puppet and executed on Jenkins. That, in turn, replaced something called "[env-sync-and-backup](https://github.com/alphagov/env-sync-and-backup)".
