---
owner_slack: "#govuk-developers"
title: How logging works on GOV.UK
section: Logging
layout: manual_layout
type: learn
parent: "/manual.html"
---

![](/manual/images/logging.png)
<em>[Source diagram][src].</em>

[src]: https://drive.google.com/file/d/0B7zRJZy-BNyUMVBENnVNYW9TTEk/view?usp=sharing

## Logit

GOV.UK is following [The GDS Way guidance on logging][gds-way-logging] by using
the approved vendor [Logit][logit].

For information on how to log in and view stacks, please see the
[GOV.UK Logit documentation][logit-docs].

[gds-way-logging]: https://gds-way.cloudapps.digital/standards/logging.html#content
[logit]: https://logit.io
[logit-docs]: /manual/logit.html
[govuk-secrets]: https://github.com/alphagov/govuk-secrets

## Kibana

Kibana is the interface for viewing logs in Elasticsearch. Use the Logit
interface to log into Kibana.

There's some documentation on [useful Kibana queries for 2nd line][kibana-docs].

[kibana-docs]: /manual/kibana.html

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

## Fastly

Fastly sends logs to S3 for the www, assets and bouncer
services. These can be [queried through Athena](/manual/query-cdn-logs.html).
