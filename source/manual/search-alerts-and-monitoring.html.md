---
owner_slack: "#govuk-search"
title: GOV.UK Site search alerts and monitoring
layout: manual_layout
parent: "/manual.html"
section: Search on GOV.UK
related_repos: [search-api-v2, search-api-v2-beta-features]
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

### Degradation of search service alerts

We monitor and alert on both Search API v2 success rates and Google Discovery Engine response times.

#### Search API v2 success rates

We aim to maintain a search success rate of about 99.99% over any 24-hour period. There are currently three Alertmanager rules configured in govuk-helm-charts to send notifications on Slack, if rates drop below this:

- [SearchDegradedAcute][link-6] (__Critical__) 5 minute rolling success rate for search requests has dropped below 99% for more than 10 minutes.

- [SearchDegradedMid][link-7] (__Critical__) 1 hour rolling success rate for search requests has dropped below 99.9% for more than 2 hours.

- [SearchDegradedLong][link-8] (__Warning__) 24 hour rolling success rate for search requests has dropped below 99.99% for more than 24 hours.

#### Google Cloud Discovery Engine request durations

There is currently one Alertmanager rule configured in govuk-helm-charts, [HighVertexP90Latency][link-14], which sends notifications in Slack if requests to Google Cloud Discovery Engine search endpoint exceed acceptable duration thresholds.

Note that, since we have [introduced a 2-second timeout][link-17] on search requests to Discovery Engine, this alert is not expected to fire until the levels are adjusted.

#### Causes of degradation of search service alerts firing

A common cause of drops in search success rate, is high latency from the DiscoveryEngine API. This will result in the [Google::Cloud::DiscoveryEngine Ruby client][link-15] timing out and raising `Google::Cloud::DeadlineExceededError` errors, which in turn lead Search API v2 to respond with 500 errors for search result requests.

We are also aware of the following occasional errors which should not be considered critical and do not need intervention unless they occur consistently for a large number of users and trigger critical alerts.

- Google::Cloud::InternalError An internal error occurred on the Google API
- AMQ::Protocol::EmptyResponseError RabbitMQ sent an unexpected response, possibly due to restarting (the listener will restart by itself in most cases)

#### Steps to take in the event of a critical alert being triggered

If a high number of `Google::Cloud::DeadlineExceededError` or `Google::Cloud::InternalError` errors persist and trigger a critical degradation of service alert, this indicates an issue with GCP or Discovery Engine that we should raise with Google.

