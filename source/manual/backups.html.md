---
owner_slack: "#govuk-platform-engineering"
title: Data backups in GOV.UK
parent: "/manual.html"
layout: manual_layout
section: Backups
type: learn
---

This document describes the backup policies and strategies for GOV.UK's production databases and other persistent storage systems.

> For restore playbooks, see:
>
> - [Restore a database in Amazon RDS](howto-backup-and-restore-in-aws-rds.html)
> - [Restore Elasticsearch indices from snapshots](elasticsearch-dumps.html)

## Databases in Amazon RDS and DocumentDB

Our production [RDS](https://eu-west-1.console.aws.amazon.com/rds/home?region=eu-west-1#databases:) and [DocumentDB](https://eu-west-1.console.aws.amazon.com/docdb/home?region=eu-west-1#clusters) clusters have two backup systems, which together are able to meet our needs:

- [**RDS Backup**](https://eu-west-1.console.aws.amazon.com/rds/home?region=eu-west-1#automatedbackups:) provides point-in-time recovery (PITR), also known as continuous data protection (CDP)
- [**db-backup cronjobs**](https://argo.eks.production.govuk.digital/applications/db-backup) write nightly database dumps to [S3](https://s3.console.aws.amazon.com/s3/buckets/govuk-production-database-backups?region=eu-west-1) in portable formats to ensure that we are not locked into AWS

### RDS Backup

| Strategy | Retention | Recovery point objective (RPO) | Recovery time objective (RTO) |
| --- | --- | --- | --- |
| Nightly full + continuous | 7 days | 5 minutes | 4 hours (best effort) |

#### Capabilities of RDS Backup

- **PITR/CDP** lets us restore to any arbitrary point in time between the retention period and the RPO
- covers data written as recently as 5 minutes in the past
- stores backups in N+1 regions

#### Limitations of RDS Backup

RDS Backup produces backups that are:

- **opaque**, in that we cannot directly read the backups
- **not portable**, meaning we cannot transfer or restore the backups outside AWS

### Nightly db-backup cronjobs

| Strategy | Retention | Recovery point objective (RPO) | Recovery time objective (RTO) |
| --- | --- | --- | --- |
| Nightly full | 120 days | 24 hours | 1 working day (best effort) |

#### Capabilities of the db-backup cronjobs

- **automatic restore testing**, which assures us that:
    - we can actually restore from our backups
    - the applications still work properly after a restore
- **timelocked backups**, so that nobody can delete or tamper with an unexpired backup regardless of their access privileges
- **portable backups** in standard formats, which means we can restore them outside AWS
- long retention at very low cost
- covers `router-mongo`, our one remaining database hosted outside RDS
- stored in N+1 regions

#### Limitations of the db-backup cronjobs

- only run once daily, overnight

## Data in S3 buckets

In some cases, GOV.UK stores original data directly in S3:

- `govuk-assets-production`: inline images in articles and attachments such as PDF documents, managed via Asset Manager
- `datagovuk-production-ckan-organogram`: organisation charts on data.gov.uk

These buckets have:

- a replica in a different AWS region
- versioning, so that we can restore previous or deleted object versions
- 120-day timelock on the replica (in governance mode, so that we can still delete an object if, for example, a department publishes private information by mistake)

## Elasticsearch indices in Amazon OpenSearch

| Strategy | Retention | Recovery point objective (RPO) | Recovery time objective (RTO) |
| --- | --- | --- | --- |
| Incremental snapshots | 14 days | 1 hour | 1 working day (best effort) |

GOV.UK does not store any original data in Elasticsearch, but regenerating the full index takes a long time.

The Search feature on GOV.UK no longer uses Elasticsearch, but some other features of the website still rely on Elasticsearch indices for legacy reasons.

Amazon OpenSearch Service [takes hourly snapshots](https://docs.aws.amazon.com/opensearch-service/latest/developerguide/managedomains-snapshots.html#managedomains-snapshot-restore) of Elasticsearch indices as standard. We can [restore Elasticsearch indices from snapshots](elasticsearch-dumps.html) relatively quickly compared to a full reindex.
