---
owner_slack: "#govuk-developers"
title: Sidekiq
parent: "/manual.html"
layout: manual_layout
section: Monitoring
type: learn
---

Many of our applications use
[Sidekiq](https://sidekiq.org) ([see repo](https://github.com/mperham/sidekiq))
for background job processing.

## Sidekiq on GOV.UK

For redundancy, we have publishing apps running on multiple machines.
We would have all sorts of race conditions and difficulties querying
Sidekiq if each app on each machine had its own instance of Sidekiq.

Therefore, we've build a GOV.UK wrapper for Sidekiq, called
[govuk_sidekiq](https://github.com/alphagov/govuk_sidekiq). This
allows all Sidekiq processes to talk to a single Redis instance. It
also enables [request tracing](/manual/setting-up-request-tracing.html)
and sends activity stats to Statsd, which forwards data to Graphite
to be stored.

## Retry logic

Sidekiq has in built retry logic (turned on by default, but configurable).
Successes, failures, job timings and retry counts are sent to `statsd`.

Jobs do fail, this is not inherently bad and can happen for a number of
reasons. When a job fails it gets [retried with an exponential backoff](https://github.com/mperham/sidekiq/wiki/Error-Handling#automatic-job-retry)
(up to 21 days), as long as retries are enabled. A high number of retries
signifies a bigger, less transient problem maybe occurring.

## Monitoring

There are three approaches for monitoring Sidekiq:

- via the [Sidekiq Web interface](#sidekiq-web-aka-sidekiq-monitoring)
- via the [Grafana dashboard](#sidekiq-grafana-dashboard)
- via the [Console](#sidekiq-from-the-console)

### Sidekiq Web (aka Sidekiq Monitoring)

Sidekiq comes with a web application, [`Sidekiq::Web`][sidekiq web] that can
display the current state of Sidekiq's queues for an application. We have
configured this as the [sidekiq-monitoring web app][sidekiq monitoring] which
can monitor multiple Sidekiq configurations used throughout GOV.UK.

You can access each application's dashboard via a URL for:

- [Integration]
- [Staging]
- [Production]

[Integration]: https://sidekiq-monitoring.integration.govuk.digital/
[Staging]: https://sidekiq-monitoring.staging.govuk.digital/
[Production]: https://sidekiq-monitoring.production.govuk.digital/
[sidekiq web]: https://github.com/mperham/sidekiq/wiki/Monitoring
[sidekiq monitoring]: https://github.com/alphagov/sidekiq-monitoring

#### Set up Sidekiq Monitoring for your application

- Choose a port that isn't already taken for the Sidekiq Monitoring
  app to be served from.
- Add it to the [Procfile in the sidekiq-monitoring repository](https://github.com/alphagov/sidekiq-monitoring/blob/main/Procfile)
  maintaining the alphabetical order of the processes.
- Update
  [index.html](https://github.com/alphagov/sidekiq-monitoring/blob/main/public/index.html#L26-L29)
  to include a link to your application's sidekiq-monitoring maintaining the
  alphabetical order of the applications. This path is configured as a location
  under the sidekiq-monitoring vhost.
- Run `bundle exec foreman start` and test that your Rack and Redis config work
  as expected.

#### Configure the infrastructure

Add your application to the
[`govuk::apps::sidekiq_monitoring module`](https://github.com/alphagov/govuk-puppet/blob/master/modules/govuk/manifests/apps/sidekiq_monitoring.pp)
in Puppet, cross-referencing the
[Redis configuration](https://github.com/alphagov/govuk-puppet/commit/9ffa90f571a43cba1e341c359111bf18db9cde1a).

#### Configure a path under the sidekiq-monitoring vhost

The sidekiq-monitoring vhost in nginx has one location for every
sidekiq-monitoring application. Add one for your application in
[this puppet template](https://github.com/alphagov/govuk-puppet/blob/70a10190b/modules/govuk/templates/sidekiq_monitoring_nginx_config.conf.erb#L21-L23).

#### Test that the configuration works on Integration

Once changes are merged and deployed to Integration, you can
access your [sidekiq monitoring](monitor-sidekiq-workers.html) instance running
on Integration, and check that it works as expected.

### Sidekiq Grafana Dashboard

You can also monitor Sidekiq queue lengths using [this Grafana
dashboard](https://grafana.eks.production.govuk.digital/d/sidekiq-queues/sidekiq3a-queue-length-max-delay). It
is available in all environments.

### Sidekiq from the console

Where possible you should use Sidekiq's web interface or Grafana to view Sidekiq
stats and queues. SSHing into machines to interrogate things should be a last
resort.

Sidekiq [exposes a rich API](https://github.com/mperham/sidekiq/wiki/API) which can
be queried from the rails console.

The `Stats` class gives a nice overview.

```ruby
Sidekiq::Stats.new

# => #<Sidekiq::Stats:0x00007fbdf0ac4a30 @stats={:processed=>114999987, :failed=>15129, :scheduled_size=>22741, :retry_size=>1, :dead_size=>0, :processes_size=>3, :default_queue_latency=>10162.526781797409, :workers_size=>90, :enqueued=>1508687}>

Sidekiq::Stats.new.queues

# => {"delivery_immediate_high"=>949953, "default"=>451201, "delivery_immediate"=>101006, "email_generation_immediate"=>0, "email_generation_digest"=>0, "cleanup"=>0, "process_and_generate_emails"=>0, "delivery_digest"=>0}

```

You can also query and iterate through the `Queue`s directly:

```ruby
Sidekiq::Queue.all

# => [#<Sidekiq::Queue:0x00007fe98b133590 @name="cleanup", @rname="queue:cleanup">, #<Sidekiq::Queue:0x00007fe98b133518 @name="default", @rname="queue:default">, etc...

Sidekiq::Queue.all.collect {|q| [q.name, q.size] }

# => [["cleanup", 0], ["default", 0], ["delivery_digest", 0], ["delivery_immediate", 0], ["delivery_immediate_high", 0], ["email_generation_digest", 0], ["process_and_generate_emails", 0]]
```

Finally, you can do things like find and delete workers:

```ruby
Sidekiq::RetrySet.new.filter { |job| job.klass == "AssetManagerAttachmentMetadataWorker" }.map(&:delete)
```
