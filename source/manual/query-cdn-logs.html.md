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
AWS provides [usage documentation][query-language]. GOV.UK indexes use
[version 1 of the Athena engine][athena-v1], which is based off
[Presto 0.172][presto-0172].

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
[athena-v1]: https://docs.aws.amazon.com/athena/latest/ug/presto-functions.html#presto-functions-env1
[presto-0172]: https://prestodb.io/docs/0.172/index.html

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

### TLS versions over time

```sql
SELECT
    DATE(request_received),
    COUNT(*) AS hits,
                             COUNT_IF(tls_client_protocol = 'TLSv1')       AS TLSv10,
    ROUND(100.0 / COUNT(*) * COUNT_IF(tls_client_protocol = 'TLSv1'), 4)   AS TLSv10_perc,
                             COUNT_IF(tls_client_protocol = 'TLSv1.1')     AS TLSv11,
    ROUND(100.0 / COUNT(*) * COUNT_IF(tls_client_protocol = 'TLSv1.1'), 4) AS TLSv11_perc,
                             COUNT_IF(tls_client_protocol = 'TLSv1.2')     AS TLSv12,
    ROUND(100.0 / COUNT(*) * COUNT_IF(tls_client_protocol = 'TLSv1.2'), 4) AS TLSv12_perc,
                             COUNT_IF(tls_client_protocol = 'TLSv1.3')     AS TLSv13,
    ROUND(100.0 / COUNT(*) * COUNT_IF(tls_client_protocol = 'TLSv1.3'), 4) AS TLSv13_perc,
                             COUNT_IF(tls_client_protocol = '')            AS unknown,
    ROUND(100.0 / COUNT(*) * COUNT_IF(tls_client_protocol = ''), 4)        AS unknown_perc
FROM fastly_logs.govuk_www
WHERE fastly_backend != 'force_ssl'
GROUP BY DATE(request_received)
ORDER BY DATE(request_received) ASC;
```

### Requests from Tor exit nodes

```sql
-- Tor exit node list from https://www.dan.me.uk/torlist/?exit
-- Tor nodes change regularly: the longer back in time you query, the less accurate it will be
SELECT hit_date, hits, tor_hits, 100.0/hits*tor_hits AS tor_perc FROM (
    SELECT
        DATE(request_received) AS hit_date,
        COUNT(*) AS hits,
        SUM(
          CASE WHEN client_ip IN (
            -- list of all exit nodes goes here
            '103.15.28.215',
            ...
            '98.174.90.43'
          ) THEN 1 ELSE 0 END) AS tor_hits
    FROM fastly_logs.govuk_www
    WHERE year = 2021 AND month = X
      AND fastly_backend != 'force_ssl'
    GROUP BY DATE(request_received)
    ORDER BY DATE(request_received) ASC
)
```

### CDN cache response rates

```sql
SELECT
    date_trunc('minute', request_received) AS min,
    COUNT(*) AS hits,
                             COUNT_IF(cache_response = 'HIT')       AS hit_cnt,
    ROUND(100.0 / COUNT(*) * COUNT_IF(cache_response = 'HIT'), 4)   AS hit_pc,
                             COUNT_IF(cache_response = 'MISS')      AS miss_cnt,
    ROUND(100.0 / COUNT(*) * COUNT_IF(cache_response = 'MISS'), 4)  AS miss_pc,
                             COUNT_IF(cache_response = 'ERROR')     AS error_cnt,
    ROUND(100.0 / COUNT(*) * COUNT_IF(cache_response = 'ERROR'), 4) AS error_pc,
                             COUNT_IF(cache_response = 'PASS')      AS pass_cnt,
    ROUND(100.0 / COUNT(*) * COUNT_IF(cache_response = 'PASS'), 4)  AS pass_pc,
                             COUNT_IF(cache_response = 'SYNTH')     AS synth_cnt,
    ROUND(100.0 / COUNT(*) * COUNT_IF(cache_response = 'SYNTH'), 4) AS synth_pc
FROM fastly_logs.govuk_www
WHERE year = 2021 AND month = 1 AND date = X
GROUP BY 1
ORDER BY 1 ASC;
```

