---
owner_slack: "#govuk-2ndline"
title: High Search API Sidekiq queue latency
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2019-03-26
review_in: 6 months
---

[Search API](/apps/search-api.html) uses Sidekiq to offload indexing work.

This alert triggers when there are jobs in the Sidekiq queue that are waiting
too long to be processed. This could mean that documents aren't appearing
in search after they've been published.

## Investigating the issue

The issue could be caused by a temporary spike in publishing activity, or
something being wrong with Search API.

You can [check the Sidekiq Grafana dashboard for Search API](https://grafana.production.govuk.digital/dashboard/file/sidekiq.json?refresh=1m&orgId=1&var-Application=search-api&var-Queues=All). Take a look at the "Retry set size" - this could mean that jobs are failing. You can then look at [Sentry](/manual/error-reporting.html) or [Sidekiq web](https://docs.publishing.service.gov.uk/manual/monitor-sidekiq-workers.html) to see what's going on.
