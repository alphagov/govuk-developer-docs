---
owner_slack: "#govuk-search"
title: Add Missing User Events to Site Search
layout: manual_layout
parent: "/manual.html"
section: Search on GOV.UK
related_repos: [search-api-v2]
---

We capture interaction data from opted-in users in Google Analytics. This data is processed and ingested into Discovery Engine each day, and feeds into autocomplete suggestions and click-based search result ranking.

Sometimes the GA4 data is delayed. If it’s not received before our [dataform pipelines run at 12:00](https://github.com/alphagov/govuk-infrastructure/blob/main/terraform/deployments/search-api-v2/dataform.tf#L78:L92) then it will not be imported into Discovery Engine.

A [Sentry alert](https://govuk.sentry.io/monitors/alerts/6140950/?project=4505862568935424&statsPeriod=14d) will notify us if the count of events is below expected thresholds. We should manually import the missing user events.

## If user events data is missing

### Check which data is missing

1. Run a query in BigQuery Studio to check which tables are affected.
   1. You will need to run this for the `search-event`, `view-item-event` & `view-item-external-link-event` tables, and should check **all** environments in case they are not in the same state as each other.

    ```bigquery
    -- Example query to check number of rows of data in BigQuery

    SELECT COUNT(*)
    FROM `search-api-v2-production.analytics_events_vertex.search-event`
    WHERE TIMESTAMP_TRUNC(_PARTITIONTIME, DAY) = TIMESTAMP("2026-08-24")
    ```

1. Compare the results to the [minimum_events_thresholds defined in Search API v2](https://github.com/alphagov/search-api-v2/blob/main/app/services/discovery_engine/user_events/import.rb#L33).

### Confirm that the GA4 data has now been received

Check in [#govuk-ga4](https://gds.slack.com/archives/C02HKNAEGAZ) slack channel to confirm that GA4 data has been received.

> Note: There is no point in re-running the dataform pipelines until the GA4 data has been received.

### Re-run the dataform pipelines for the tables that are missing data

You will need to re-run the dataform pipelines in **all** environments for the tables that are missing data.

1. Navigate to the search-daily-<environment> pipeline in GCP (e.g. [search-daily-production](https://console.cloud.google.com/bigquery/pipelines-and-connections/details/locations/europe-west2/repositories/search_api_v2/schedules/search-daily-production?project=search-api-v2-production))
2. Click on the date of the run that is missing data
   1. (Note: The query is fairly stable, so it won't usually matter which date you choose. Picking the date of the failed run will prevent mishaps, though.)
3. For each table that is missing data
   1. Click ‘view details’ for the row whose action matches the table name
   2. Click on the ‘Job ID’ (to open an editable version of the query in the console)
   3. Adjust the query to include the appropriate date (replace `DATE_SUB(CURRENT_DATE(),INTERVAL 1 DAY)` with date in format `'2026-01-31'`
   4. Run query

### Re-run the rake task to import user events to Discovery Engine

You will need to re-run the rake task in **all** environments.

`rake "user_events:import_events_for_date['<date>']"`

## Background information

### The user events pipeline on site search

Google recommends uploading user events at least daily to maintain good data quality.

The process by which the data is ingested is as follows:

1. GA4 user interaction data is processed overnight by the GOV.UK analytics pipeline and ingested into GCP BigQuery.

2. The interaction data is transformed, via [dataform pipelines](https://github.com/alphagov/search-api-v2-dataform), into a [format](https://github.com/alphagov/govuk-infrastructure/blob/main/terraform/deployments/search-api-v2/events_ingestion.tf#L12-L88) that can be ingested by Discovery Engine.

3. The transformed data is [imported into Discovery Engine as "user events"](https://docs.cloud.google.com/generative-ai-app-builder/docs/import-user-events), via [automated Rake tasks](https://github.com/alphagov/govuk-helm-charts/blob/main/charts/app-config/values-production.yaml#L3037:L3042).

### How Google Agent Search uses user events

Google recommends recording user events for custom search and recommendations apps.

#### Improve quality of search results

By importing user events, you can improve the quality of your search results. For example, user events affect the ranking of search results. Results with higher click-through rates are boosted, while results with lower click-through rates are buried.

#### Generate autocomplete suggestions

The user events model generates suggestions from user-imported events of type `search`.
