---
owner_slack: "#govuk-data-labs"
title: Use Content Store
section: Data Labs Team Manual
layout: manual_layout
parent: "/manual.html"
---

The [Content Store](https://docs.publishing.service.gov.uk/apps/content-store.html) is a MongoDB database of almost all the content published on GOV.UK.

The Content Store does not have all GOV.UK content. The Content Store has the content itself, but does not include dynamic elements such as top links on taxon pages, navigation elements, or search result pages.

Contact a GOV.UK Data Labs software developer through the [GOV.UK Data Labs slack channel](https://gds.slack.com/archives/CHR4UQKU4) for more information.

Consider using the [GOV.UK mirror](link) if you need a more representative data source of what users actually see on the website.

## Get access to the Content Store

To access the Content Store, you download a copy of the production version of the Content Store and query that local version using Docker.

1. Sign into AWS. See the [GOV.UK Developer Docs on getting AWS access](https://docs.publishing.service.gov.uk/manual/get-started.html#7-get-aws-access) for more information.

1. Go to the [`govuk-integration-database-backups` AWS S3 bucket](https://s3.console.aws.amazon.com/s3/buckets/govuk-integration-database-backups?prefix=mongo-api%2F&region=eu-west-1) and then go to the `mongo-api` folder.

1. Download a copy of the production version of the Content Store. The production version file is `{DATETIME}-content_store_production.gz`, where `{DATETIME}` is a date and time in `YYYY-MM-DDTHH:MM:SS` format.

1. Run the following in the command line to extract the `content_items.bson` file from the `content_store_production` folder of the downloaded production version file:

    ```
    tar -xvf PATH/TO/DATETIME-content_store_production.gz content_store_production/content_items.bson
    ```

1.  Set up a local Docker instance by following the instructions in the [govuk-mongodb-content GitHub repo readme file](https://github.com/alphagov/govuk-mongodb-content).

1. Access your local version of the Content Store through your local Docker instance by [using the Mongo Express graphical interface](https://github.com/alphagov/govuk-mongodb-content#interact-with-mongodb-instance).

Instead of using Docker, you can query the Content Store database using the:

- [Content Store API](https://docs.publishing.service.gov.uk/apps/content-store/content-store-api.html)
- [Python `pymongo` package](https://github.com/alphagov/govuk-intent-detector/blob/define-content-schemas/notebooks/writing_aggregation_queries_for_content_store_with_pymongo.ipynb)

## Content Store best practice

You should use the Mongo query language to transform your data as much as possible before exporting to another programming language.

This makes sure that you use MongoDB’s power to do most of the resource-intensive data processing. Doing this is especially important with a NoSQL database like MongoDB, as MongoDB does not have a stable schema.

Therefore it can be difficult to unnest or replicate Mongo queries in another language, for example using base Python to unnest fields.

MongoDB drivers, such as the [Python driver `pymongo`](https://pymongo.readthedocs.io/), can help you run Mongo queries from an alternative language.

The [GOV.UK Developer Docs “schema” page](https://docs.publishing.service.gov.uk/content-schemas.html) describes possible fields for each document type. However, this is incomplete, and document type schemas are not enforced due to the nature of NoSQL databases. See the [MongoDB NoSQL documentation](https://www.mongodb.com/nosql-explained) for more information.
