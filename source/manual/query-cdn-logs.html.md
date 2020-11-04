---
owner_slack: "#govuk-developers"
title: Query CDN logs
section: CDN & Caching
layout: manual_layout
parent: "/manual.html"
---

The [CDN](/manual/cdn.html) log files are sent to Amazon S3 every 15 minutes
and are stored for 120 days. The data in these log files can be queried via
[Amazon Athena][] to gain a variety of insights into GOV.UK traffic.

Previously, the log files were sent via syslog and available in real time
in the `/var/log/cdn` directory of the `monitoring` server. Due to low use now
we have Athena, these were [removed](https://github.com/alphagov/govuk-puppet/pull/10126),
but the behaviour can be restored if necessary.

[Amazon Athena]: https://aws.amazon.com/athena/

## Accessing Athena

Amazon Athena provides the means to query the logs through an SQL syntax.

The logs appear in a database named `fastly_logs` and there are 3 logs from
the CDN which are available as tables:

- **bouncer** - legacy government websites that are now redirected to GOV.UK
- **govuk_assets** - assets supporting GOV.UK pages hosted on
  assets.publishing.service.gov.uk, with files such as images, attachments,
  stylesheets and javascripts
- **govuk_www** - content served from www.gov.uk, mainly HTML pages with atom
  feeds and web services

Athena is available through the AWS control panel and is only useful in
the `govuk_infrastructure_production` account (as we barely use the ones for
integration and staging). To access,
[log into AWS](/manual/get-started.html#sign-in-to-aws), navigate to
[Athena](https://eu-west-1.console.aws.amazon.com/athena) and select the
`fastly_logs` database.

## Querying

Queries are written using an SQL dialect, [presto](https://prestodb.io/),
AWS provides [usage documentation][query-language].

A basic query could be:

```sql
SELECT *
FROM fastly_logs.govuk_www
WHERE date = 20 AND month = 8 AND year = 2018
ORDER BY request_received DESC
LIMIT 10
```

Take note of the use of a date to restrict the data, this utilises a
data [partition][] so that the query only traverses a subset of data.

### Always query with a partition

Unless you have a good reason to do otherwise all queries to the CDN logs
should be restricted to just the dates that you care about. Doing this makes
the queries:

- **substantially faster** - far less data needs to be traversed and there is a
  lower chance of a query timeout
- **substantially cheaper** - the cost of using Athena is based on the amount
  of data that is traversed

[partition]: https://docs.aws.amazon.com/athena/latest/ug/partitions.html
[query-language]: https://docs.aws.amazon.com/athena/latest/ug/functions-operators-reference-section.html

## Example Queries

This is a selection of queries put together to show some of the ways to
query the CDN logs. You are encouraged to add to this list if you
write useful queries for particular scenarios.

### How many errors were served to users in a timeframe

```sql
SELECT status, COUNT(*) AS count
FROM fastly_logs.govuk_www
WHERE status >= 500 AND status <= 599
AND request_received >= TIMESTAMP '2018-08-20 08:00'
AND request_received < TIMESTAMP '2018-08-20 12:00'
AND date = 20 AND month = 8 AND year = 2018
GROUP BY status
ORDER BY count DESC
```

```sql
SELECT url, COUNT(*) AS count
FROM fastly_logs.govuk_www
WHERE status = 500
AND date = 20 AND month = 8 AND year = 2018
GROUP BY url
ORDER BY count DESC
```

### Find out the number of requests per status per hour for a GOV.UK URL

```sql
SELECT date_trunc('hour', request_received) as "timestamp",
    COUNT(CASE WHEN status/100=2 THEN 1 ELSE NULL END) as "2xx",
    COUNT(CASE WHEN status/100=3 THEN 1 ELSE NULL END) as "3xx",
    COUNT(CASE WHEN status/100=4 THEN 1 ELSE NULL END) as "4xx",
    COUNT(CASE WHEN status/100=5 THEN 1 ELSE NULL END) as "5xx",
    COUNT(*) AS total
FROM fastly_logs.govuk_www
WHERE url = '/vat-rates'
AND date = 16 AND month = 7 AND year = 2020
GROUP BY date_trunc('hour', request_received)
ORDER BY timestamp;
```

### Which GOV.UK pages changed from 200 to a 410 status codes

```sql
SELECT response_200.url, MAX(response_200.request_received) AS last_200_response, MIN(response_non_200.request_received) AS first_non_200_response
FROM fastly_logs.govuk_www AS response_200
INNER JOIN fastly_logs.govuk_www AS response_non_200
  ON response_200.url = response_non_200.url
  AND response_non_200.method = response_200.method
  AND response_non_200.status = 410
  AND response_non_200.request_received > response_200.request_received
  AND response_non_200.date = response_200.date
  AND response_non_200.month = response_200.month
  AND response_non_200.year = response_200.year
WHERE response_200.status = 200
AND response_200.date = 21
AND response_200.month = 8
AND response_200.year = 2018
GROUP BY response_200.url
LIMIT 100;
```

### Finding out how frequently a GOV.UK URL is accessed

```sql
SELECT date_trunc('hour', request_received) AS hour, COUNT(*) AS count
FROM fastly_logs.govuk_www
WHERE url = '/vat-rates'
AND date = 20 AND month = 8 AND year = 2018
GROUP BY date_trunc('hour', request_received)
ORDER BY date_trunc('hour', request_received) ASC;
```

### Which assets are being serving most frequently

```sql
SELECT url, COUNT(*) AS count
FROM fastly_logs.govuk_assets
WHERE date = 20 AND month = 8 AND year = 2018
GROUP BY url
ORDER BY count DESC
LIMIT 50
```

### What are the largest assets that were served

```sql
SELECT url, bytes, COUNT(*) AS served
FROM fastly_logs.govuk_assets
WHERE date = 20 AND month = 8 AND year = 2018
GROUP BY url, bytes
ORDER BY bytes DESC
LIMIT 50
```

### Which user agents and hosts is bouncer serving to the most

```sql
SELECT user_agent, host, COUNT(*) AS count
FROM fastly_logs.bouncer
WHERE date = 20 AND month = 8 AND year = 2018
GROUP BY user_agent, host
ORDER BY count DESC
LIMIT 50
```

## Adding a new field to the CDN logs

Adding a new field to the CDN logs is a half manual, half automated
process and is [tracked as tech debt](https://trello.com/c/7pAvfM8R/167).

You should do this in the Integration environment first and wait until
you see the logs coming through to Athena from Fastly. Only then
should you change Staging and next Production. This helps us catch
syntax errors and incidents early. Note that the `bouncer` logs are
only available in Production.

Firstly, make the manual changes via Terraform and a PR. This ensures that
you've had two pairs of eyes on both the Athena/AWS Glue config changes and the
eventual JSON you will manually put into the Fastly web UI:

1. Edit the [`infra-fastly-logs` Terraform][infra-fastly-logs-terraform].
1. Find the `aws_glue_catalog_table` resource for the Fastly logs you want to
   add a column to (`govuk_www`, `govuk_assets` or `bouncer`).
1. Copy the VCL for the log from
   [Fastly's list of available logs][fastly-logs-list] and add it to the list
   of commented (`//`) columns. It's important that these are in the same
   format as the preceding commented lines (that is, JSON, with quotes)
   otherwise Athena won't parse the logs correctly. Here's an
   [example for the `govuk_www.cache_response` column][cache-response-vcl].
1. Add your new column name, type and description to the JSON below the
   comments ([example
   for the `govuk_www.cache_response` column][cache-response-json]).
1. Raise a PR, get a review, merge and [deploy](manual/deploying-terraform.html).

The manual steps to make Fastly send the log data:

1. Log in to Fastly using the credentials from
   `fastly/deployment_shared_credentials` in the 2ndline password store.
1. Search for the environment, for example "staging".
1. On the environment page, click "Real Time Stats".
1. Click "Configure" on the page with the graphs.
1. Click the blue "Edit Configuration" button on the far right to reveal a
   dropdown menu.
1. Click "Clone version xxx (active) to edit".
1. Click "Logging" in the left hand menu.
1. Find and click the link for the relevant log, for example "GOV.UK Fastly
   Logs S3 Bucket".
1. Paste the new log format (found [in the list of available Fastly
   logs][fastly-logs-list]) into the "Log Format" text box.
1. Click "Update".
1. Click the purple "ACTIVATE" button in the top right corner to make the new
   configuration live.

Both these sets of steps must be done! Check the S3 bucket and
query Athena to see the added column and confirm that there's data for
it. As the crawler runs on a schedule every four hours, it can take a
while for Athena to recognise that there have been changes to the
configuration. Due to this, it's advisable to manually [run the AWS
Glue Crawler][glue-crawler] for the logs config you have changed once you
know that Fastly is correct.

Once you're happy that the Integration configuration works, you can
deploy Terraform to Staging and make the same manual changes in the
Fastly UI. Then do Production.

[infra-fasty-logs-terraform]: https://github.com/alphagov/govuk-aws/blob/master/terraform/projects/infra-fastly-logs/main.tf
[cache-response-vcl]: https://github.com/alphagov/govuk-aws/blob/6a37004ff23b7da3b90b20b30a2068499b7904ed/terraform/projects/infra-fastly-logs/main.tf#L205
[cache-response-json]: https://github.com/alphagov/govuk-aws/blob/6a37004ff23b7da3b90b20b30a2068499b7904ed/terraform/projects/infra-fastly-logs/main.tf#L284-L288
[glue-crawler]: https://eu-west-1.console.aws.amazon.com/glue/home?region=eu-west-1#catalog:tab=crawlers
[fastly-logs-list]: https://docs.fastly.com/en/guides/useful-variables-to-log

## Troubleshooting

### HIVE_CURSOR_ERROR: Row is not a valid JSON Object

This error indicates that a row in the logs is invalid JSON. It can be very
difficult to determine which file this error came from. It could either be
caused by a change in the formatting of data sent from Fastly - which would
make every record after a timestamp invalid -  or by something expected in
input which isn't properly escaped.

There is a tedious process that can be used to identify where there is a
problem in a particular JSON file. You can sync all the log files from a day
to your local machine and then parse each JSON blob in each of the files with a
JSON tool (such as `JSON.parse` in Ruby) until you find the problem. Once
identified you may need to need to contact Fastly about the
problem or update the log formatting in Fastly to resolve the issue.
