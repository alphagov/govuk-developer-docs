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

## Dashboard

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
  cluster health, or a disk space issue. See the [Opensearch alerts runbook](#possible-causes-and-steps-to-take-in-the-event-of-an-opensearch-alert-being-triggered) for debugging steps.
- For further diagnosis of issues, check the issue reports in [Sentry][link-12] and/or the logs in [Kibana][link-2].

### Opensearch alerts

We monitor and alert on Opensearch health. We have the following alerts configured:

- [SearchApiOpensearchClusterStatusRed][link-5] (__Critical__) cluster status is RED for 5 minutes

- [SearchApiOpensearchClusterStatusUnkUnav][link-16] (__Critical__) cluster status is UNKNOWN or UNAVAILABLE for 5 minutes

- [SearchApiOpensearchClusterStatusYellow][link-17] (__Warning__) cluster status is YELLOW for 30 minutes

- [SearchApiOpensearchDiskSpace][link-13] (__Critical__) disk space has dropped below 10% for 10 minutes

- [SearchApiOpensearchDiskSpace][link-7] (__Warning__) disk space has dropped below 30% for 10 minutes

#### Possible causes and steps to take in the event of an opensearch alert being triggered

Check the [Opensearch cluster status panel on the GOV.UK Search API V1 grafana dashboard][link-10] to see the cluster status history. See [Opensearch Cluster Health][link-6] for steps to take in the event that an SearchApiOpensearchClusterStatus alert fires.

If a disk space alert fires then we are running out of EBS storage.

- Check the [Opensearch - Percent disk space free Grafana dashboard panel][link-11] to see if this is just a blip or if we're genuinely running out of space
- If there's been a sudden drop in free disk space investigate where the documents have come from:
  - have they been added in error?
  - can they be removed?
- If we're running out of storage you can increase the capacity of the EBS volume by adjusting the [opensearch variables in terraform][link-15].

## Monitoring and alerting tools

### Sentry

[Sentry][link-1] is set up to track application errors from Search API.

All environments are configured for Slack notifications. Production alerts are routed to #govuk-search-alerts, while alerts for other environments are sent to #govuk-search-alerts-nonprod.

### Kibana

[Kibana][link-2] can be used to query application logs as per all other GOV.UK apps.

### Grafana

The [GOV.UK Search API v1 Grafana dashboard][link-3] visualizes core metrics for Search API and Finder Frontend.

[link-0]: ./govuk-search.html
[link-1]: https://govuk.sentry.io/insights/projects/app-search-api/?project=202224
[link-2]: ./kibana.html
[link-3]: https://grafana.eks.production.govuk.digital/goto/sx8shj?orgId=default

[link-5]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/monitoring-config/rules/search_api_alerts.yaml#L86-L100
[link-6]: ./opensearch-cluster-health.html#fixing-issues-with-the-cluster
[link-7]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/monitoring-config/rules/search_api_alerts.yaml#L117-L131
[link-8]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/monitoring-config/rules/search_api_alerts.yaml#L43-L55
[link-9]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/monitoring-config/rules/search_api_alerts.yaml#L56-L68
[link-10]: https://grafana.eks.production.govuk.digital/d/emvd8hx/gov-uk-search-api-v1?viewPanel=panel-28
[link-11]: https://grafana.eks.production.govuk.digital/d/emvd8hx/gov-uk-search-api-v1?viewPanel=panel-29
[link-12]: https://govuk.sentry.io/issues/?environment=production&project=1461905&statsPeriod=14d
[link-13]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/monitoring-config/rules/search_api_alerts.yaml#L132-L146

[link-15]: https://github.com/alphagov/govuk-infrastructure/blob/main/terraform/variables/production/search-opensearch.tfvars#L23
[link-16]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/monitoring-config/rules/search_api_alerts.yaml#L72-L85
[link-17]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/monitoring-config/rules/search_api_alerts.yaml#L101-L116
