---
owner_slack: "#govuk-2ndline"
title: Sidekiq
parent: "/manual.html"
layout: manual_layout
section: Monitoring
last_reviewed_on: 2019-01-04
review_in: 6 months
---

Many of our applications use
[Sidekiq](https://github.com/mperham/sidekiq) for background job
processing.

There's a [GOV.UK wrapper](https://github.com/alphagov/govuk_sidekiq)
that will help you set it up.

If an alert fires a good place to start investigation is the [Sidekiq
monitor](monitor-sidekiq-workers.html).

## Retry logic

Sidekiq has in built retry logic (turned on by default, but
configurable). Middleware is used to send metrics (successes,
failures, job timings and retry counts) to statsd, which forwards the
data to Graphite to be stored. Information about viewing this can be
found on the [Monitor Sidekiq workers](monitor-sidekiq-workers.html)
page.

Jobs do fail, this is not inherently bad and can happen for a number
of reasons. When a job fails it gets retried with an exponential
backoff (up to 21 days), as long as retries are enabled. A high number
of retries signifies a bigger, less transient problem maybe occuring.
