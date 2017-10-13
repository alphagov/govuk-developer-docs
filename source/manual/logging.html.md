---
owner_slack: "#2ndline"
title: How logging works on GOV.UK
section: Logging
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/infrastructure/logging/index.md"
last_reviewed_on: 2017-10-02
review_in: 6 months
---

## Logit

GOV.UK is following [The GDS Way guidance on logging](https://gds-way.cloudapps.digital/standards/logging.html#content)
by using the approved vendor [Logit](https://logit.io).

For information on how to log in and view stacks, please see the [GOV.UK Logit documentation](/manual/logit.html).

## Filebeat

Each machine runs [Elastic Filebeat](https://www.elastic.co/products/beats/filebeat), and
indepedently ships logs to the Logit provided logstash endpoint.

Filebeat tails logs and can output to a variety of sources. It is fully incorporated into the
Elastic ecosystem.

We use [the `filebeat::prospector` defined type](https://github.com/alphagov/govuk-puppet/blob/4cca939ec49a9b4c106b14b7cf896db31a003636/modules/filebeat/manifests/prospector.pp) to create the filebeat configuration on each instance.

## Logstream and Logship

We have a defined type in our Puppet code which uses
[logship](https://github.com/alphagov/tagalog/blob/master/tagalog/command/logship.py)
to tail logfiles.

We only use Logstream to send nginx metrics, via statsd, to Graphite.

In the future this will be replaced.

## Kibana

Kibana is the interface for viewing logs in Elasticsearch. Use the Logit interface
to login to Kibana.

There's some documentation on [useful Kibana queries for 2nd line](/manual/kibana.html).
