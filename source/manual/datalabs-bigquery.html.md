---
owner_slack: "#govuk-data-labs"
title: Use Google BigQuery
section: Data Labs Team Manual
layout: manual_layout
parent: "/manual.html"
---


Google BigQuery is a cloud-based SQL database. This database stores most GOV.UK visitor data. This data is primarily visitor journey data from visitors navigating through GOV.UK. BigQuery only stores visitor data if that visitor has accepted cookies.

## How BigQuery data is populated

Universal Analytics (UA) sends GOV.UK visitor journey data to the `govuk-bigquery-analytics.87773428.ga_sessions_intraday_YYYYMMDD` table 3 times a day, where:

- `govuk-bigquery-analytics` is the project ID
- `87773428` is the dataset name
- `ga_sessions_intraday_YYYYMMDD` is the table name
- `YYYYMMDD` is the current date in year-month-day format

At the end of the day, UA automatically:

- moves the data in this intraday table to a `ga_sessions_YYYYMMDD` table
- deletes this intraday table
- creates a new intraday table for the next day

If there are any issues with this process, you should contact a Google BigQuery administrator. The administrator will raise a request with Merkle, the agency that manages our Google Analytics / BigQuery relationship to fix the issue. Ask in the [GOV.UK Data Labs slack channel](https://gds.slack.com/archives/CHR4UQKU4) who the current admins are.

The schema of these tables is defined by the [UA BigQuery Export schema](https://support.google.com/analytics/answer/3437719?hl=en). However, not all columns are filled in our tables.

See the [GOV.UK Analytics page on Confluence](https://gov-uk.atlassian.net/wiki/spaces/GOVUK/pages/23855552/Analytics+on+GOV.UK#AnalyticsonGOV.UK-customDimensionsCustomdimensions) for definitions of our custom dimensions.

There are many other datasets and tables on Google BigQuery. Each project usually has its own dataset.

See the [code examples on the reference information page](/manual/datalabs-reference-info.html#code-examples) for more information.

## Get access to Google BigQuery

To get access to Google BigQuery, ask the Data Labs team admins to set you up with a service account and access to the Google BigQuery console. Ask in the [GOV.UK Data Labs slack channel](https://gds.slack.com/archives/CHR4UQKU4) who the current admins are.

Once you have a service account, store your account credentials safely. For example, store the credentials in your home directory if you have a Unix machine.

Access the [Google BigQuery console](http://console.cloud.google.com/bigquery?organizationId=262359340232&project=govuk-bigquery-analytics&ws=). You can use the console to:

- view projects, datasets, and tables
- write and manage queries in the editor
- run those queries

See the [Google BigQuery documentation](https://cloud.google.com/bigquery/docs/how-to) for more information on how to use BigQuery.

## Google BigQuery best practice

When using Google BigQuery you should:

- minimise costs
- optimise performance

### Minimise Google BigQuery costs

Google BigQuery charges based on the amount of data queried. You should try to minimise the amount of data you query to minimise costs.

You should not use `SELECT *` in your queries if possible, as you could potentially be querying many unnecessary columns of data. Also, you should make sure you do not [query too many tables when using wildcards](https://cloud.google.com/bigquery/docs/querying-wildcard-tables).

Use the query validator to the bottom right of the editor in the console to check query costs before running that query. For API queries, for example using Python, consider [using a dry run step to validate the query costs before running the code](https://cloud.google.com/bigquery/docs/best-practices-costs#python).

If you are developing queries, consider using an intraday table. It has the same schema as the main `ga_sessions_YYYYMMDD` tables, but has less data stored for most of the day which makes queries cheaper to run.

Be aware that intraday tables may not be representative behaviour. Queries using intraday tables are also likely to break the next day, as UA automatically moves the intraday table.

For more information, see the:

- [introduction to controlling BigQuery costs](https://cloud.google.com/bigquery/docs/controlling-costs)
- GOV.UK Data Labs BigQuery training [lesson 1: Getting started with Google Cloud](https://docs.google.com/document/d/1DY5f6Q-5ZApFq3OefbgGjx_TefT1ffFzoGu2RIUC1PM/edit)
- GOV.UK Data Labs BigQuery training [lesson 2: BigQuery and GOV.UK Analytics](https://docs.google.com/document/d/1hF1U9XUrv5qEX97nthrKkPRuaDbOIQH64JiyZDrT0NQ/edit)

### Optimise Google BigQuery performance

For complex queries, Google BigQuery automatically scales resources without extra charges to us. However, complex queries can take a long time to run, and even fail if Google BigQuery cannot scale enough resources.

To mitigate these issues and to speed up analysis, you should optimise your queries before running them.

See the [introduction to optimising query performance](https://cloud.google.com/bigquery/docs/best-practices-performance-overview) for more information.

### Other best practice

You should consider deleting datasets that you no longer use as we are charged a small fee for data storage. This also helps make sure you do not run queries incorrectly against old data.

Consider creating a dataset for your own personal use. For example, use your personal dataset when conducting peer reviews so you do not overwrite live data. You must set the location to `EU`. You could set a table expiry condition to delete tables after a certain number of days.

See the [BigQuery documentation on creating datasets](https://cloud.google.com/bigquery/docs/datasets) for more information.

### Team-developed tools for Google BigQuery

The GOV.UK Data Labs team has developed some tools to access Google BigQuery. These tools are for users outside of the team with limited SQL experience.

If you are this type of user, you should start with [modular_sql](https://github.com/alphagov/modular_sql), a lightweight pipeline to combine multiple SQL scripts and generate Google BigQuery tables.

You should also use [govuk-network-data](https://github.com/alphagov/govuk-network-data), a data pipeline for extracting and preprocessing BigQuery user journey data. This tool can be useful for A/B testing and creating structured data at the session level.

### Further information

For more information, see the [GOV.UK Data Labs training on how to use BigQuery to analyse user journeys](https://docs.google.com/document/d/1ojeqYDdxo9R-N8ivXu3UfHUVG0NczgNJydylNUbwXec/edit#heading=h.bz8ye39uw6m2).