### CDN cache hit/miss rates

```sql
SELECT
    date_trunc('second', request_received) AS period,
    COUNT(*) AS total_requests,
                             COUNT_IF(cache_response NOT IN ('PASS', 'MISS'))     AS cache_hits,
    ROUND(100.0 / COUNT(*) * COUNT_IF(cache_response NOT IN ('PASS', 'MISS')), 3) AS cache_hit_pc,
                             COUNT_IF(cache_response IN ('PASS', 'MISS'))         AS cache_misses,
    ROUND(100.0 / COUNT(*) * COUNT_IF(cache_response IN ('PASS', 'MISS')), 3)     AS cache_miss_pc
FROM fastly_logs.govuk_www
WHERE year = 2021 AND month = 1 AND date = X
GROUP BY 1
ORDER BY 2 DESC;
```

### Cache miss request times by paths with greatest summed request time

```sql
SELECT
    CONCAT('/', SPLIT_PART(SPLIT_PART(url, '/', 2), '?', 1)) AS url_start,
    method,
    COUNT(*) AS total_requests,
    ROUND(AVG(request_time), 5) AS average_rq_time,
    CAST(ROUND(SUM(request_time)) AS INTEGER) AS total_rq_time,
    ROUND(MIN(request_time), 3) AS p0,
    ROUND(APPROX_PERCENTILE(request_time, 0.5), 3) AS p50,
    ROUND(APPROX_PERCENTILE(request_time, 0.7), 3) AS p70,
    ROUND(APPROX_PERCENTILE(request_time, 0.8), 3) AS p80,
    ROUND(APPROX_PERCENTILE(request_time, 0.9), 3) AS p90,
    ROUND(APPROX_PERCENTILE(request_time, 0.95), 3) AS p95,
    ROUND(MAX(request_time), 3) AS p100
FROM fastly_logs.govuk_www
WHERE year = 2020 AND month = 11 AND date = 26
  AND url NOT LIKE '/assets/%'
  AND cache_response IN ('PASS', 'MISS')
GROUP BY 1, 2
ORDER BY 5 DESC
LIMIT 1000
```

### CDN hit/miss rates + request times

Includes:

- unique IP / user agent combinations
- cache hit rates
- mean and summed request time
- approximated request time percentiles

```sql
SELECT
    date_trunc('minute', request_received) AS period,
    COUNT(*) AS total_requests,
    -- unique IP / user agent combinations
    COUNT(DISTINCT ROW(client_ip, user_agent)) AS total_ip_uas,
    -- cache hit rates
                             COUNT_IF(cache_response NOT IN ('PASS', 'MISS'))     AS cache_hits,
    ROUND(100.0 / COUNT(*) * COUNT_IF(cache_response NOT IN ('PASS', 'MISS')), 3) AS cache_hit_pc,
                             COUNT_IF(cache_response IN ('PASS', 'MISS'))         AS cache_misses,
    ROUND(100.0 / COUNT(*) * COUNT_IF(cache_response IN ('PASS', 'MISS')), 3)     AS cache_miss_pc,
    -- mean and summed request time
    ROUND(AVG(request_time), 5) AS average_rq_time,
    CAST(ROUND(SUM(request_time)) AS INTEGER) AS total_rq_time,
    -- approximated request time percentiles
    ROUND(MIN(request_time), 3) AS p0,
    ROUND(APPROX_PERCENTILE(request_time, 0.5), 3) AS p50,
    ROUND(APPROX_PERCENTILE(request_time, 0.7), 3) AS p70,
    ROUND(APPROX_PERCENTILE(request_time, 0.8), 3) AS p80,
    ROUND(APPROX_PERCENTILE(request_time, 0.9), 3) AS p90,
    ROUND(APPROX_PERCENTILE(request_time, 0.95), 3) AS p95,
    ROUND(MAX(request_time), 3) AS p100
FROM fastly_logs.govuk_www
WHERE year = 2021 AND month = 2 AND date = X
  AND url LIKE '/find-coronavirus-local-restrictions?postcode=%'
GROUP BY 1
ORDER BY 2 DESC;
```

