---
owner_slack: "#govuk-searchandnav"
title: Debug underperforming search
section: Monitoring
layout: manual_layout
parent: "/manual.html"
---

Search is one of the more load-sensitive parts of GOV.UK, as it can't
be cached as effectively as more static pages.  There are two
significant components involved in search: the search-api application,
and the AWS-managed Elasticsearch cluster powering it.

Useful metrics to look at are:

- Request duration from finder-frontend to search-api, on the [finder-frontend app dashboard](https://grafana.blue.production.govuk.digital/dashboard/file/finder-frontend.json?refresh=5s&orgId=1)

    If this has increased then there may be a capacity issue with
    search-api.

- Request duration from search-api to Elasticsearch and SageMaker, on the [search-api app dashboard](https://grafana.blue.production.govuk.digital/dashboard/file/search-api.json?refresh=5s&orgId=1)

    See the "`<thing>` req count vs latency" graphs:

  - **Reranker:** if this has increased, queries sorted by relevance
    (keyword searches) will be slower.  This could indicate a
    performance issue with SageMaker.

  - **Search:** if this has increased, all queries will be slower.
    This could indicate a performance issue with Elasticsearch.

  - **Spelling suggestion:** if this has increased, finder-frontend
    pages will be slower.  Other search-powered pages, like taxon
    pages, would not be affected.  This could indicate a performance
    issue with Elasticsearch.

- The [machine dashboard](https://grafana.blue.production.govuk.digital/dashboard/file/machine.json?refresh=1m&orgId=1) for search.

- The [AWS dashboard for Elasticsearch](https://eu-west-1.console.aws.amazon.com/es/home?region=eu-west-1#domain:resource=blue-elasticsearch6-domain;action=dashboard) in the AWS console.

    There are a lot of metrics here.  A capacity issue could be
    suggested by the "Index thread pool" or "Search thread pool"
    graphs being consistently above the red dashed line, which means
    that requests are queueing.  Talk to RE in that case.

- The [AWS dashboard for SageMaker](https://eu-west-1.console.aws.amazon.com/sagemaker/home?region=eu-west-1#/endpoints/govuk-production-search-ltr-endpoint) in the AWS console.

    A capacity issue could be suggested by the CPU utilisation graph
    being constantly close to 100%.
