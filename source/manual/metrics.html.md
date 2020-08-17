---
owner_slack: "#govuk-developers"
title: Metrics
section: Monitoring
type: learn
layout: manual_layout
parent: "/manual.html"
---

Metrics are measurements of something. GOV.UK use metrics to monitor
the service in realtime, and store these metrics over time, which can
help to understand changes that are occurring.

Graphite is the service used on GOV.UK to store metrics. Normally,
metrics are sent by applications to another service called statsd,
which will run on the local machine, and then the statsd service will
forward the metrics to Graphite.

Once metrics are stored, the Graphite web interface can then be used
to query the metrics. There is another service, Grafana, which
doesn't store any data, but can access Graphite, and is another way in
which you can view metrics about GOV.UK.

One important difference when comparing Graphite and Grafana for
visualising metrics is that Grafana can present data Elasticsearch and
Graphite, even on the same dashboard, whereas Graphite can only
present data from Graphite.

## Graphite

Graphite ([Carrenza][graphite-carrenza], [AWS][graphite-aws]) stores
metrics in a hierarchy, and the time intervals, retention periods and
aggregation methods it uses are configurable.

Graphite metrics are [stored for 5 years][graphite-storage-schemas],
but smaller intervals are [aggregated in to larger
intervals][graphite-storage-aggregation] over time.

[graphite-carrenza]: https://graphite.publishing.service.gov.uk/
[graphite-aws]: https://graphite.production.govuk.digital/
[graphite-storage-schemas]: https://github.com/alphagov/govuk-puppet/blob/master/modules/govuk/files/node/s_graphite/storage-schemas.conf
[graphite-storage-aggregation]: https://github.com/alphagov/govuk-puppet/blob/master/modules/govuk/files/node/s_graphite/storage-aggregation.conf

### StatsD Gauges in Graphite

A gauge is one of the [types of metrics][statsd-metric-types] that
statsd can handle. In general, a gauge normally refers to a number
that can go up or down.

On GOV.UK, [StatsD is configured][statsd-config] to delete gauges. By
default, when a metric is sent to StatsD, statsd will continually send
it to Graphite. However, for gauges, it will only send it one time.

[statsd-config]: https://github.com/alphagov/govuk-puppet/blob/master/modules/statsd/templates/etc/statsd.conf.erb
[statsd-metric-types]: https://github.com/etsy/statsd/blob/master/docs/metric_types.md

## Grafana

Grafana ([Carrenza][grafana-carrenza], [AWS][grafana-aws]) on GOV.UK
is used for dashboards. Dashboards can be created directly in the web
interface (first you must login using the credentials username: admin
password: admin), or added through govuk-puppet. If a dashboard is
only created through the web interface it will be lost when puppet is
next run on the machine.

Usually you would want to develop dashboards in Grafana by editing
them through the web interface, and then export them and add them to
govuk-puppet once you are happy with it. Adding the dashboard to
govuk-puppet means that it can be easily kept in sync between
environments.

[grafana-carrenza]: https://grafana.publishing.service.gov.uk/
[grafana-aws]: https://grafana.production.govuk.digital/

