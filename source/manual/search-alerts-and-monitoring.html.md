---
owner_slack: "#govuk-search-alerts"
title: GOV.UK Site search alerts and monitoring
layout: manual_layout
parent: "/manual.html"
section: Search on GOV.UK
type: learn
---

As described in [GOV.UK Search: How it works][link-0] there are two search stacks on GOV.UK. This page includes information on the monitoring and alerting for GOV.UK site search only.

## Monitoring and alerting tools

### Sentry

Sentry is set up to track application errors from [Finder Frontend][link-1], [Search API v2][link-2] and [Search API v2 beta features][link-3] including the sync process and API calls from frontend apps.

All environments are configured for Slack notifications. Production alerts are routed to #govuk-search-alerts, while alerts for other environments are sent to #govuk-search-alerts-nonprod.

### Kibana

[Kibana][link-4] can be used to query application logs as per all other GOV.UK apps.

### Grafana

The [GOV.UK Search Grafana dashboard][link-5] visualizes core metrics for site search.

### Alertmanager

Alertmanager is used to monitor metrics in Prometheus, and send notifications when metrics cross predefined thresholds.

All environments are configured for Slack notifications. Production alerts are routed to #govuk-search-alerts, while alerts for other environments are sent to #govuk-search-alerts-nonprod.

## Alert types and how to handle them

### Degradation of service alerts

We monitor and alert on both Search API v2 success rates, and Google Vertex response times.

#### Search API v2 success rates

We have an informal SLO to maintain a search and autocomplete success rate of about 99.99% over any 24 hour period. There are currently four Alertmanager rules configured in govuk-helm-charts to send notifications on Slack, if rates drop below this:

- [SearchDegradedAcute][link-6] 5 minute rolling success rate for search requests has dropped below 99% for more than 10 minutes.

- [SearchDegradedMid][link-7] 1 hour rolling success rate for search requests has dropped below 99.9% for more than 2 hours.

- [SearchDegradedLong][link-8] 24 hour rolling success rate for search requests has dropped below 99.99% for more than 24 hours.

- [AutocompleteDegradedAcute][link-9] 5 minute rolling success rate for autocomplete requests has dropped below 90% for more than 10 minutes.

#### Google Vertex AI Search request durations

There is currently one Alertmanager rule configured in govuk-helm-charts, [HighVertexP90Latency](link-14), which sends notifications in Slack if requests to Google Vertex's Search endpoint exceed acceptable duration thresholds.

#### Causes and steps to take in the event of a degradation of service alert firing

We are aware of the following occasional errors which should not be considered critical and do not need intervention unless they occur consistently for a large number of users and don’t go away by themselves within a few minutes.

- `Google::Cloud::DeadlineExceededError` A timeout occurred on the Google API
- `Google::Cloud::InternalError` An internal error occurred on the Google API
- `AMQ::Protocol::EmptyResponseError` RabbitMQ sent an unexpected response, possibly due to restarting (the listener will restart by itself in most cases)

If these errors persist and trigger the degradation of service alerts, this indicates an issue with GCP or Google Vertex AI Search.

