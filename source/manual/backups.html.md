---
owner_slack: "#govuk-developers"
title: Use of backups
parent: "/manual.html"
layout: manual_layout
section: Backups
type: learn
---

This manual provides a shared definition of a backup and documents our current use of backups summarising strategies and tools we use.

> A backup is a process of creating a copy of the data stored in a database and storing it in a safe location to allow data recovery in case of a disaster, system failure or human error.

# AWS RDS Backups

## Point-in-time RDS backups

Point-in-time backups for Amazon Relational Database Service (RDS) allow us to restore databases to a specific point in time in the past. This feature is useful when we want to restore database to a state before an unintended change or data loss occurred.

When point-in-time backups for an RDS instance are enabled, Amazon RDS automatically takes regular backups of the database and stores them in Amazon S3. Each backup contains a snapshot of the database at a specific point in time. RDS uploads transaction logs for DB instances to Amazon S3 every five minutes. We can restore the database to any of these points in time, within the retention period up to the last five minutes of database usage.

The retention period is the amount of time that Amazon RDS stores our backups.

They are configured with [terraform](https://github.com/alphagov/govuk-aws/blob/39f21f8c0397a4ff0d07caf397fcfabffa6ac339/terraform/modules/aws/rds_instance/main.tf#L118-L128) where `backup_retention_period` is set to 7 days, creating one snapshot per day during the specified `backup_window` (see  [aws_db_instance terraform docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance)). The `backup_window`, should generally be set to a time where some increased latency would be acceptable (i.e. overnight, between 1 AM and 3 AM in our case), as [storage I/O may be suspended for a few seconds](https://github.com/shunliz/AWS-certificate/blob/master/rds/rds-back-up-restore-and-snapshots.md#automated-backups) when the backup initialises, though this only seems to apply to single Availability Zone instances. All our RDS databases, except for Transition PostgreSQL, are Multi-AZ.

These snapshots are visible on the "[Automated backups](https://eu-west-1.console.aws.amazon.com/rds/home?region=eu-west-1#automatedbackups:)" page in the AWS console (and are the same snapshots as can be seen under each RDS instance's "Maintenance & backups" tab).
The "Earliest restorable time" and "Latest restorable time" columns show the time range that can be restored to. [Read more about restoring a DB instance to a specified time](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_PIT.html).

When we restore a database to a point in time, Amazon RDS creates a new instance and restores the database to the specified point in time. Amazon RDS first restores the automated backup that is closest to the desired time and then applies the transaction logs to roll the database forward to the specific point in time. The new instance will have a new endpoint and downstream apps will need to be updated to point to it.

### Manual RDS snapshots

It is also possible to take manual snapshots ([example](https://eu-west-1.console.aws.amazon.com/rds/home?region=eu-west-1#snapshots-list:)) at any time to create a backup. Amazon RDS snapshots are point-in-time backups of a relational database. They capture the entire database at a specific point in time, including the data, configuration and transaction logs.

They are different from automated backups, which are taken automatically by RDS. They are stored indefinitely until we delete them. We don't typically create manual snapshots.
[Read more about creating a manual DB snapshot](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_CreateSnapshot.html).

## Full backups via govuk_env_sync

In addition to the automatic point-in-time RDS backups described above, we use pg_dump and mysqldump utilities in the [govuk_env_sync](https://github.com/alphagov/govuk-puppet/blob/main/modules/govuk_env_sync/files/govuk_env_sync.sh) that runs daily. The full backups are stored in an S3 bucket with a mixture of Glacier, Standard-IA and Standard storage classes (depending on age) and retained for 120 days.

It also facilitates Mongo, DocumentDB and Elasticsearch backups described in the later sections of this manual. [Read more about Environment data sync](manual/govuk-env-sync.html).

# S3 buckets backups

Besides the S3 buckets that store aforementioned full database backups, we have S3 buckets that store business critical information, for example:

- [GOV.UK mirrors](/manual/fall-back-to-mirror.html)
  - A replica is also held in [Google Cloud Storage](https://github.com/alphagov/govuk-aws/tree/39f21f8c0397a4ff0d07caf397fcfabffa6ac339/terraform/projects/infra-google-mirror-bucket) with versioning enabled
- GOV.UK assets (attachments)
- Terraform state
- Data.gov.uk organograms

Backups have encryption at rest enabled. [AWS enables S3 encryption at rest by default](https://docs.aws.amazon.com/AmazonS3/latest/userguide/UsingEncryption.html).

## S3 versioning

S3 have a versioning feature, which allows you to keep multiple versions of an object in the same bucket. We have versioning enabled in some buckets, which allows both:

- restoration of an old version while retaining the most recent
- permanent deletion of the most recent version, reverting to the previous version

The feature is enabled by configuring the `versioning` attribute ([example](https://github.com/alphagov/govuk-aws/blob/39f21f8c0397a4ff0d07caf397fcfabffa6ac339/terraform/projects/infra-assets/backup.tf#L11-L13)) in terraform.

S3 versioning is enabled for buckets that store GOV.UK assets, mirrors, data.gov.uk organograms, related links, database backups, ActiveStorage blobs uploaded via Content Publisher, [some non-ruby apps artifact used for deployment](https://github.com/alphagov/govuk-aws/tree/39f21f8c0397a4ff0d07caf397fcfabffa6ac339/terraform/projects/infra-artefact-bucket), Fastly and AWS logs.

## S3 Cross-Region Replication

S3 replication between regions is a feature of Amazon S3 that allows you to automatically replicate S3 objects from one region to another. To enable it we:

1. create a designated replica S3 bucket in the destination region that will receive the replicated objects
2. configure replication rules for the source bucket with `s3_bucket_replication_configuration` attribute in terraform ([example](https://github.com/alphagov/govuk-aws/blob/39f21f8c0397a4ff0d07caf397fcfabffa6ac339/terraform/projects/infra-database-backups-bucket/main.tf#L139-L151) of [deprecated  `replication_configuration`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_replication_configuration)), where we specify the destination bucket and whether the feature is "Enabled".

Region replication is enabled for buckets that store GOV.UK mirrors, assets, database backups, ActiveStorage blobs uploaded via Content Publisher, some non-ruby apps artifact used for deployment and AWS logging (in production).

# DocumentDB backups

Amazon DocumentDB snapshots are point-in-time backups of Amazon DocumentDB cluster that are stored in Amazon S3. These are service-managed Amazon S3 buckets and we don't have access to the backup files. These backups capture the entire cluster at a specific point in time, including the data, configuration and transaction logs (used to enable point-in-time recovery).

Automated backups are taken daily and are retained for [5 days](https://github.com/alphagov/govuk-aws-data/blob/4cc7b75f9ac5f7fd76923c3e82f825913c89670f/data/app-licensify-documentdb/production/common.tfvars#L1). We also have point-in-time recovery enabled, which allows us to restore to database to any point in time within the retention period.

When the point-in-time recovery is initialised, Amazon DocumentDB first restores the automated backup that is closest to the desired time and then applies the transaction logs to roll the database forward to the specific point in time.

We also take full backups via govuk_env_sync using mongodump utility.

It is also possible but not typically done to take manual snapshots of a DocumentDB cluster to create a backup.

# MongoDB backups

> Use of Mongo is a recognised [tech debt](https://trello.com/c/lSpntlfk/81-mongo-26-has-reached-end-of-life) and is likely to soon go away as we are planning to port to PostgreSQL.

We still run two MongoDB clusters:

- router_backend (router)
- mongo (content store, draft content store)

Databases are backed up to S3 using mongodump, a command-line tool that creates a binary dump, in the [govuk_env_sync](https://github.com/alphagov/govuk-puppet/blob/main/modules/govuk_env_sync/files/govuk_env_sync.sh).

# Elasticsearch backups

Elasticsearch provides the Snapshot and Restore API for creating and restoring snapshots of Elasticsearch indices. When we create a snapshot using the API, Elasticsearch creates a copy of the index and its data and stores it in the specified repository. Elasticsearch also stores metadata about the snapshot, including the index mappings, settings and aliases. These snapshots are taken [overnight](https://github.com/alphagov/govuk-aws/blob/39f21f8c0397a4ff0d07caf397fcfabffa6ac339/terraform/projects/app-elasticsearch6/main.tf#L87-L91) and stored in an [S3 bucket](https://github.com/alphagov/govuk-aws/blob/c7297c0730dd4a7319e11f270e197dd52e5d8127/terraform/projects/app-elasticsearch6/register-snapshot-repository.py#L37) to be used in the [environment sync process](https://github.com/alphagov/govuk-puppet/blob/aa75027/modules/govuk_env_sync/files/govuk_env_sync.sh#L328-L336).

GOV.UK search is a consumer of publishing API events. Indices can be recreated to match current publishing state by republishing content.

Automated snapshots are taken hourly, retained for 2 weeks in an AWS repository that we can interact with via the Elasticsearch API.

[Read more about backup and restore of Elasticsearch indices](/manual/elasticsearch-dumps.html#header).

# Graphite Whisper backups

Graphite is a open-source monitoring tool that stores time-series data. Whisper is a data storage format used by Graphite that is optimised for fast, reliable storage of time-series data.

We use the [whisper-backup script in govuk-puppet](https://github.com/alphagov/govuk-puppet/blob/648e9b95014b5fb40e9fb8da2a14c008ebf934aa/modules/govuk/manifests/node/s_graphite.pp#L117) to replicate the files daily to a [dedicated s3 bucket](https://github.com/alphagov/govuk-aws/blob/cb3205d8b11da3edd518924ad5ab2668627c6d48/terraform/projects/infra-graphite-backups-bucket/README.md). The data from production is retained for [7 days](https://github.com/alphagov/govuk-aws/blob/cb3205d8b11da3edd518924ad5ab2668627c6d48/terraform/projects/infra-graphite-backups-bucket/main.tf#L23-L27) and for [3 days](https://github.com/alphagov/govuk-aws-data/blob/7b5a2638c9d432aca5d7e09be3f990256b3a475d/data/infra-graphite-backups-bucket/integration/common.tfvars#L1) for non-production environments.