1. Login to the [Google Cloud console][link-12], and make sure that the project Search API v2 Production is selected.
2. Under "APIs & Services" in the GCP Console, review the Discovery Engine API usage for traffic and error rates.
3. Issues with Discovery Engine should be [raised with Google](#how-to-contact-google-if-there-is-a-critical-issue-with-gcp-or-discovery-engine).

#### Quantifying the user impact of low search success rates

A degradation in Search API v2 success rates indicates that users will be experiencing a problem with site search on GOV.UK. However it is not a quantitative representation of the number of users being impacted. A better measure would be to look at the error rates for Finder Frontend or Router for requests to search/all with a keyword.

Suggested Kibana query:

```
logjson.request_uri: *search/all?keywords=*
kubernetes.labels.app_kubernetes_io/name: finder-frontend
logjson.status: 500 to 503
kubernetes.container.name: nginx
```

The most accurate way to measure the number of the error pages shown to users is to use [Athena to query the Fastly CDN logs][link-16]

Suggested Athena query:

```
SELECT status, COUNT(*) AS count
FROM fastly_logs.govuk_www
WHERE date = 8 AND month = 5 AND year = 2026
  AND request_received >= TIMESTAMP '2026-05-08 16:00:00.000'
  AND request_received < TIMESTAMP '2026-05-08 23:00:00.000'
  AND url LIKE '%/search/all.html?keywords=%'
GROUP BY status
ORDER BY count DESC
```

### Degradation of autocomplete service alerts

For autocomplete requests, we have [error handling][autocomplete-error-handling] within `search-api-v2` to catch the common errors from the Discovery Engine API
(namely, `Google::Cloud::DeadlineExceededError` and `Google::Cloud::InternalError`) and return an empty array of suggestions. Therefore,
it doesn't make sense to monitor the success rate for autocomplete requests to `search-api-v2`, as this should always be 100%. Instead, we
monitor the number of autocomplete suggestions returned from each request to the Discovery Engine API, and raise an alert if we haven’t received any suggestions
for over an hour (subject to receiving a minimum of 500 responses during that time):

- [AutocompleteDegradedMid][link-9] (__Warning__): Maximum number of autocomplete suggestions returned by Google Cloud Discovery Engine over 1 hour
  has dropped to zero for more than 10 minutes.

#### Causes of degradation of autocomplete service alerts firing

There are three common issues that could cause all autocomplete responses from the Discovery Engine API to be empty (i.e. contain zero suggestions):

- Requests to the Discovery Engine API returning `Google::Cloud::DeadlineExceededError`
- Requests to the Discovery Engine API returning `Google::Cloud::InternalError`
- Requests to the Discovery Engine API returning a successful but empty response.

It's worth noting that, even in healthy environments, we expect around 50% of autocomplete requests to Discovery Engine API to return
zero suggestions (because some search queries are not common enough to have associated autocomplete suggestions).
However, if all requests are returning zero suggestions, that indicates an issue.

#### Steps to take in the event of an alert being triggered

If the [AutocompleteDegradedMid][link-9] alert is firing, the DiscoveryEngine API is either responding to autocomplete
requests with an error code or it's responding with a successful but empty response (i.e. one that contains zero suggestions).

It's important to understand which scenario has occurred so that we can provide a detailed description of the issue we are experiencing to Google.

Use Kibana to locate the cause:

1. Search for logs over the last hour that contain the following text:

```DiscoveryEngine::Autocomplete::Complete: Did not get autocomplete suggestion```

2. Check the `debug_error_string` field for `DeadlineExceededError` or `InternalError`.

The absence of these error messages suggests that Discovery Engine is returning successful but empty responses.

You can also try a few common queries that should always return autocomplete suggestions, and track the logs for these
in Kibana and Google Cloud Platform (after [switching on increased logging][gcp-logging]) to see what's happening.
Such queries include: "tax", "credit" and "work".

Once you know what is causing the issue, [raise a support ticket with Google](#how-to-contact-google-if-there-is-a-critical-issue-with-gcp-or-discovery-engine),
with as much information about the problem as possible including the time the issue started and what the cause is.

#### Quantifying the user impact of degraded autocomplete service

To estimate how many users are not getting autocomplete suggestions when they should be, you could look at how many
requests were made during the window, and divide this by two. This is because we expect about 50% of responses to
legitimately return zero suggestions.

To get a more up-to-date and accurate percentage of responses that should return zero responses, you can look at the
Prometheus histogram metric `search_api_v2_discovery_engine_autocomplete_suggestions_response_bucket`:

1. Pick a timeframe that you want to base the analysis on. This needs to be a timeframe when the autocomplete service was healthy.
You might want to consider choosing a timeframe that matches characteristics of the period that autocomplete is degraded over.
For example, if autocomplete was not working on a Monday, you could choose the last Monday that the service was healthy on to estimate the impact.

2. Go to the Prometheus UI and execute the following query:

   ```sum by(le) (increase(search_api_v2_discovery_engine_autocomplete_suggestions_response_bucket[1h]))```

   Replace `1h` with the length of your chosen timeframe (e.g. 24h, 48h etc).

3. Observe the shown metrics at the **end** of your chosen timeframe by either selecting the relevant time from the calendar selector in the 'table' tab or by hovering over the relevant time in the 'graph' tab.

4. Divide the value shown for `{le="0.0"}` (this is the number of observations with zero suggestions over your chosen timeframe) by the value shown for `{le="+Inf"}` (this is the total number of observations over your chosen timeframe). This gives you the proportion of total requests to Discovery Engine that returned zero suggestions over your chosen timeframe.

5. 1 minus the value from step 4 gives you the proportion of total requests to Discovery Engine that **did not** return zero suggestions over your chosen timeframe.

You can then multiply the value from step 5 with the number of requests made when autocomplete was degraded, to get an estimate
of how many users were affected.

### Degradation of search quality alerts

We have additional Alertmanager rules related to search result quality configured in govuk-helm-charts to send notifications on Slack, if search quality drops below given thresholds:

- [SearchQualityDegradedBinaryRecall][link-10] Top 3 recall for the binary sample query set has dropped below 90% ("warning" level), and below 80% ("critical" level).

- [SearchQualityDegradedClickstreamNDCG][link-11] Top 10 NDCG for the clickstream sample query set has dropped below 85% ("warning" level), and below 75% ("critical" level).

#### Steps to take in the event of a degradation of search quality firing

Significant drops in search quality need to be investigated by the search team to diagnose the issue and [raise a support ticket with Google](#how-to-contact-google-if-there-is-a-critical-issue-with-gcp-or-discovery-engine), if appropriate. If you notice a drop in search quality, make sure the Performance Analyst, Product Manager and Delivery Manager on the search team are aware.

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

## How to contact Google if there is a critical issue with GCP or Discovery Engine

1. To raise a support ticket, you will first need to login to the [GCP console][link-12]
2. Navigate to the [Support/Cases section][link-13] and press the GET HELP button, ensuring to provide comprehensive reproduction steps.
3. For catastrophic issues or if regular support is unresponsive, escalate the problem in the Google Chat space, instructions are linked from the #govuk-search team slack channel. Always include the support case number.

[link-0]: ./govuk-search.html
[link-1]: https://govuk.sentry.io/insights/projects/app-finder-frontend/?project=202224
[link-2]: https://govuk.sentry.io/insights/projects/app-search-api-v2/?project=4505862568935424
[link-3]: https://govuk.sentry.io/insights/projects/app-search-api-v2-beta-features/?project=4510158725513217
[link-4]: ./kibana.html
[link-5]: https://grafana.eks.production.govuk.digital/d/govuk-search/gov-uk-search?orgId=1&from=now-24h&to=now&timezone=browser
[link-6]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/monitoring-config/rules/search_api_v2.yaml#L45
[link-7]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/monitoring-config/rules/search_api_v2.yaml#L89
[link-8]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/monitoring-config/rules/search_api_v2.yaml#L141
[link-9]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/monitoring-config/rules/search_api_v2.yaml#L104
[link-10]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/monitoring-config/rules/search_api_v2.yaml#L164
[link-11]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/monitoring-config/rules/search_api_v2.yaml#L190
[link-12]: https://console.cloud.google.com/welcome?inv=1&invt=Ab3mhA&project=search-api-v2-production
[link-13]: https://console.cloud.google.com/support/cases?inv=1&invt=Ab3mhA&project=search-api-v2-production
[link-14]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/monitoring-config/rules/search_api_v2.yaml#L31
[evaluations-schedule]: https://docs.publishing.service.gov.uk/repos/search-api-v2-beta-features/evaluations.html#schedule
[beta-features-repo]: https://github.com/alphagov/search-api-v2-beta-features
[create-sample-query-sets-in-argo]: https://argo.eks.integration.govuk.digital/applications/search-api-v2-beta-features?orphaned=false&resource=&node=batch%2FCronJob%2Fapps%2Fsearch-api-v2-beta-features-setup-sample-query-sets
[create-sample-query-set-rake-task]: https://github.com/alphagov/search-api-v2-beta-features/blob/main/lib/tasks/quality.rake#L11-L21
[important-metrics]: https://docs.publishing.service.gov.uk/repos/search-api-v2-beta-features/evaluations.html#important-metrics
[this-month-vs-last-month]: https://docs.publishing.service.gov.uk/repos/search-api-v2-beta-features/evaluations.html#this-month-and-last-month
[report-quality-metrics-cron-tasks]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/app-config/values-production.yaml#L3094-L3105
[report-quality-metrics-rake-task]: https://github.com/alphagov/search-api-v2-beta-features/blob/main/lib/tasks/quality.rake#L27
[link-15]: https://github.com/alphagov/search-api-v2/blob/v592/app/services/discovery_engine/clients.rb#L16
[link-16]: https://docs.publishing.service.gov.uk/manual/query-cdn-logs.html
[link-17]: https://github.com/alphagov/search-api-v2/blob/main/app/services/discovery_engine/clients.rb#L17
[gcp-logging]: https://docs.publishing.service.gov.uk/manual/increase-logging-for-site-search.html#increase-logging-in-google-cloud-platform
[autocomplete-error-handling]: https://github.com/alphagov/search-api-v2/blob/main/app/services/discovery_engine/autocomplete/complete.rb#L29
