---
owner_slack: "#govuk-search"
title: SearchAPI and Opensearch alerts and monitoring
layout: manual_layout
parent: "/manual.html"
section: Search on GOV.UK
related_repos: [search-api]
type: learn
---

As described in [GOV.UK Search: How it works][how-search-works] there are two search stacks on GOV.UK. This page includes information on the monitoring and alerting for Search API and its Opensearch cluster.

## Dashboard

The [GOV.UK Search API v1 Grafana dashboard][search-api-dashboard] visualizes core metrics for Search API and Finder Frontend.

## Alert types and how to handle them

### Search API success rate

We monitor and alert on Search API success rates. There are currently two Alertmanager rules configured in govuk-helm-charts to send notifications on Slack:

- [SearchApiSearchSuccessRateDegradedAcute][success-degraded-acute-alert] (__Critical__) 5 minute rolling success rate for search requests to search-api has dropped below 99%.

- [SearchApiSearchSuccessRateDegradedMid][success-degraded-mid-alert] (__Critical__) 1 hour rolling success rate for search requests to search-api has dropped below 99.9%.

Refinement of these alerts (to make sure they are comprehensively covering relevant errors) and further alerting has been prioritised by the Search Team for Q3 26/27.

#### Possible causes and steps to take in the event of a critical alert being triggered

- If search-api has recently been deployed and is returning errors, it may require a rollback.
- Search-api is heavily dependent on OpenSearch. If search-api is showing a high number of errors, it could indicate an issue with the OpenSearch
  cluster health, or a disk space issue. See the [Opensearch alerts runbook](#possible-causes-and-steps-to-take-in-the-event-of-an-opensearch-alert-being-triggered) for debugging steps.
- For further diagnosis of issues, check the issue reports in [Sentry][sentry-issues] and/or the logs in [Kibana][kibana].

### Latency alerts

We monitor and alert on Search API latency. There is currently one alert configured:

- [SearchApiHighP90SearchLatency][search-latency-alert] (__Critical__) 90th percentile of search request duration has exceeded 2.5 seconds for more than 15 minutes.

#### Possible causes and steps to take in the event of a latency alert being triggered

- If search-api has recently been deployed and that has caused latency to increase, it may require a rollback.
- Search-api is heavily dependent on OpenSearch. If the latency panels on the
  [GOV.UK Search API v1 Grafana dashboard][search-api-dashboard] are showing that OpenSearch latency
  has also increased compared to the baseline, it could indicate an issue with OpenSearch.
  See [Opensearch Cluster Health manual][fix-cluster-guide] for steps to take to fix issues with the cluster.

### Opensearch alerts

We monitor and alert on Opensearch health. We have the following alerts configured:

- [SearchApiOpensearchClusterStatusRed][status-red-alert] (__Critical__) cluster status is RED for 5 minutes

- [SearchApiOpensearchClusterStatusUnkUnav][status-unknown-alert] (__Critical__) cluster status is UNKNOWN or UNAVAILABLE for 5 minutes

- [SearchApiOpensearchClusterStatusYellow][status-yellow-alert] (__Warning__) cluster status is YELLOW for 30 minutes

- [SearchApiOpensearchDiskSpace][diskspace-critical-alert] (__Critical__) disk space has dropped below 10% for 10 minutes

- [SearchApiOpensearchDiskSpace][diskspace-warning-alert] (__Warning__) disk space has dropped below 30% for 10 minutes

#### Possible causes and steps to take in the event of an opensearch alert being triggered

Check the [Opensearch cluster status panel on the GOV.UK Search API V1 grafana dashboard][cluster-status-panel] to see the cluster status history. See [Opensearch Cluster Health][fix-cluster-guide] for steps to take in the event that an SearchApiOpensearchClusterStatus alert fires.

If a disk space alert fires then we are running out of EBS storage.

- Check the [Opensearch - Percent disk space free Grafana dashboard panel][diskspace-panel] to see if this is just a blip or if we're genuinely running out of space
- If there's been a sudden drop in free disk space investigate where the documents have come from:
  - have they been added in error?
  - can they be removed?
- If we're running out of storage you can increase the capacity of the EBS volume by adjusting the [opensearch variables in terraform][terraform-vars].

## Monitoring and alerting tools

### Sentry

[Sentry][sentry] is set up to track application errors from Search API.

All environments are configured for Slack notifications. Production alerts are routed to #govuk-search-alerts, while alerts for other environments are sent to #govuk-search-alerts-nonprod.

### Kibana

[Kibana][kibana] can be used to query application logs as per all other GOV.UK apps.

### Grafana

The [GOV.UK Search API v1 Grafana dashboard][search-api-dashboard] visualizes core metrics for Search API and Finder Frontend.

[how-search-works]: ./govuk-search.html
[search-api-dashboard]: https://grafana.eks.production.govuk.digital/goto/sx8shj?orgId=default
[success-degraded-acute-alert]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/monitoring-config/rules/search_api_alerts.yaml#L43-L55
[success-degraded-mid-alert]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/monitoring-config/rules/search_api_alerts.yaml#L56-L68
[sentry]: https://govuk.sentry.io/insights/projects/app-search-api/?project=202224
[sentry-issues]: https://govuk.sentry.io/issues/?environment=production&project=1461905&statsPeriod=14d
[kibana]: ./kibana.html
[search-latency-alert]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/monitoring-config/rules/search_api_alerts.yaml#L80-93
[status-red-alert]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/monitoring-config/rules/search_api_alerts.yaml#L111-L125
[status-unknown-alert]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/monitoring-config/rules/search_api_alerts.yaml#L97-L110
[status-yellow-alert]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/monitoring-config/rules/search_api_alerts.yaml#L126-L141
[diskspace-critical-alert]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/monitoring-config/rules/search_api_alerts.yaml#L157-L171
[diskspace-warning-alert]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/monitoring-config/rules/search_api_alerts.yaml#L142-L156
[cluster-status-panel]: https://grafana.eks.production.govuk.digital/d/emvd8hx/gov-uk-search-api-v1?viewPanel=panel-28
[fix-cluster-guide]: ./opensearch-cluster-health.html#fixing-issues-with-the-cluster
[diskspace-panel]: https://grafana.eks.production.govuk.digital/d/emvd8hx/gov-uk-search-api-v1?viewPanel=panel-29
[terraform-vars]: https://github.com/alphagov/govuk-infrastructure/blob/main/terraform/variables/production/search-opensearch.tfvars#L23
