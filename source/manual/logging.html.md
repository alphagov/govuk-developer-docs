---
owner_slack: "#govuk-2ndline"
title: How logging works on GOV.UK
section: Logging
layout: manual_layout
type: learn
parent: "/manual.html"
last_reviewed_on: 2018-08-22
review_in: 6 months
---

![](/manual/images/logging.png)
<em>[Source diagram][src].</em>

[src]: https://drive.google.com/file/d/0B7zRJZy-BNyUMVBENnVNYW9TTEk/view?usp=sharing

## Logit

GOV.UK is following [The GDS Way guidance on logging][gds-way-logging] by using
the approved vendor [Logit][logit].

For information on how to log in and view stacks, please see the
[GOV.UK Logit documentation][logit-docs].

### Elasticsearch

#### Non-managed Elasticsearch

You can access the credentials for the Elasticsearch instances in Logit using
the `logit` key in the [govuk-secrets] 2nd Line password store.

#### AWS Managed Elasticsearch

Elasticsearch in AWS uses a managed service.  Logs are exported to
[AWS Cloudwatch][aws-cloudwatch-es5] and retained for 3 days.

Logs are also written to a [S3 bucket][s3-es5] for longer-term storage.

[aws-cloudwatch-es5]: https://eu-west-1.console.aws.amazon.com/cloudwatch/home?region=eu-west-1#logs:prefix=/aws/aes/domains/blue-elasticsearch5-domain
[s3-es5]: https://s3.console.aws.amazon.com/s3/buckets/govuk-integration-aws-logging/elasticsearch5/?region=eu-west-1&tab=overview
[gds-way-logging]: https://gds-way.cloudapps.digital/standards/logging.html#content
[logit]: https://logit.io
[logit-docs]: /manual/logit.html
[govuk-secrets]: https://github.com/alphagov/govuk-secrets

## Filebeat

Each machine runs [Elastic Filebeat][filebeat], and independently ships logs to
the Logit-provided logstash endpoint.

Filebeat tails logs every 10 seconds and can output to a variety of sources. It
is fully incorporated into the Elastic ecosystem.

We use [the `filebeat::prospector` defined type][filebeat_prospector] to create
the filebeat configuration on each instance.

[filebeat]: https://www.elastic.co/products/beats/filebeat
[filebeat_prospector]: https://github.com/alphagov/govuk-puppet/blob/4cca939ec49a9b4c106b14b7cf896db31a003636/modules/filebeat/manifests/prospector.pp

## Logstream and Logship

We have a defined type in our Puppet code which uses [logship][logship] to tail
logfiles. We only use Logstream to send nginx metrics, via statsd, to Graphite.

In the future this will be replaced.

[logship]: https://github.com/alphagov/tagalog/blob/master/tagalog/command/logship.py

## Kibana

Kibana is the interface for viewing logs in Elasticsearch. Use the Logit
interface to login to Kibana.

There's some documentation on [useful Kibana queries for 2nd line][kibana-docs].

[kibana-docs]: /manual/kibana.html

## Fastly

Fastly sends logs to multiple locations for the www, assets and bouncer
services:

- via syslog to the monitoring-1 boxes in all environments (`/var/log/cdn`),
  available immediately
- to an S3 bucket per environment, available every 10 minutes

## Graphite

Data from statsd goes to Graphite instances which is then displayed using
Grafana.

## Analytics through Athena

> This documentation is adapted from the [Email Alert API analytics documentation][email-athena]
> which also uses Athena

[Athena][athena] is Amazon's service for querying files in S3 using an SQL-like
syntax. The logs bucket is set up to be crawled by AWS Glue every day in order to
discover new partitions and configure the schema correctly.

Athena is accessible through the AWS control panel by following the
[instructions][console-instructions] for accessing the AWS console.
To access the production data you will need to use the
`govuk-infrastructure-production` account, once there you can head to
[athena](https://eu-west-1.console.aws.amazon.com/athena) and select the
`fastly_logs` database.

There are [16 fields to query][athena-fields], plus the year, month and date
as partitions. **It is vastly cheaper and faster to query with
[partitions](#always-query-with-partitions)**.

Querying Athena is done through a SQL dialect provided by
[presto](https://prestodb.io/) - query [documentation][athena-queries] is
available.

### Always query with partitions

You should always query with a where condition which defines the partitions
to be used in your result set e.g. `WHERE year=2018 AND month=7 AND date=4`
unless you are sure you need a wider data range.

The data is stored in directories which separate the data by year, month and
date values. By applying a partition to the query, such as `WHERE year=2018 AND
month=7 AND date=4` you reduce the data needed to be traversed in the query
to just the files from that single day. Which naturally makes the query
perform substantially quicker.

Each query against Athena has a
[monetary cost](https://aws.amazon.com/athena/pricing/) - at time of writing $5
per TB of data scanned - and by using partitions you massively reduce the data
that needs to be scanned.

### Example queries

#### Number of requests per TLS version

```sql
SELECT "tls_client_protocol", count(*)
FROM "fastly_logs"."govuk_www"
WHERE "year" = 2018 AND "month" = 8 AND "date" = 5
GROUP BY "tls_client_protocol";
```

#### Number of errors returned during an incident

```sql
SELECT "status", count(*)
FROM "fastly_logs"."govuk_www"
WHERE "year" = 2018 AND "month" = 8 AND "date" = 5
AND "request_received"
  BETWEEN timestamp '2018-08-05 10:00:00'
  AND timestamp '2018-08-05 11:00:00'
GROUP BY "status";
```

[email-athena]: https://github.com/alphagov/email-alert-api/blob/master/doc/analytics.md
[athena]: https://aws.amazon.com/athena/
[athena-queries]: https://docs.aws.amazon.com/athena/latest/ug/functions-operators-reference-section.html
[console-instructions]: /manual/seeing-things-in-the-aws-console.html
[athena-fields]: https://github.com/alphagov/govuk-aws/blob/f92ab35ce0517db8f0d05ecf5571247c6626b645/terraform/projects/infra-fastly-logs/main.tf#L214-L297
