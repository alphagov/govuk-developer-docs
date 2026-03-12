---
owner_slack: "#govuk-developers"
title: Prometheus, grafana and alertmanager
section: Monitoring and alerting
type: learn
layout: manual_layout
parent: "/manual.html"
---

## How we use Prometheus on GOV.UK

The Prometheus Operator installs and configures Prometheus, AlertManager and Grafana through Custom Resource Definitions.

Access to Prometheus, AlertManager and Grafana is managed via Dex, using Github team membership [(Integration example](https://github.com/alphagov/govuk-helm-charts/blob/a881e4ff40e60509d905c6f9f06a65572061613a/charts/kube-prometheus-stack-bootstrap/kube-prometheus-stack-values-integration.yaml#L15))

[Prometheus][link-1] is a systems monitoring and alerting toolkit. Its features include:

- A time-series database, specifically optimised for graphing data over time.
- A DSL for querying the data, called PromQL.
- An HTTP pull model, consisting of Rack middleware that [configures][link-2] Prometheus to scrape data from an HTTP endpoint. Many GOV.UK applications leverage this functionality via the [govuk-app-config][link-3] gem: [For example Finder Frontend][link-4]'s monitoring of [search metrics][link-5].
- A [push gateway][link-6] model, which can be used when an individual job (eg cronjob) creates data that requires graphing or monitoring: [Example][link-7].

It is possible to query the Prometheus database via its [UI][link-8], with [PromQL][link-9] but some people find it easier to use Grafana.

## Grafana

Grafana provides a frontend for visualizing the Prometheus data. A common workflow when exploring the logs and or creating a new dashboard would be:

1. Visit https://grafana.eks.production.govuk.digital/dashboards
2. Create a new dashboard, and save it in the Experiments folder
3. Click "Add visualization", and select "Prometheus" as the datasoure
4. Enter your PromQL query into the Metrics browser field (See [Grafana tips](#grafana-tips-for-the-uninitiated)) for pointers.
5. If you would like to create a permanent dashboard, select "Export" and then "Export as JSON".
6. Copy the output, and open a PR in govuk-helm-charts. [Prior art][link-10]

### Grafana tips

1. When creating a new visualisation, select "Builder" instead of "Code" which provides a nicer UI with drop down menus so you can see, for example, the names of all the labels that are available.
3. The label filter "job" refers to the name of the application.
4. The "Explain" toggle is very helpful, it gives recommendations and syntax.
5. If you open up an existing dashboard and find a panel that is similar to your use case, you can obtain the PromQL expression to use as a starting point by selecting the three dots in the top right hand corner, and then "Explore".

## Alertmanager

Alertmanager reads data directly from Prometheus, and sends notifications when metrics cross predefined thresholds. These thresholds are defined as [rules][link-11] in [govuk-helm-charts][link-12]. See [the Prometheus Operator manual][link-13] on how to write these rules.

It is also possible to see all of the configured alerts via the Prometheus UI itself, by clicking the [Alerts tab][link-14].

Somewhat confusingly, the [Alertmanager UI][link-15] does not show all configured alerts, only those which are currently firing.

### Alert severity levels

As part of the rule definition, each alert is labelled with one of the following severity levels (in decreasing order of urgency), to indicate the impact and expected response time:

- **Page:** Used for urgent, severe conditions that require an immediate response, even out-of-hours. These alerts will be forwarded to [PagerDuty][link-16]. Examples include conditions that make the service unusable or imminently unusable e.g. database is out of disk space.
- **Critical:** Used for conditions that should be addressed promptly within usual business hours, but do not require immediate out-of-hours attention. Examples include conditions that are likely to cause an outage soon e.g. disk usage at 90% with less than a day of capacity left.
- **Warning:** Used as an early indicator of abnormal conditions, that might require investigation during usual business hours if they persist e.g. disk usage at 70%.

Alerts for purely informational or debugging conditions should be avoided, to reduce noise and alert fatigue.

[link-1]: https://github.com/prometheus/prometheus?tab=readme-ov-file#----prometheus
[link-2]: https://github.com/prometheus/client_ruby?tab=readme-ov-file#rack-middleware
[link-3]: https://github.com/alphagov/govuk_app_config/blob/main/lib/govuk_app_config/govuk_prometheus_exporter.rb#L6
[link-4]: https://github.com/alphagov/finder-frontend/blob/main/config/initializers/prometheus.rb
[link-5]: https://github.com/alphagov/finder-frontend/pull/3253
[link-6]: https://github.com/prometheus/client_ruby?tab=readme-ov-file#pushgateway
[link-7]: https://github.com/alphagov/publishing-api/blob/2dd10e66d896be23b7e64762a4b43861a7d6a6f9/lib/tasks/metrics.rake#L37
[link-8]: https://prometheus.eks.production.govuk.digital/query
[link-9]: https://prometheus.io/docs/prometheus/latest/querying/basics/#time-series-selectors
[link-10]: https://github.com/alphagov/govuk-helm-charts/pull/3100/files
[link-11]: https://github.com/alphagov/govuk-helm-charts/tree/a787602eb4734d74babaf943eaa9a9dbb805eb8d/charts/monitoring-config/rules
[link-12]: https://github.com/alphagov/govuk-helm-charts
[link-13]: https://prometheus-operator.dev/docs/api-reference/api/#monitoring.coreos.com/v1alpha1.AlertmanagerConfig
[link-14]: https://prometheus.eks.production.govuk.digital/alerts?search=Search-
[link-15]: https://alertmanager.eks.production.govuk.digital/#/alerts
[link-16]: https://docs.publishing.service.gov.uk/manual/pagerduty.html
