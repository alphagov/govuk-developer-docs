---
owner_slack: "#govuk-developers"
title: Grafana
section: Monitoring
type: learn
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-08-16
review_in: 6 months
---

Grafana lets us create nice dashboards using Graphite data.

- Production
  - [AWS](https://grafana.blue.production.govuk.digital)
  - [Carrenza](https://grafana.publishing.service.gov.uk)
- Staging
  - [AWS](https://grafana.blue.staging.govuk.digital)
  - [Carrenza](https://grafana.staging.publishing.service.gov.uk)
- Integration
  - [AWS](https://grafana.integration.publishing.service.gov.uk)
  - There is no Carrenza Integration anymore
- CI
  - [Carrenza](https://ci-grafana.integration.publishing.service.gov.uk)

Useful Grafana dashboards:

- [Origin health](https://grafana.publishing.service.gov.uk/dashboard/file/origin_health.json)
- [Edge health](https://grafana.publishing.service.gov.uk/dashboard/file/edge_health.json)
- [Application deployment dashboards](deployment-dashboards.html)

The full list of Grafana dashboards is [stored in the Puppet repo][dashboards]

[dashboards]: https://github.com/alphagov/govuk-puppet/blob/master/modules/grafana/manifests/dashboards.pp
