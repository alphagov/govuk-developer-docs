---
title: 'Sidekiq Retries'
parent: /manual.html
layout: manual_layout
section: Alerts
---

# Sidekiq Retries

Many of our applications use
[Sidekiq](https://github.com/mperham/sidekiq) for background job
processing. Sidekiq has in built retry logic (turned on by default, but
configurable). We graph Sidekiq job stats: successes, failures, job
timings and retry counts. These can be found under the statsd Graphite
namespace. i.e.:

    stats.gauges.govuk.app.support.workers.retry_set_size

    stats.govuk.app.whitehall.workers.SearchIndexAddWorker.failure

Jobs do fail, this is not inherently bad and can happen for a number of
reasons. When a job fails it gets retried with an exponential backoff
(up to 21 days), as long as retries are enabled. A high number of
retries signifies a bigger, less transient problem maybe occuring, and
hence we alert on it. If this alert fires a good place to start
investigation is the [Sidekiq
monitor](applications/sidekiq-monitoring.html).

