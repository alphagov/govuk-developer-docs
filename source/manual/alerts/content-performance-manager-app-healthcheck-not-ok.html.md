---
owner_slack: "#govuk-data-informed"
title: content-performance-manager app healthcheck not ok
section: Icinga alerts
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-02-04
review_in: 6 months
---

If there is a health check error showing for Content Performance Manager, you can click on the alert to find out more details about what’s wrong. Here are the possible problems you may see:

## ETL :: no daily metrics for yesterday

This means that [the ETL master process][1] that runs daily to retrieve metrics for content items has failed.  

#### Notify Data Informed Content team

Please notify Data Informed Content via Slack `#govuk-data-informed` about the alarm. The product is currently in private beta, so the development team will help solve any issues.

[Re-run the master process again][1] 


[1]: https://deploy.publishing.service.gov.uk/job/content_performance_manager_import_etl_master_process/
