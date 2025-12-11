---
owner_slack: "#govuk-search-alerts"
title: GOV.UK Site search alerts and monitoring
section: Monitoring and alerting
layout: manual_layout
parent: "/manual.html"
---

As desribed in [GOV.UK Search: How it works][link-0] there are two search stacks on GOV.UK. This page includes information on the monitoring and alerting for GOV.UK site search only.

## Sentry

Sentry is set up to track application errors from [Finder Frontend][link-1], [Search API v2][link-2] and [Search API v2 beta features][link-3] including the sync process and API calls from frontend apps.

## Kibana

[Kibana][link-4] can be used to query application logs as per all other GOV.UK apps.

## Grafana

The [GOV.UK Search Grafana dashboard][link-5] visualizes core metrics for site search.

## Alertmanager

We have an informal SLO to maintain a search and autocomplete success rate of about 99.99% over any 24 hour period. There are currently four Alertmanager rules configured in govuk-helm-charts to send notifications on Slack, if rates drop below this.

We also have additional Alertmanager rules related to search result quality configured in govuk-helm-charts to send notifications on Slack, if search quality drops below given thresholds.

All environments are configured for Slack notifications. Production alerts are routed to #govuk-search-alerts, while alerts for other environments are sent to #govuk-search-alerts-nonprod.

Success rate rules:

- [SearchDegradedAcute][link-6] 5 minute rolling success rate for search requests has dropped below 99% for more than 10 minutes.

- [SearchDegradedMid][link-7] 1 hour rolling success rate for search requests has dropped below 99.9% for more than 2 hours.

- [SearchDegradedLong][link-8] 24 hour rolling success rate for search requests has dropped below 99.99% for more than 24 hours.

- [AutocompleteDegradedAcute][link-9] 5 minute rolling success rate for autocomplete requests has dropped below 90% for more than 10 minutes.

Search quality rules:

- [SearchQualityDegradedBinaryRecall][link-10] Top 3 recall for binary query set has dropped below 90% ("warning" level), and below 80% ("critical" level).

- [SearchQualityDegradedClickstreamNDCG][link-11] Top 10 NDCG for clickstream query set has dropped below 85% ("warning" level), and below 75% ("critical" level).

### Causes and steps to take in the event of a Degradation of service alert firing

We are aware of the following occasional errors which should not be considered critical and do not need intervention unless they occur consistently for a large number of users and don’t go away by themselves within a few minutes.

- `Google::Cloud::DeadlineExceededError` A timeout occurred on the Google API
- `Google::Cloud::InternalError` An internal error occurred on the Google API
- `AMQ::Protocol::EmptyResponseError` RabbitMQ sent an unexpected response, possibly due to restarting (the listener will restart by itself in most cases)

If these errors persist and trigger the Degradation of service alerts, this indicates an issue with GCP or Google Vertex AI Search.

1. Login to the [Google Cloud console][link-12], and make sure that the project Search API v2 Production is selected.
2. Under "APIs & Services" in the GCP Console, review the Discovery Engine API usage for traffic and error rates.

#### How to contact Google if there is a critical issue with GCP or Google Vertex AI Search

1. To raise a support ticket, you will first need to login to the [GCP console][link-12]
2. Navigate to the [Support/Cases section][link-13] and press the GET HELP button, ensuring to provide comprehensive reproduction steps.
3. For catastrophic issues or if regular support is unresponsive, escalate the problem in the Google Chat space, instructions are linked from the #govuk-search team slack channel. Always include the support case number.

[link-0]: ./govuk-search.html
[link-1]: https://govuk.sentry.io/insights/projects/app-finder-frontend/?project=202224
[link-2]: https://govuk.sentry.io/insights/projects/app-search-api-v2/?project=4505862568935424
[link-3]: https://govuk.sentry.io/insights/projects/app-search-api-v2-beta-features/?project=4510158725513217
[link-4]: ./kibana.html
[link-5]: https://grafana.eks.production.govuk.digital/d/govuk-search/gov-uk-search?orgId=1&from=now-24h&to=now&timezone=browser
[link-6]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/monitoring-config/rules/search_api_v2.yaml#L41
[link-7]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/monitoring-config/rules/search_api_v2.yaml#L93
[link-8]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/monitoring-config/rules/search_api_v2.yaml#L130
[link-9]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/monitoring-config/rules/search_api_v2.yaml#L56
[link-10]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/monitoring-config/rules/search_api_v2.yaml#L153
[link-11]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/monitoring-config/rules/search_api_v2.yaml#L179
[link-12]: https://console.cloud.google.com/welcome?inv=1&invt=Ab3mhA&project=search-api-v2-production
[link-13]: https://console.cloud.google.com/support/cases?inv=1&invt=Ab3mhA&project=search-api-v2-production
