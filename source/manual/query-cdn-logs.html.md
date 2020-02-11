---
owner_slack: "#govuk-developers"
title: Query CDN logs
section: CDN & Caching
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-11-05
review_in: 6 months
---

The [CDN](/manual/cdn.html) log files are sent to Amazon S3 every 15 minutes
and are stored for 90 days. The data in these log files can be queried via
[Amazon Athena][] to gain a variety of insights into GOV.UK traffic.

If you need to access the logs within 15 minutes of the request you can
access the log files on the `monitoring-1` server. These are sent via syslog and
are available in the `/var/log/cdn/` directory.

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
[log into AWS](/manual/seeing-things-in-the-aws-console.html), navigate to
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
