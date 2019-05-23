---
owner_slack: "#govuk-finding-brexit"
title: How to debug underperforming search
section: Monitoring
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-05-23
review_in: 3 months
---

Search is one of the more load-sensitive parts of GOV.UK, as it can't be cached as effectively as more static pages.  There are two significant components involved in search: the search-api application, and the AWS-managed Elasticsearch cluster powering it.

Useful metrics to look at are:

- Request duration from finder-frontend to search-api and request duration from search-api to Elasticsearch, both on the [Search API / Elasticsearch SLIs dashboard](https://grafana.blue.production.govuk.digital/dashboard/file/search_api_elasticsearch.json?orgId=1).

    If the search-api to Elasticsearch duration has increased, then there may be a capacity issue with Elasticsearch.  If only the finder-frontend to search-api duration has increased, then there may be a capacity issue with search-api.

- The [machine dashboard](https://grafana.blue.production.govuk.digital/dashboard/file/machine.json?refresh=1m&orgId=1) for search.

- The [AWS dashboard for Elasticsearch](https://eu-west-1.console.aws.amazon.com/es/home?region=eu-west-1#domain:resource=blue-elasticsearch5-domain;action=dashboard) in the AWS console.

    There are a lot of metrics here.  A capacity issue could be suggested by the "Index thread pool" or "Search thread pool" graphs being consistently above the red dashed line, which means that requests are queueing.  Talk to RE in that case.
