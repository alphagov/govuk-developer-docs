---
owner_slack: "#govuk-developers"
title: Uptime Metrics
section: Monitoring
type: learn
layout: manual_layout
parent: "/manual.html"
related_repos:
  - hmrc-manuals-api
  - manuals-publisher
  - specialist-publisher
  - travel-advice-publisher
  - whitehall
---

Uptime metrics are collected for `hmrc-manuals-api`, `manuals-publisher`, `specialist-publisher`, `travel-advice-publisher` and `whitehall-admin`, they are available as [a Grafana dashboard][].

They are available broken down into a day by day view, highlighted in different colours representing the level of uptime. Green means 100%, orange means above 99.31% (equivalent to 10 minutes of downtime) and red for everything else.

> **Note:** these metrics aren't a true reflection of availability. Load balancing means that even if a particular health check fails, and the metrics change as a result, publishing is unlikely to be affected.

These metrics are currently used to report up to the GOV.UK senior management team to get an understanding of the health of the platform.

## Further Reading

The service which collects the uptime data runs on the monitoring machines and is available to see in [govuk-puppet][uptime-collector]. It works by polling a given endpoint, such as`/healthcheck`, every 5 seconds and records an application is up if it receives a 2xx HTTP status code back. It uses statsd to send this data to Graphite under the names `stats.guages.uptime.<application>` which is the used in the Grafana dashboard.

If you would like to add another app to the uptime collector, you should first make sure there is a `/healthcheck` endpoint available and then add your application to [the end of the line in the service file][uptime-service-file].

> **Note:** if there isn't an exposed `/healthcheck` endpoint available, an alternative can be given by using the format `service_name:/alternative/endpoint`.

[a Grafana dashboard]: https://grafana.blue.production.govuk.digital/dashboard/file/application_uptime.json
[uptime-collector]: https://github.com/alphagov/govuk-puppet/blob/main/modules/monitoring/manifests/uptime_collector.pp
[uptime-service-file]: https://github.com/alphagov/govuk-puppet/blob/main/modules/monitoring/templates/govuk-uptime-collector.conf.erb
