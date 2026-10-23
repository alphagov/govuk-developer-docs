---
owner_slack: "#govuk-search"
title: SearchAPI and Opensearch alerts and monitoring
layout: manual_layout
parent: "/manual.html"
section: Search on GOV.UK
related_repos: [search-api]
type: learn
---

As described in [GOV.UK Search: How it works][link-0] there are two search stacks on GOV.UK. This page includes information on the monitoring and alerting for Search API and its Opensearch cluster.

## Monitoring and alerting tools

### Sentry

[Sentry][link-1] is set up to track application errors from Search API.

All environments are configured for Slack notifications. Production alerts are routed to #govuk-search-alerts, while alerts for other environments are sent to #govuk-search-alerts-nonprod.

### Kibana

[Kibana][link-2] can be used to query application logs as per all other GOV.UK apps.

### Grafana

The [GOV.UK Search API v1 Grafana dashboard][link-3] visualizes core metrics for Search API and Finder Frontend.

## Alert types and how to handle them

### Search API success rate and latency alerts

We monitor and alert on Search API success rates. There are currently two Alertmanager rules configured in govuk-helm-charts to send notifications on Slack:

- [SearchApiSearchSuccessRateDegradedAcute][link-8] (__Critical__) 5 minute rolling success rate for search requests to search-api has dropped below 99%.

- [SearchApiSearchSuccessRateDegradedMid][link-9] (__Critical__) 1 hour rolling success rate for search requests to search-api has dropped below 99.9%.

Refinement of these alerts (to make sure they are comprehensively covering relevant errors) and further alerting has been prioritised by the Search Team for Q3 26/27.

#### Possible causes and steps to take in the event of a critical alert being triggered

- If search-api has recently been deployed and is returning errors, it may require a rollback.
- Search-api is heavily dependent on OpenSearch. If search-api is showing a high number of errors, it could indicate an issue with the OpenSearch
  cluster health, or a disk space issue. Both [cluster health][link-10] and [disk space][link-11] are shown on the [GOV.UK Search API v1 Grafana dashboard][link-3],
  and we have [separate alerting for these scenarios](#opensearch-cluster-health-alerts).
    - If there is a problem with cluster health, see [Opensearch Cluster Health][link-4] for more information on how to investigate and fix an issue.
    - If disk space is below 30%, consider increasing storage capacity.
- For further diagnosis of issues, check the issue reports in [Sentry][link-12] and/or the logs in [Kibana][link-2].

### Opensearch Cluster health alerts

Opensearch cluster health monitoring is available, and is described at [Opensearch Cluster Health][link-4]

We have the following alerts configured:

- [SearchApiClusterStatus][link-5] triggers if the status is [unavailable, yellow or red][link-4]. See [Fixing issues with the cluster][link-6]

- [SearchApiElasticsearchDiskSpace][link-7] triggers if disk space drops below 30% (warning level) or 10% (critical level). Consider increasing storage capacity if this alert fires.

[link-0]: ./govuk-search.html
[link-1]: https://govuk.sentry.io/insights/projects/app-search-api/?project=202224
[link-2]: ./kibana.html
[link-3]: https://grafana.eks.production.govuk.digital/goto/sx8shj?orgId=default
[link-4]: ./opensearch-cluster-health.html
[link-5]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/monitoring-config/rules/search_api_alerts.yaml#L72-L104
[link-6]: ./opensearch-cluster-health.html#fixing-issues-with-the-cluster
[link-7]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/monitoring-config/rules/search_api_alerts.yaml#L105-L126
[link-8]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/monitoring-config/rules/search_api_alerts.yaml#L43-L55
[link-9]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/monitoring-config/rules/search_api_alerts.yaml#L56-L68
[link-10]: https://grafana.eks.production.govuk.digital/d/emvd8hx/gov-uk-search-api-v1?viewPanel=panel-28
[link-11]: https://grafana.eks.production.govuk.digital/d/emvd8hx/gov-uk-search-api-v1?viewPanel=panel-29
[link-12]: https://govuk.sentry.io/issues/?environment=production&project=1461905&statsPeriod=14d
