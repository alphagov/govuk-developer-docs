---
owner_slack: "#govuk-2ndline-tech"
title: High Search API Sidekiq queue latency
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

[Search API](/repos/search-api.html) uses Sidekiq to offload indexing work.

This alert triggers when there are jobs in the Sidekiq queue that are waiting
too long to be processed. This could result in documents being published not appearing in search results.

## Investigating the issue

The issue could be caused by a temporary spike in publishing activity, or
something being wrong with Search API.

You can check the Sidekiq Grafana dashboard for Search API
([integration][search-api-grafana-integration],
[staging][search-api-grafana-staging],
[production][search-api-grafana-production]). Take a look at the "Retry set
size" - this could mean that jobs are failing. You can then look at
[Sentry][sentry] or [Sidekiq web][sidekiq-web] to see what's going on.

[search-api-grafana-production]: https://grafana.production.govuk.digital/dashboard/file/sidekiq.json?refresh=1m&orgId=1&var-Application=search-api&var-Queues=All
[search-api-grafana-staging]: https://grafana.staging.govuk.digital/dashboard/file/sidekiq.json?refresh=1m&orgId=1&var-Application=search-api&var-Queues=All
[search-api-grafana-integration]: https://grafana.integration.govuk.digital/dashboard/file/sidekiq.json?refresh=1m&orgId=1&var-Application=search-api&var-Queues=All
[sentry]: /manual/error-reporting.html
[sidekiq-web]: /manual/sidekiq.html#sidekiq-web-aka-sidekiq-monitoring
