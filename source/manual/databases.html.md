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

We use "DB admin" machines to perform operations on the hosted databases. DB Admin machines are responsible for running the nightly [environment data sync](/manual/govuk-env-sync.html), so that production data gets copied to Staging and Integration. In PostgreSQL's case, the DB Admin machine is also responsible for [creating the database and users](https://github.com/alphagov/govuk-puppet/blob/d55621eb71c734dd27583e088cd1ffd633bdc721/modules/govuk/manifests/node/s_content_publisher_db_admin.pp#L43-L44) in the RDS instance (this needs to be [done by hand in MySQL](/repos/govuk-puppet/create-mysql-db-and-users.html)).

Each Postgres/MySQL app has its own DB admin node named after the app, e.g. `content_publisher_db_admin`. The node is [defined in govuk-puppet](https://github.com/alphagov/govuk-puppet/blob/d55621eb71c734dd27583e088cd1ffd633bdc721/modules/govuk/manifests/node/s_content_publisher_db_admin.pp#L24), with root database credentials defined in govuk-secrets (`puppet_aws/hieradata/blue/{ENV}_credentials.yaml`). Note that the application uses different credentials to connect to the database (username [defined in the app](https://github.com/alphagov/content-publisher/blob/f81952ba9f999b06d81e6d79fed9ea1d9372e145/config/database.yml#L19), password defined in govuk-secrets in `puppet_aws/hieradata/apps/{ENV}_credentials.yaml`).

For Mongo databases, there is the [`db_admin` node](https://github.com/alphagov/govuk-puppet/blob/3047076651d6a7790bacf2c40277220e97ac53f9/modules/govuk/manifests/node/s_db_admin.pp#L5), which used to manage the relational databases too.

There is no DB admin machine for ElasticSearch (there is a `search_admin_db_admin` machine, but this is the DB admin machine for the Search Admin application, which uses MySQL). Instead, the `search` node itself is [responsible for its own environment syncing](https://github.com/alphagov/govuk-puppet/blob/df7d619ea8ab96e1a6086a384e7d5fdada68a7fe/modules/govuk/manifests/node/s_search.pp#L18). Every DB admin machine (and `search` node) uses the same [environment sync script](https://github.com/alphagov/govuk-puppet/blob/main/modules/govuk_env_sync/files/govuk_env_sync.sh).
