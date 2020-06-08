---
owner_slack: "#govuk-developers"
title: Monitor your app during deployment
section: Deployment
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2020-02-07
review_in: 6 months
---

## Deployment Dashboards

There are a number of applications with a dashboard showing useful information for the deployment process.

They can be found in [Grafana](tools.html#grafana), and they are all named "Application dashboard - application name", such as [Application dashboard - Whitehall][whitehall-dashboard].

The existing deployment dashboards are written by Puppet every 30 minutes and loaded when Grafana starts. Don’t change them directly.

You can also see further tips on [how we use Graphite][graphite-dashboards] to present the data below.

## Deploy the Dashboards

Please refer to [add a deployment dashboard][add-dashboard] for details on adding or updating dashboards.

[whitehall-dashboard]: https://grafana.publishing.service.gov.uk/dashboard/file/whitehall.json
[graphite-dashboards]: graphite-and-deployment-dashboards.html
[events]: http://graphite.readthedocs.io/en/latest/events.html
[add-dashboard]: add-deployment-dashboard.html
