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

There are three approaches for monitoring Sidekiq, via the [Sidekiq Web interface](#sidekiq-web),
or the [Grafana dashboard](#sidekiq-grafana-dashboard) or the [Console](#sidekiq-from-the-console).

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

or using `govuk-connect`:

```bash
$ brew install alphagov/gds/govuk-connect
$ gds govuk connect sidekiq-monitoring -e production aws/backend 
```

Then visit [http://127.0.0.1:9000](http://127.0.0.1:9000) to see a list of
[Sidekiq] configurations you can monitor.

### Sidekiq Grafana Dashboard

You can also monitor Sidekiq queue lengths using [this Grafana
dashboard](https://grafana.publishing.service.gov.uk/dashboard/file/sidekiq.json). It
is available in all environments.

See also: [Add sidekiq-monitoring to your application](setting-up-new-sidekiq-monitoring-app.html).

[gov.uk]: https://www.gov.uk
[sidekiq]: http://sidekiq.org

### Sidekiq from the console

Where possible you should use Sidekiq's web interface or Grafana to view Sidekiq
stats and queues. SSHing into machines to interrogate things should be a last
resort.

Sidekiq can be queried from the rails console. It exposes a `Stats`
class that you can query:

```
Sidekiq::Stats.new

# => #<Sidekiq::Stats:0x00007fbdf0ac4a30 @stats={:processed=>114999987, :failed=>15129, :scheduled_size=>22741, :retry_size=>1, :dead_size=>0, :processes_size=>3, :default_queue_latency=>10162.526781797409, :workers_size=>90, :enqueued=>1508687}>

Sidekiq::Stats.new.queues

# => {"delivery_immediate_high"=>949953, "default"=>451201, "delivery_immediate"=>101006, "email_generation_immediate"=>0, "email_generation_digest"=>0, "cleanup"=>0, "process_and_generate_emails"=>0, "delivery_digest"=>0}

```

You can also query and iterate through the Queues directly:

```
Sidekiq::Queue.all

# => [#<Sidekiq::Queue:0x00007fe98b133590 @name="cleanup", @rname="queue:cleanup">, #<Sidekiq::Queue:0x00007fe98b133518 @name="default", @rname="queue:default">, etc...

Sidekiq::Queue.all.collect {|q| [q.name, q.size] }

# => [["cleanup", 0], ["default", 0], ["delivery_digest", 0], ["delivery_immediate", 0], ["delivery_immediate_high", 0], ["email_generation_digest", 0], ["process_and_generate_emails", 0]]
```

## Retry logic

Sidekiq has in built retry logic (turned on by default, but configurable).
Middleware is used to send metrics (successes, failures, job timings and retry
counts) to `statsd`, which forwards the data to Graphite to be stored.

Jobs do fail, this is not inherently bad and can happen for a number of
reasons. When a job fails it gets retried with an exponential backoff (up to 21
days), as long as retries are enabled. A high number of retries signifies a
bigger, less transient problem maybe occurring.
