---
owner_slack: "#govuk-platform-health"
title: content-data-api app healthcheck not ok
section: Icinga alerts
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-02-04
review_in: 6 months
---

If there is a health check error showing for Content Data API, you can click on the alert to find out more details about what’s wrong. Here are the possible problems you may see:

## ETL :: no monthly aggregations of metrics for yesterday

This means that [the ETL master process][1] that runs daily that creates aggregations of the metrics failed.

To fix this problem run the [following rake task][5]:

```bash
etl:repopulate_aggregations_month["YYYY-MM-DD", "YYYY-MM-DD"]
```

## ETL :: no <range> searches updated from yesterday

This means that [the Etl process][1] that runs daily and refreshes the Materialized Views failed to update those views.

To fix this problem run the [following rake task][6]:

```bash
etl:repopulate_aggregations_search
```

## ETL :: no daily metrics for yesterday

This means that [the ETL master process][1] that runs daily to retrieve metrics for content items has failed.

To fix this problem [re-run the master process again][1]

## ETL :: no pviews for yesterday

This means the [the ETL master process][1] that runs daily has failed to collect `pageview` metrics from Google Analytics. The issue may originate from the ETL processor responsible for collecting core metrics.

To fix this problem run the [following rake task][2]:

```bash
rake etl:repopulate_views["YYYY-MM-DD","YYYY-MM-DD"]
```

## ETL :: no upviews for yesterday

This means the [the ETL master process][1] that runs daily has failed to collect `unique pageview` metrics from Google Analytics. The issue may originate from the ETL processor responsible for collecting core metrics.

To fix this problem run the [following rake task][2]:

```bash
rake etl:repopulate_views["YYYY-MM-DD","YYYY-MM-DD"]
```

## ETL :: no searches for yesterday

This means the [the ETL master process][1] that runs daily has failed to collect `number of searches` metrics from Google Analytics. The issue may originate from the ELT processor responsible for collecting Internal Searches.

To fix this problem run the [following rake task][3]:

```bash
rake etl:repopulate_searches["YYYY-MM-DD","YYYY-MM-DD"]
```

## ETL :: no feedex for yesterday

This means the [the ETL master process][1] that runs daily has failed to collect `feedex` metrics from `support-api`. The issue may originate from the ETL processor responsible for collecting Feedex comments.

To fix this problem run the [following rake task][4]:

```bash
rake etl:repopulate_feedex["YYYY-MM-DD","YYYY-MM-DD"]
```

[1]: https://deploy.blue.production.govuk.digital/job/content_data_api_import_etl_master_process/
[2]: https://github.com/alphagov/content-data-api/blob/master/lib/tasks/etl.rake#L32
[3]: https://github.com/alphagov/content-data-api/blob/master/lib/tasks/etl.rake#L45
[4]: https://github.com/alphagov/content-data-api/blob/master/lib/tasks/etl.rake#L71
[5]: https://github.com/alphagov/content-data-api/blob/master/lib/tasks/etl.rake#L10
[6]: https://github.com/alphagov/content-data-api/blob/master/lib/tasks/etl.rake#L25
