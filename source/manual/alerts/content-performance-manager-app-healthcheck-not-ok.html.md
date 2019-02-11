---
owner_slack: "#govuk-data-informed"
title: content-performance-manager app healthcheck not ok
section: Icinga alerts
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-02-04
review_in: 6 months
---

## Notify Data Informed Content team

Please notify Data Informed Content via Slack `#govuk-data-informed` about the alarm. The product is currently in private beta, so the development team will help solve any issues.

If there is a health check error showing for Content Performance Manager, you can click on the alert to find out more details about what’s wrong. Here are the possible problems you may see:

## ETL :: no daily metrics for yesterday

This means that [the ETL master process][1] that runs daily to retrieve metrics for content items has failed.  

To fix this problem [Re-run the master process again][1] 

## ETL :: no pviews for yesterday

This means that the [the ETL master process][1] that runs daily to collect metrics from Google Analytics has failed. In particular, the ETL processor that collects the core metrics.

At least the `page-views` metric for each content item has not been received

To fix this problem run the [following rake task][2]:

```bash
rake etl:repopulate_views[2018-01-01 2018-01-02]
```

## ETL :: no upviews for yesterday

This means that the [the ETL master process][1] that runs daily to collect metrics from Google Analytics has failed. In particular, the ETL processor that collects the core metrics.

At least the `unique-page-views` metric for each content item has not been received

To fix this problem run the [following rake task][2]:

```bash
rake etl:repopulate_views[2018-01-01 2018-01-02]
```

## ETL :: no searches for yesterday

This means that the [the ETL master process][1] that runs daily to collect metrics from Google Analytics has failed. In particular, the ETL processor that collects number of searches.


To fix this problem run the [following rake task][3]:

```bash
rake etl:repopulate_searches[2018-01-01 2018-01-02]
```



[1]: https://deploy.publishing.service.gov.uk/job/content_performance_manager_import_etl_master_process/
[2]: https://github.com/alphagov/content-performance-manager/blob/87116d3ab6f75c0d3dd8be9d4aff80865702f1b9/lib/tasks/etl.rake#L8
[3]: https://github.com/alphagov/content-performance-manager/blob/8dd689e6917d7bbbf23a99387b85bfe1ce04d7b1/lib/tasks/etl.rake#L18