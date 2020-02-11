---
owner_slack: "#govuk-developers"
title: Uptime Metrics
section: Monitoring
type: learn
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-03-16
review_in: 12 months
related_applications:
  - content-store
  - hmrc-manuals-api
  - link-checker-api
  - manuals-publisher
  - publishing-api
  - specialist-publisher
  - travel-advice-publisher
  - whitehall
---

Uptime metrics are collected for `content-store`, `hmrc-manuals-api`,
`link-checker-api`, `manuals-publisher`, `publishing-api`, `specialist-publisher`,
`travel-advice-publisher` and `whitehall-admin`, they are available as
[a Grafana dashboard][grafana-dashboard].

<p>
  <iframe src="https://grafana.publishing.service.gov.uk/dashboard-solo/file/application_uptime.json?panelId=4" width="720" height="340" frameborder="0"></iframe>
</p>

They are available broken down into a day by day view, highlighted in different
colours representing the level of uptime. Green means 100%, orange means above
99.31% (equivalent to 10 minutes of downtime) and red for everything else.

## Further Reading

The service which collects the uptime data runs on the monitoring machines and
is available to see in [govuk-puppet][uptime-collector-pr]. It works by polling
a given endpoint, such as`/healthcheck`, every 5 seconds and records an application
is up if it receives a 2xx HTTP status code back. It uses statsd to send this data to Graphite under
the names `stats.guages.uptime.<application>` which is the used in the Grafana
dashboard.

If you would like to add another app to the uptime collector, you should first
make sure there is a `/healthcheck` endpoint available and then add your
application to [the end of the line in the service file][uptime-service-file].

>**Note** If there is not an exposed `/healthcheck` endpoint available, an alternative
>can be given by using the format `service_name:alternative/endpoint`.

[grafana-dashboard]: https://grafana.publishing.service.gov.uk/dashboard/file/application_uptime.json
[uptime-collector-pr]: https://github.com/alphagov/govuk-puppet/pull/6353/files#diff-ba6dc00b5f1aecfcf2fed71882089844
[uptime-service-file]: https://github.com/alphagov/govuk-puppet/pull/6353/files#diff-3c14b0dbebef6ce25a9e337b66b257fdR9
