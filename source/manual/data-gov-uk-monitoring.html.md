---
owner_slack: "#govuk-datagovuk"
title: Monitoring for data.gov.uk
section: data.gov.uk
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-06-22
review_in: 6 months
---
[publish]: apps/datagovuk_publish
[find]: apps/datagovuk_find
[paas-metric-exporter]: https://reliability-engineering.cloudapps.digital/manuals/set-up-paas-metric-exporter-with-prometheus.html#configure-container-metrics
[grafana]: https://grafana-paas.cloudapps.digital/d/xonj40imk/data-gov-uk?refresh=1m&orgId=1
[sentry]: https://sentry.io/govuk/
[logit-paas]: https://docs.cloud.service.gov.uk/#set-up-the-logit-io-log-management-service
[logit]: https://logit.io/a/1c6b2316-16e2-4ca5-a3df-ff18631b0e74
[google-analytics]: https://sites.google.com/a/digital.cabinet-office.gov.uk/gds/information-management/use-online-tools-in-gds/use-google-analytics
[pagerduty]: https://govuk.pagerduty.com/
[ckan]: apps/ckanext-datagovuk

## Prometheus

Container metrics are scraped using the [PaaS Metric Exporter][paas-metric-exporter] and sent to [Grafana]. In a nutshell, the `metric-exporter` app exposes a `/metrics` endpoint listing all of the stats for each container.

## Pingdom

Pingdom monitors `https://data.gov.uk` uptime and alerts [PagerDuty] when downtime is detected. Maintenace of this service forms part of `#govuk-2nd-line`.

## Sentry

[Sentry] receives application errors and emails `data.gov.uk@digital.cabinet-office.gov.uk` with updates. The Sentry pages for each app can be found on the [Find] and [Publish] app pages.

## Log.it

Each application sends logs to [Logit]. [Publish] and [Find] use the corresponding [PaaS Service][logit-paas]. Example query: `source_host: "gds-data-discovery.data-gov-uk.find-data-beta" && access.response_code: 500`.

## Sidekiq ([Publish])

Sidekiq is only accessible to the `localhost` domain, so you'll need an SSH tunnel to see it on staging/production.

```
cf ssh -L 9000:localhost:8080 publish-data-beta-staging
```

Then go to `localhost:9000/sidekiq` in your browser to see active jobs, retries and to manually modify the schedule.

## Analytics

[Google Analytics][google-analytics] records traffic for [Find] and [CKAN]. Ask for 'read' access to all 'properties' in your request.
