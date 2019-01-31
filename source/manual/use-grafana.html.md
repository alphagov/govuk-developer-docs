---
owner_slack: "#govuk-2ndline"
title: Use Grafana to monitor GOV.UK
section: Monitoring
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-01-31
review_in: 6 months
---

Grafana lets us create nice dashboards [data from Graphite](use-graphite-data.html) and log data from Elasticsearch.

Useful Grafana dashboards:

- [Origin health](https://grafana.publishing.service.gov.uk/dashboard/file/origin_health.json)
- [Edge health](https://grafana.publishing.service.gov.uk/dashboard/file/edge_health.json)
- [Application deployment dashboards](deployment-dashboards.html)

The full list of Grafana dashboards is [stored in the Puppet repo][dashboards]

[dashboards]: https://github.com/alphagov/govuk-puppet/blob/master/modules/grafana/manifests/dashboards.pp