1. Login to the [Google Cloud console][link-12], and make sure that the project Search API v2 Production is selected.
2. Under "APIs & Services" in the GCP Console, review the Discovery Engine API usage for traffic and error rates.
3. Issues with Vertex should be [raised with Google](#how-to-contact-google-if-there-is-a-critical-issue-with-gcp-or-google-vertex-ai-search).

### Degradation of search quality alerts

We have additional Alertmanager rules related to search result quality configured in govuk-helm-charts to send notifications on Slack, if search quality drops below given thresholds:

- [SearchQualityDegradedBinaryRecall][link-10] Top 3 recall for the binary sample query set has dropped below 90% ("warning" level), and below 80% ("critical" level).

- [SearchQualityDegradedClickstreamNDCG][link-11] Top 10 NDCG for the clickstream sample query set has dropped below 85% ("warning" level), and below 75% ("critical" level).

#### Steps to take in the event of a degradation of search quality firing

Significant drops in search quality need to be investigated by the search team to diagnose the issue and [raise a support ticket with Google](#how-to-contact-google-if-there-is-a-critical-issue-with-gcp-or-google-vertex-ai-search), if appropriate. If you notice a drop in search quality, make sure the Performance Analyst, Product Manager and Delivery Manager on the search team are aware.

### Failures running evaluations related rake tasks

Evaluations are run regularly on a [schedule][evaluations-schedule], to measure and monitor the quality of search results and notify the search team if quality drops via ["degradation of quality"](#degradation-of-search-quality-alerts) alerts. Parts of this workflow are executed via rake tasks in [Search API v2 beta features][beta-features-repo], and raise errors in Sentry when they fail. The most common errors are:

- `Google::Cloud::AlreadyExistsError` (Active evaluation already exists): Only one evaluation in each environment is allowed to be run at one time. This error occurs when an evaluation is triggered when there is already one running.
- `Google::Cloud::NotFoundError` (SampleQuerySet): Occurs when a sample query set has not been created, but a rake task is attempting to use it.
- `Google::Cloud::NotFoundError` (ServingConfig): Occurs when an evaluation cannot locate the specified serving configuration.

Because the evaluations feature is in beta, rake tasks can also fail for unexpected reasons.

#### Steps to take in the event of a sample query set not being created

If a rake task is attempting to use a sample query set that does not exist and a related `Google::Cloud::NotFoundError` is being raised, the relevant sample query set should be created manually by re-running the [cronJob that creates the sample query sets in Argo][create-sample-query-sets-in-argo]. This rake task will run through to create all sample query sets (binary, clickstream and explicit) for the current month, and import the data from BigQuery. Where the sample query set has been created already, the creation of the sample query set will be skipped and the data will be reimported (replaced) into the sample query set.

It is important to ensure that all required sample query sets exist in all environments, since evaluations cannot run without them.

#### Steps to take in the event of a failed evaluation run

If an evaluation fails for a reason other than a sample query set not existing, take the following steps:

1. **Check the environment.** If the failure is in production, carry on through the next steps. Otherwise, do nothing. (Quality of search results is less meaningful/important in non-production environments.)

2. **Check which evaluations have failed by checking logs in Kibana.** To get an effective read on current quality of search results, we need to be regularly reporting our [important metrics][important-metrics] for ["this month"][this-month-vs-last-month]. In practice this can mean:

    - Ignoring any failed runs of "last month" evaluations.
    - Ignoring any failed runs of the explicit evaluations.
    - Ensuring there is a successful run of the "this month" clickstream evaluation at least every other day.
    - Ensuring there is a successful run of the "this month" binary evaluation at least twice a day.

    If an evaluation needs to be re-run, carry on through the next steps.

3. **(Optional) Temporarily pause scheduled evaluations.** Because only one evaluation can run at a time in each environment, if a scheduled evaluation starts before an ad-hoc run has finished, the scheduled evaluation is likely to fail and raise more alerts. If you want to avoid this, you can edit the [cron schedule][report-quality-metrics-cron-tasks] in helm charts to temporarily pause scheduled evaluations.

4. **Re-run the relevant [evaluation cronJob][report-quality-metrics-cron-tasks] in Argo for the evaluation that has failed.** Note that the evaluations rake task will run the evaluation for both "this month" and "last month".

5. **Restore usual schedule of evaluation runs.** This is only relevant if scheduled evaluations were temporarily paused in step 3.

## How to contact Google if there is a critical issue with GCP or Google Vertex AI Search

1. To raise a support ticket, you will first need to login to the [GCP console][link-12]
2. Navigate to the [Support/Cases section][link-13] and press the GET HELP button, ensuring to provide comprehensive reproduction steps.
3. For catastrophic issues or if regular support is unresponsive, escalate the problem in the Google Chat space, instructions are linked from the #govuk-search team slack channel. Always include the support case number.

[link-0]: ./govuk-search.html
[link-1]: https://govuk.sentry.io/insights/projects/app-finder-frontend/?project=202224
[link-2]: https://govuk.sentry.io/insights/projects/app-search-api-v2/?project=4505862568935424
[link-3]: https://govuk.sentry.io/insights/projects/app-search-api-v2-beta-features/?project=4510158725513217
[link-4]: ./kibana.html
[link-5]: https://grafana.eks.production.govuk.digital/d/govuk-search/gov-uk-search?orgId=1&from=now-24h&to=now&timezone=browser
[link-6]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/monitoring-config/rules/search_api_v2.yaml#L63
[link-7]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/monitoring-config/rules/search_api_v2.yaml#L115
[link-8]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/monitoring-config/rules/search_api_v2.yaml#L152
[link-9]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/monitoring-config/rules/search_api_v2.yaml#L78
[link-10]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/monitoring-config/rules/search_api_v2.yaml#L188
[link-11]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/monitoring-config/rules/search_api_v2.yaml#L201
[link-12]: https://console.cloud.google.com/welcome?inv=1&invt=Ab3mhA&project=search-api-v2-production
[link-13]: https://console.cloud.google.com/support/cases?inv=1&invt=Ab3mhA&project=search-api-v2-production
[link-14]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/monitoring-config/rules/search_api_v2.yaml#L49
[evaluations-schedule]: https://docs.publishing.service.gov.uk/repos/search-api-v2-beta-features/evaluations.html#schedule
[beta-features-repo]: https://github.com/alphagov/search-api-v2-beta-features
[create-sample-query-sets-in-argo]: https://argo.eks.integration.govuk.digital/applications/search-api-v2-beta-features?orphaned=false&resource=&node=batch%2FCronJob%2Fapps%2Fsearch-api-v2-beta-features-setup-sample-query-sets
[create-sample-query-set-rake-task]: https://github.com/alphagov/search-api-v2-beta-features/blob/main/lib/tasks/quality.rake#L11-L21
[important-metrics]: https://docs.publishing.service.gov.uk/repos/search-api-v2-beta-features/evaluations.html#important-metrics
[this-month-vs-last-month]: https://docs.publishing.service.gov.uk/repos/search-api-v2-beta-features/evaluations.html#this-month-and-last-month
[report-quality-metrics-cron-tasks]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/app-config/values-production.yaml#L3094-L3105
[report-quality-metrics-rake-task]: https://github.com/alphagov/search-api-v2-beta-features/blob/main/lib/tasks/quality.rake#L27
