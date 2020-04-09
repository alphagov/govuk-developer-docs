---
owner_slack: "#govuk-datagovuk"
title: Monitor data.gov.uk
section: data.gov.uk
layout: manual_layout
parent: "/manual.html"
---
[publish]: apps/datagovuk_publish
[operating-dgu]: /manual/data-gov-uk-operations.html
[find]: apps/datagovuk_find
[paas-metric-exporter]: https://reliability-engineering.cloudapps.digital/manuals/set-up-paas-metric-exporter-with-prometheus.html#configure-container-metrics
[grafana]: https://grafana-paas.cloudapps.digital/d/rk9fSapik/data-gov-uk-2nd-line?orgId=1
[grafana-app-dashboard]: https://grafana-paas.cloudapps.digital/d/xonj40imk/data-gov-uk?refresh=1m&orgId=1
[sentry]: https://sentry.io/govuk/
[logit-paas]: https://docs.cloud.service.gov.uk/#set-up-the-logit-io-log-management-service
[logit]: https://logit.io/a/1c6b2316-16e2-4ca5-a3df-ff18631b0e74
[google-analytics]: https://sites.google.com/a/digital.cabinet-office.gov.uk/gds/information-management/use-online-tools-in-gds/use-google-analytics
[pagerduty]: https://govuk.pagerduty.com/
[ckan]: apps/ckanext-datagovuk
[dgu-queue-monitor]: https://github.com/alphagov/datagovuk_publish_queue_monitor
[dgu-elastic-monitor]: https://github.com/alphagov/datagovuk_publish_elasticsearch_monitor
[dgu-dashboard](https://grafana-paas.cloudapps.digital/d/rk9fSapik/data-gov-uk-2nd-line?orgId=1)

## Prometheus

There are two dashboards: [DGU for 2nd line][grafana] displays a summary overview of key stats (including queue length), and [DGU Apps Dashboard][grafana-app-dashboard] which shows the health of each app deployment (a drop-down menu on the dashboard allows the PaaS app to be selected).

Metrics are exposed to Prometheus through a `/metrics` endpoint from the PaaS-team maintained [paas-metric-exporter] app.  This provides separate stats for each app running in the DGU space on the PaaS.

Two additional apps expose `/metrics` endpoints which summarise the state of various parts of data.gov.uk.  These are [datagovuk_publish_queue_monitor][dgu-queue-monitor] for the state of the Sidekiq queues used to sync data between CKAN and Publish, and [datagovuk-publish-elasticsearch-monitor][dgu-elastic-monitor] for monitoring the Elasticsearch indices.

## Pingdom

Pingdom monitors `https://data.gov.uk` uptime and alerts [PagerDuty] when downtime is detected. Maintenace of this service forms part of `#govuk-2nd-line`.

## Sentry

[Sentry] monitors application errors. The Sentry pages for each app can be found on the [Find] and [Publish] app pages.

## Log.it

Each application sends logs to [Logit]. [Publish] and [Find] use the corresponding [PaaS Service][logit-paas]. Example query: `source_host: "gds-data-gov-uk.data-gov-uk.find-data-beta" && access.response_code: 500`.

## Data.gov.uk production dashboard

You can view the [DGU dashboard](https://grafana-paas.cloudapps.digital/d/rk9fSapik/data-gov-uk-2nd-line?orgId=1) to get an overview of DGU that includes Find 4xx and 5xx, Publish elasticsearch index size and Sidekiq metrics.

## Sidekiq ([Publish])

You can monitor the number of jobs in each queue using the following.

First, follow the instructions on [logging into the paas][operating-dgu]

```
cf ssh publish-data-beta-production-worker
/tmp/lifecycle/launcher /home/vcap/app 'rails console' ''
>>> Sidekiq::Queue.new.each_with_object(Hash.new(0)) {|j, h| h[j.klass] += 1 }
```

## Analytics

[Google Analytics][google-analytics] records traffic for [Find]. Ask for 'read' access to all 'properties' in your request.
