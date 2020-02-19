---
owner_slack: "#govuk-developers"
title: How logging works on GOV.UK
section: Logging
layout: manual_layout
type: learn
parent: "/manual.html"
last_reviewed_on: 2019-09-28
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

Elasticsearch in AWS uses a managed service.  Logs are exported to
[AWS Cloudwatch][aws-cloudwatch-es] and retained for 3 days.

Logs are also written to a [S3 bucket][s3-es] which is used to import the logs
into Logit.

[aws-cloudwatch-es]: https://eu-west-1.console.aws.amazon.com/cloudwatch/home?region=eu-west-1#logs:prefix=/aws/aes/domains/blue-elasticsearch6-domain
[s3-es]: https://s3.console.aws.amazon.com/s3/buckets/govuk-integration-aws-logging/elasticsearch6/?region=eu-west-1&tab=overview
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

Fastly sends logs to S3 for the www, assets and bouncer
services. These can be [queried through Athena](/manual/query-cdn-logs.html).

## Graphite

Data from statsd goes to Graphite instances which is then displayed using
Grafana.
