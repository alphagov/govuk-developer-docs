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

GOV.UK is following [The GDS Way guidance on logging][] by using the approved vendor [Logit][].

For information on how to log in and view stacks, please see the [GOV.UK Logit documentation][].

[The GDS Way guidance on logging]: https://gds-way.cloudapps.digital/standards/logging.html#content
[Logit]: https://logit.io
[GOV.UK Logit documentation]: /manual/logit.html

> **Note:** although Logit is where we currently store logs, the GDS Way suggests we are migrating towards Splunk and therefore some logs are currently available in Splunk.

## Kibana

Kibana is the interface for viewing logs in Elasticsearch. Use the Logit interface to log into Kibana.

There's some documentation on [useful Kibana queries for 2nd line][].

[useful Kibana queries for 2nd line]: /manual/kibana.html

## Filebeat

Each machine runs [Elastic Filebeat][], and independently ships logs to the Logit-provided logstash endpoint.

Filebeat tails logs every 10 seconds and can output to a variety of sources. It is fully incorporated into the Elastic ecosystem.

We use [the `filebeat::prospector` defined type][filebeat-prospector] to create the filebeat configuration on each instance.

[Elastic Filebeat]: https://www.elastic.co/products/beats/filebeat
[filebeat-prospector]: https://github.com/alphagov/govuk-puppet/blob/4cca939ec49a9b4c106b14b7cf896db31a003636/modules/filebeat/manifests/prospector.pp

## Logstream and Logship

We have a defined type in our Puppet code which uses [logship][] to tail logfiles. We only use Logstream to send nginx metrics, via statsd, to Graphite.

In the future this will be replaced.

[logship]: https://github.com/alphagov/tagalog/blob/master/tagalog/command/logship.py

## Fastly

Fastly sends logs to S3 for the www, assets and bouncer services. These can be [queried through Athena](/manual/query-cdn-logs.html).

Logs are also available in Splunk in the `govuk_cdn` index. Here's an [example query for POST requests](https://gds.splunkcloud.com/en-GB/app/gds-006-govuk/search?q=search%20index%3Dgovuk_cdn%20http_method%3Dpost)

## SSH logs

We ship `/var/log/auth.log` to Splunk [via CloudWatch](https://github.com/alphagov/govuk-puppet/pull/11559) and CDIO Cyber's [centralised security logging service](https://github.com/alphagov/centralised-security-logging-service/blob/master/kinesis_processor%2Faccounts_loggroup_index.toml#L1430-L1440).

There are different indices for each environment:

- [govuk_production](https://gds.splunkcloud.com/en-GB/app/gds-006-govuk/search?q=search%20index%3D%22govuk_production%22)
- [govuk_staging](https://gds.splunkcloud.com/en-GB/app/gds-006-govuk/search?q=search%20index%3D%22govuk_staging%22)
- [govuk_integration](https://gds.splunkcloud.com/en-GB/app/gds-006-govuk/search?q=search%20index%3D%22govuk_integration%22)

You can see the logs if your account has access to GOV.UK's Splunk. If you do not have access to Splunk, you can request access by raising a support ticket with IT and asking them to enable Splunk for your Google account with a note that you work on GOV.UK.