### HTTP response code rates

```sql
SELECT
    date_trunc('minute', request_received) AS period,
    COUNT(*) AS total_requests,
                             COUNT_IF(status / 100 = 2)     AS s2xx,
    ROUND(100.0 / COUNT(*) * COUNT_IF(status / 100 = 2), 3) AS s2xx_pc,
                             COUNT_IF(status / 100 = 3)     AS s3xx,
    ROUND(100.0 / COUNT(*) * COUNT_IF(status / 100 = 3), 3) AS s3xx_pc,
                             COUNT_IF(status / 100 = 4)     AS s4xx,
    ROUND(100.0 / COUNT(*) * COUNT_IF(status / 100 = 4), 3) AS s4xx_pc,
                             COUNT_IF(status / 100 = 5)     AS s5xx,
    ROUND(100.0 / COUNT(*) * COUNT_IF(status / 100 = 5), 3) AS s5xx_pc,
                             COUNT_IF(cache_response NOT IN ('PASS', 'MISS'))     AS cache_hits,
    ROUND(100.0 / COUNT(*) * COUNT_IF(cache_response NOT IN ('PASS', 'MISS')), 3) AS cache_hit_pc,
                             COUNT_IF(cache_response IN ('PASS', 'MISS'))         AS cache_misses,
    ROUND(100.0 / COUNT(*) * COUNT_IF(cache_response IN ('PASS', 'MISS')), 3)     AS cache_miss_pc
FROM fastly_logs.govuk_www
WHERE year = 2021 AND month = 1 AND date = X
GROUP BY 1
ORDER BY 1 ASC;
```

### Minutes during the week where error rate was >0.1%

This is the "availability" metric shown on the SMT dashboard.

```sql
SELECT
  date_trunc('week', minute) AS week,
  COUNT(*) AS mins_with_bad_error_rate,
  -- Next line assumes we're calculating for a full week (7 days * 24 hours * 60 minutes)
  -- This will need to be updated if the calculation range is changed.
  -- It'll also be off during weeks where the clocks go forwards / back.
  1.0 - (1.0 / (7 * 24 * 60) * COUNT(*)) AS availability
FROM (
  SELECT
    date_trunc('minute', request_received) AS minute,
    COUNT(*) AS total_requests,
    COUNT_IF(status BETWEEN 200 AND 499) AS successful_requests,
    100.0 / COUNT(*) * COUNT_IF(status BETWEEN 200 AND 499) AS availability
  FROM fastly_logs.govuk_www
  WHERE year = 2021 AND month = 1 AND date >= 12 AND date <= 12
    AND user_agent NOT LIKE 'GOV.UK Crawler Worker%'
    AND request_received > TIMESTAMP '2021-01-12 15:00:00'
  GROUP BY date_trunc('minute', request_received)
)
WHERE availability < 99.9
GROUP BY date_trunc('week', minute)
ORDER BY date_trunc('week', minute) ASC;
```

## Snippets

Little snippets of bits of SQL.

### Path without query string

```sql
SPLIT_PART(url, '?', 1) AS url_path
```

### Exclude the GOV.UK Crawler

```sql
user_agent NOT LIKE 'GOV.UK Crawler Worker%'
```

### Remove extra mirror path information

If an origin request fails and the request is failed over to a static mirror,
the path is changed based on the location of the static file within the S3
bucket. E.g. `/some/path` --> `/www.gov.uk/some/path.html`

```sql
REPLACE(REPLACE(SPLIT_PART(url, '?', 1), '/www.gov.uk', ''), '.html', '') AS url_path
```

### Count cases of a thing

If you want straight counts, use
[`COUNT_IF`](https://docs.data.world/documentation/sql/reference/aggregations/count_if.html).
E.g.:

```sql
COUNT_IF(status BETWEEN 200 AND 499)
```

If you want to sum other values, rather than using a straight count, you can use a `CASE` inside a `SUM`:

```sql
SUM(CASE WHEN ... THEN true_value ELSE false_value END)
```

E.g.

```sql
SUM(CASE WHEN status BETWEEN 200 AND 499 THEN request_time ELSE 0 END)
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
