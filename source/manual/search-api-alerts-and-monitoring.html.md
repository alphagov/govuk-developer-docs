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

There are currently no alerts configured for SearchAPI, the Search Team has prioritized implementation of Search API alerts for Q3 26/27.

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
[link-5]: https://github.com/alphagov/govuk-helm-charts/blob/3aa66aae4bfb89d503d6127936dca932b341970c/charts/monitoring-config/rules/search_api_alerts.yaml#L4
[link-6]: ./opensearch-cluster-health.html#fixing-issues-with-the-cluster
[link-7]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/monitoring-config/rules/search_api_alerts.yaml#L37
