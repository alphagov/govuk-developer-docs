---
owner_slack: "#govuk-developers"
title: Sidekiq
parent: "/manual.html"
layout: manual_layout
section: Monitoring
type: learn
last_reviewed_on: 2019-07-14
review_in: 6 months
---

Many of our applications use
[Sidekiq](https://github.com/mperham/sidekiq) for background job processing.

There's a [GOV.UK wrapper](https://github.com/alphagov/govuk_sidekiq) that will
help you set it up.

## Monitoring

There are two approaches for monitoring Sidekiq, via the Sidekiq Web interface,
or the Grafana dashboard.

### Sidekiq Web

[Sidekiq] comes with a web application,
[`Sidekiq::Web`](https://github.com/mperham/sidekiq/wiki/Monitoring)
that can display the current state of a [Sidekiq] installation. We have
[configured this](https://github.com/alphagov/sidekiq-monitoring) to monitor
multiple [Sidekiq] configurations used throughout [GOV.UK].

We have restricted public access as the Web UI allows modifying the state of
[Sidekiq] queues.

To gain access you should setup SSH port forwarding to a backend box belonging
to the environment you wish to monitor when connected to the office wireless
network or the VPN:

```bash
$ ssh backend-1.backend.staging -CNL 9000:127.0.0.1:3211
```

Or on AWS:

```bash
$ ssh $(ssh integration "govuk_node_list --single-node -c backend").integration -CNL 9000:127.0.0.1:3211
```

Then visit [http://127.0.0.1:9000](http://127.0.0.1:9000) to see a list of
[Sidekiq] configurations you can monitor.

#### Local use

To view your local Sidekiq queue, go to the [sidekiq-monitoring
app](https://github.com/alphagov/sidekiq-monitoring) in the vm and run
`./bin/foreman start` for all applications, or `./bin/foreman
run <app_name>` for a specific app.

Then visit:

* [`http://sidekiq-monitoring.dev.gov.uk:3211/`](http://sidekiq-monitoring.dev.gov.uk:3211/)
to see a list of all the GOV.UK applications whose Sidekiq status you
can monitor
* `http://sidekiq-monitoring.dev.gov.uk/<app_name>` to directly
monitor a specific app

### Sidekiq Grafana Dashboard

You can also monitor Sidekiq queue lengths using [this Grafana
dashboard](https://grafana.publishing.service.gov.uk/dashboard/file/sidekiq.json). It
is available in all environments.

See also: [Add sidekiq-monitoring to your application](setting-up-new-sidekiq-monitoring-app.html).

[gov.uk]: https://www.gov.uk
[sidekiq]: http://sidekiq.org

## Retry logic

Sidekiq has in built retry logic (turned on by default, but configurable).
Middleware is used to send metrics (successes, failures, job timings and retry
counts) to `statsd`, which forwards the data to Graphite to be stored.

Jobs do fail, this is not inherently bad and can happen for a number of
reasons. When a job fails it gets retried with an exponential backoff (up to 21
days), as long as retries are enabled. A high number of retries signifies a
bigger, less transient problem maybe occurring.
