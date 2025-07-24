---
owner_slack: "#govuk-search-alerts"
title: GOV.UK Site search alerts and monitoring
section: Monitoring and alerting
layout: manual_layout
parent: "/manual.html"
---

As desribed in [GOV.UK Search: How it works][link-0] there are two search stacks on GOV.UK. This page includes information on the monitoring and alerting for GOV.UK site search only.

## Sentry

Sentry is set up to track application errors from [Finder Frontend][link-1], and [Search API v2][link-2] including the sync process and API calls from frontend apps.

## Kibana

[Kibana][link-3] can be used to query application logs as per all other GOV.UK apps.

## Grafana

The [GOV.UK Search Grafana dashboard][link-4] visualizes core metrics for site search.

## Alertmanager

We have an informal SLO to maintain a search and autocomplete success rate of about 99.99% over any 24 hour period. If rates drop below this, there are currently four Alertmanager rules configured in govuk-helm-charts to notify the #govuk-search-alerts channel.

> These alerts are purely based on the ratio of error responses to success responses served by SearchAPI v2. In other words they are **not** alerting on search result _quality_. Those alerts are coming soon!

Rules:

- [SearchDegradedAcute][link-5] 5 minute rolling success rate for search requests has dropped below 99% for more than 10 minutes.

- [SearchDegradedMid][link-6] 1 hour rolling success rate for search requests has dropped below 99.9% for more than 2 hours.

- [SearchDegradedLong][link-7] 24 hour rolling success rate for search requests has dropped below 99.99% for more than 24 hours.

- [AutocompleteDegradedAcute][link-8] 5 minute rolling success rate for autocomplete requests has dropped below 90% for more than 10 minutes.

### Causes and steps to take in the event of a Degradation of service alert firing

We are aware of the following occasional errors which should not be considered critical and do not need intervention unless they occur consistently for a large number of users and don’t go away by themselves within a few minutes.

- `Google::Cloud::DeadlineExceededError` A timeout occurred on the Google API
- `Google::Cloud::InternalError` An internal error occurred on the Google API
- `AMQ::Protocol::EmptyResponseError` RabbitMQ sent an unexpected response, possibly due to restarting (the listener will restart by itself in most cases)

If these errors persist and trigger the Degradation of service alerts, this indicates an issue with GCP or Google Vertex AI Search.

1. Login to the [Google Cloud console][link-9], and make sure that the project Search API v2 Production is selected.
2. Under "APIs & Services" in the GCP Console, review the Discovery Engine API usage for traffic and error rates.

#### How to contact Google if there is a critical issue with GCP or Google Vertex AI Search

1. To raise a support ticket, you will first need to login to the [GCP console][link-9]
2. Navigate to the [Support/Cases section][link-10] and press the GET HELP button, ensuring to provide comprehensive reproduction steps.
3. For catastrophic issues or if regular support is unresponsive, escalate the problem in the Google Chat space, instructions are linked from the #govuk-search team slack channel. Always include the support case number.

[link-0]: ./govuk-search.html.md
[link-1]: https://govuk.sentry.io/insights/projects/app-finder-frontend/?project=202224
[link-2]: https://govuk.sentry.io/insights/projects/app-search-api-v2/?project=4505862568935424
[link-3]: ./kibana.html.md
[link-4]: https://grafana.eks.production.govuk.digital/d/govuk-search/gov-uk-search?orgId=1&from=now-24h&to=now&timezone=browser
[link-5]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/monitoring-config/rules/search_api_v2.yaml#2
[link-6]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/monitoring-config/rules/search_api_v2.yaml#L54
[link-7]: https://github.com/alphagov/govuk-helm-charts/blob/3b2fa64a2811ed6b775754938e7270f0dee53d02/charts/monitoring-config/rules/search_api_v2.yaml#L89
[link-8]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/monitoring-config/rules/search_api_v2.yaml#L41
[link-9]: https://console.cloud.google.com/welcome?inv=1&invt=Ab3mhA&project=search-api-v2-production
[link-10]: https://console.cloud.google.com/support/cases?inv=1&invt=Ab3mhA&project=search-api-v2-production
[link-11]: https://docs.google.com/document/d/1Q98DcnLVcjAThP686Cf86TFrQnVbhAZ1PPEE1fxcmBo/edit?tab=t.0
