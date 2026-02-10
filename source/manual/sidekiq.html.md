---
owner_slack: "#govuk-developers"
title: Sidekiq
parent: "/manual.html"
layout: manual_layout
section: Monitoring and alerting
type: learn
---

Many of our applications use [Sidekiq](https://sidekiq.org) ([see repo](https://github.com/sidekiq/sidekiq)) for background job processing.

## Sidekiq on GOV.UK

For redundancy, our publishing apps run on multiple containers (using Kubernetes).
We would have all sorts of race conditions and difficulties querying Sidekiq if each app on each machine had its own instance of Sidekiq.

Therefore, we've build a GOV.UK wrapper for Sidekiq, called [govuk_sidekiq](https://github.com/alphagov/govuk_sidekiq). This allows all Sidekiq processes to talk to a single Redis instance. It also enables [request tracing](/manual/request-tracing.html).

## Retry logic

Sidekiq has in built retry logic (turned on by default, but configurable).

Jobs do fail, but this is not inherently bad and can happen for a number of reasons. When a job fails it gets [retried with an exponential backoff](https://github.com/sidekiq/sidekiq/wiki/Error-Handling#automatic-job-retry) (up to 21 days), as long as retries are enabled. A high number of retries signifies a bigger, less transient problem maybe occurring.

## Monitoring

There are three approaches for monitoring Sidekiq:

- via the [Grafana dashboard](#sidekiq-grafana-dashboard)
- via the [Rails console](#sidekiq-from-the-console)
- via the [Sidekiq Web interface](#sidekiq-web) (for apps that have implemented it)

### Sidekiq Grafana Dashboard

You can monitor Sidekiq queue lengths using the "Sidekiq: queue length, max delay" dashboard, which is available in all environments:

- [Integration](https://grafana.eks.integration.govuk.digital/d/sidekiq-queues/sidekiq3a-queue-length-max-delay)
- [Staging](https://grafana.eks.staging.govuk.digital/d/sidekiq-queues/sidekiq3a-queue-length-max-delay)
- [Production](https://grafana.eks.production.govuk.digital/d/sidekiq-queues/sidekiq3a-queue-length-max-delay)

### Sidekiq from the console

Sidekiq [exposes a rich API](https://github.com/sidekiq/sidekiq/wiki/API) which can be queried from the rails console.

The `Stats` class gives a nice overview:

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

You can do things like find and delete workers:

```ruby
Sidekiq::RetrySet.new.filter { |job| job.klass == "AssetManagerAttachmentMetadataWorker" }.map(&:delete)
```

Be mindful that you may want to delete from both the 'scheduled' and 'retries' queues:

```
Sidekiq::Queue.new("default").filter { |job| job.delete if (job.klass == "PresentPageToPublishingApiWorker" && job.args.first == "PublishingApi::EmbassiesIndexPresenter") }
Sidekiq::RetrySet.new.filter { |job| job.delete if(job.klass == "PresentPageToPublishingApiWorker" && job.args.first == "PublishingApi::EmbassiesIndexPresenter") }
```

### Sidekiq Web

Sidekiq comes with a web application, [`Sidekiq::Web`][sidekiq web] that can display the current state of Sidekiq's queues for an application.
It needs to be configured and enabled on a per-app basis ([example](https://github.com/alphagov/whitehall/pull/8026)).

Sidekiq web is enabled for the following applications (and requires a Sidekiq Admin permission being set in the relevant app in Signon):

| Application           | Sidekiq Web URL                                                   |
|-----------------------|-------------------------------------------------------------------|
| Publisher             | https://publisher.publishing.service.gov.uk/sidekiq               |
| Whitehall             | https://whitehall-admin.publishing.service.gov.uk/sidekiq         |
| Content Block Manager | https://content-block-manager.publishing.service.gov.uk/sidekiq   |

To add Sidekiq Web to an application, you can use the `GovukSidekiq::GdsSsoMiddleware` class in the `govuk_sidekiq`
gem. See the [govuk_sidekiq README](https://github.com/alphagov/govuk_sidekiq?tab=readme-ov-file#sidekiq-web-ui) for
more details.

Apps that don't have any ingress routes are accessed through port forwarding. Detailed instructions on how to do this will
be in the relevant readme files for the following applications that have the Sidekiq Web UI enabled in this way:

| Application    | Documentation URL                                                                               |
|----------------|-------------------------------------------------------------------------------------------------|
| Asset Manager  | https://github.com/alphagov/asset-manager?tab=readme-ov-file#viewing-the-sidekiq-ui             |
| Email Alert API| https://docs.publishing.service.gov.uk/repos/email-alert-api/sidekiq-web.html                   |
| Publishing API | https://github.com/alphagov/publishing-api/blob/main/docs/admin-tasks.md#viewing-the-sidekiq-ui |

NB, GOV.UK used to have a [sidekiq-monitoring web app][sidekiq monitoring] which monitored all GOV.UK Sidekiq configurations in one place, but this was removed when GOV.UK was replatformed to Kubernetes.

[sidekiq web]: https://github.com/sidekiq/sidekiq/wiki/Monitoring
[sidekiq monitoring]: https://github.com/alphagov/sidekiq-monitoring
