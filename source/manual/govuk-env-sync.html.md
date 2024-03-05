---
owner_slack: "#govuk-platform-engineering"
title: Environment data sync
section: Monitoring
type: learn
layout: manual_layout
parent: "/manual.html"
---

GOV.UK currently copies production data to the non-production [environments] for testing purposes. This document describes the data sync and backup jobs, what they do and how to operate them.

There are nightly cronjobs which run:

1. full backups of all the production databases to S3
1. full restores of all the production databases from S3 to the staging environment
1. transformations on some of the staging databases to remove pre-publication content and user identifiers
1. full backups of all the staging databases to S3
1. full restores of most of the staging databases from S3 to the integration environment

## What it does

The data sync works by `push`ing a source database to S3 and subsequently `pull`ing it down from there to a destination. There is a different process for the Elasticsearch databases, which [don't push/pull](https://github.com/alphagov/govuk-puppet/blob/cb9351f92456ccf132e776b3b9f7129c0e654697/modules/govuk_env_sync/files/govuk_env_sync.sh#L496-L504) but instead get [copied to another Elasticsearch](https://github.com/alphagov/govuk-puppet/blob/cb9351f92456ccf132e776b3b9f7129c0e654697/modules/govuk_env_sync/files/govuk_env_sync.sh#L321-L337).

The environment synchronisation is achieved by granting cross-account access of the `govuk-<environment>-database-backups` S3 buckets.

* In production, databases _push_ to the `govuk-production-database-backups` S3 bucket.
* In staging, databases are replaced by _pulling_ data from `govuk-production-database-backups`.
* In integration, databases are generally replaced by _pulling_ data from `govuk-production-database-backups`. However, some databases have a [data sanitisation process](#data-sanitisation), which happens in staging. In those cases, databases are replaced by [_pulling_ from `govuk-staging-database-backups`](https://github.com/alphagov/govuk-puppet/blob/f9c6b136d058b6e0e20fba5d3716b36e60462e2f/hieradata_aws/class/integration/whitehall_db_admin.yaml#L12).
* In integration, databases are _pushed_ to `govuk-integration-database-backups` nightly - these are produced for developers to use [real data on their local machines](/repos/govuk-docker/how-tos.html#how-to-replicate-data-locally).

### Data sanitisation

Data sanitisation (removal of sensitive data) is done by SQL scripts in the [`files/transformation_sql`][transformation-sql] directory, which are created under `/etc/govuk_env_sync/transformation_sql/` on the target machine.

Data sanitisation is applied to the Integration environment for a number of data sources, including Publishing API and Email Alert API, as good security practice. It is not applied to Staging, which can [only be accessed by those who have Production access](/manual/rules-for-getting-production-access.html) and therefore have access to the Production equivalents anyway. Recreating the Production data on Staging allows us to test queries on real world data before we apply them in a Production environment.

## How it works

TODO

## Pausing a data sync

If you need to temporarily pause one of the data syncs, it can be done manually:

TODO

### Resuming a data sync

To resume the jobs again you can re-enable Puppet and run it manually:

```sh
$ govuk_puppet --enable
$ govuk_puppet --test
```

## Re-run a job

To re-run a given sync job, copy the part of the cron-job corresponding to (3) and examine the output for any errors.

```bash
sudo -u govuk-backup /usr/local/bin/govuk_env_sync.sh -f /etc/govuk_env_sync/pull_content_data_admin_production_daily.cfg
```

[environment]: /manual/environments
[govuk_env_sync]: https://github.com/alphagov/govuk-puppet/tree/main/modules/govuk_env_sync
