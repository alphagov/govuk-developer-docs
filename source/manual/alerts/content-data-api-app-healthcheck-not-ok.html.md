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
etl:repopulate_aggregations_month["2019-02-14", "2019-02-14"]
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
rake etl:repopulate_views["2018-01-01","2018-01-01"]
```

## ETL :: no upviews for yesterday

This means the [the ETL master process][1] that runs daily has failed to collect `unique pageview` metrics from Google Analytics. The issue may originate from the ETL processor responsible for collecting core metrics.

To fix this problem run the [following rake task][2]:

```bash
rake etl:repopulate_views["2018-01-01","2018-01-01"]
```

## ETL :: no searches for yesterday

This means the [the ETL master process][1] that runs daily has failed to collect `number of searches` metrics from Google Analytics. The issue may originate from the ELT processor responsible for collecting Internal Searches.

To fix this problem run the [following rake task][3]:

```bash
rake etl:repopulate_searches["2018-01-01","2018-01-02"]
```

## ETL :: no feedex for yesterday

This means the [the ETL master process][1] that runs daily has failed to collect `feedex` metrics from `support-api`. The issue may originate from the ETL processor responsible for collecting Feedex comments.

To fix this problem run the [following rake task][4]:

```bash
rake etl:repopulate_feedex["2018-01-01","2018-01-01"]
```

[1]: https://deploy.blue.production.govuk.digital/job/content_data_api_import_etl_master_process/
[2]: https://github.com/alphagov/content-data-api/blob/87116d3ab6f75c0d3dd8be9d4aff80865702f1b9/lib/tasks/etl.rake#L8
[3]: https://github.com/alphagov/content-data-api/blob/8dd689e6917d7bbbf23a99387b85bfe1ce04d7b1/lib/tasks/etl.rake#L18
[4]: https://github.com/alphagov/content-data-api/blob/b886c5489c79a6b5a58190e305ea9746fd7db666/lib/tasks/etl.rake#L29
[5]: https://github.com/alphagov/content-data-api/blob/1dc3f7becf146bbd5f346634e98d05ad76477a8e/lib/tasks/etl.rake#L7
[6]: https://github.com/alphagov/content-data-api/blob/3c73c534d1a42208d6b2bdaef57d3b79d1998ea3/lib/tasks/etl.rake
