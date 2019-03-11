---
owner_slack: "#govuk-2ndline"
title: Nginx 5xx rate too high for many apps/boxes
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2019-03-07
review_in: 6 months
---

You can view the 5xx logs across all machines on [this dashboard][nginx_5xx_grafana]
(change the hostname to view different apps).

If the message is "UNKNOWN: INTERNAL ERROR: RuntimeError: no valid
datapoints" or "UNKNOWN: INTERNAL ERROR: RuntimeError: no data returned
for target", it probably means that statsd or collectd stopped
submitting data for a period. Statsd metrics (those that begin with
`stats.`) don't get created until the first event of a given type. For
infrequently-used apps which rarely have errors, the `http_5xx` may
never get created. You can force creation by creating a zero-value
`http_500` counter:

    fab $environment -H frontend-1.frontend statsd.create_counter:frontend-1_frontend.nginx_logs.static_publishing_service_gov_uk.http_500

Note that the `http_5xx` counters are created by carbon-aggregator, so
they will automatically be created when a corresponding `http_500`
counter gets created. You should *not* create a statsd counter for
`http_5xx` as this will confuse carbon-aggregator.

For collectd metrics (those without a leading `stats.` prefix), you
probably just need to wait for the metric to get created.

### Spikes

The alert should link to a graphite graph - often certain applications
such as Whitehall can have spikes - if you can determine this is a spike
it is best to acknowledge the alert and let a team that is working on the app
know (or alert Platform Health).

[nginx_5xx_grafana]: https://grafana.publishing.service.gov.uk/dashboard/file/nginx_logs.json?refresh=1m&orgId=1&var-Machines=All&var-Hostname=finder-frontend&var-Status=5xx&from=now-6h&to=now
