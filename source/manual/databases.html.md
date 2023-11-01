---
owner_slack: "#govuk-2ndline-tech"
title: Databases on GOV.UK
section: Infrastructure
layout: manual_layout
parent: "/manual.html"
---

Many GOV.UK applications use a database. See our [spreadsheet of applications and database engines](https://docs.google.com/spreadsheets/d/1rBZeeaT9XevaRvstMjw2YsbSsoB7IqgWjpJz5oAO9nM/edit#gid=1368371571) for details.

## Database engines

GOV.UK uses mostly PostgreSQL and some MySQL for apps that require a relational database. There's no particular reason why we use both, and the fact that we do is considered [tech debt](https://trello.com/c/zlfgSJlV/69-govuk-uses-mysql-and-postgresql-and-mongo).

GOV.UK uses MongoDB or DocumentDB for apps that require a document database. Whilst there are some [big differences between the two](https://www.mongodb.com/atlas-vs-amazon-documentdb), they're broadly compatible, and we tend to use the term "Mongo" to apply to both.

Finally, GOV.UK uses an ElasticSearch database for search.

## Hosting

Instead of running these databases locally on the same instance as the application, they're hosted in separate infrastructure (with [one exception](/repos/govuk-aws/guides/rds-database-management.html)).

Each Postgres and MySQL database runs in its own RDS instance. Whilst RDS instances are capable of hosting multiple databases, we decided to grant each database its own instance in [RFC-143](https://github.com/alphagov/govuk-rfcs/blob/main/rfc-143-split-database-instances.md).

Mongo databases are hosted either in DocumentDB clusters (managed by AWS) or MongoDB clusters (managed by us on self-hosted EC2 instances). On production, there is currently one DocumentDB cluster for Licensify and one 'shared' DocumentDB cluster, each with three instances. There is also one Mongo cluster of three EC2s. We have agreed that [we should move apps from MongoDB to DocumentDB](/repos/govuk-aws/architecture/decisions/0038-mongo_replacement_by_documentdb.html).

ElasticSearch is hosted in [AWS's OpenSearch service](https://eu-west-1.console.aws.amazon.com/esv3/home?region=eu-west-1#opensearch/domains). It has [two types of node](https://github.com/alphagov/govuk-aws/blob/6b5f78824bb14f5f6aaa7f7d269915b7831a13c3/terraform/projects/app-elasticsearch6/main.tf#L186-L193) - "master" and "data" (instance).

## DB admin

Until November 2023, we used to use `db_admin` bastion hosts for tasks such as:

- running backups/restores
- copying production data to the staging and integration environments
- managing Postgres user accounts via Puppet

We no longer run these db_admin bastion instances.

The jobs that used to run on db_admin instances now run as Kubernetes cronjobs, configured in the [db-backup](https://github.com/alphagov/govuk-helm-charts/tree/main/charts/db-backup) and [search-index-env-sync](https://github.com/alphagov/govuk-helm-charts/tree/main/charts/search-index-env-sync) charts. You can view job status in the Argo CD web UI (and of course `kubectl` on the command line).

### Open a database commmand-line session

For a Rails app:

```sh
k exec deploy/content-publisher -it -- rails db -p
```

For a non-Rails app:

```sh
k exec deploy/bouncer -it -- sh -c 'psql $DATABASE_URL'
```
