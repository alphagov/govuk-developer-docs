---
owner_slack: "#govuk-2ndline"
title: 'Email Alert API: Unprocessed work'
section: Icinga alerts
subsection: Email alerts
layout: manual_layout
parent: "/manual.html"
---

This alert indicates that Email Alert API has work that has not been processed in the generous amount of time we expect it to have been. Which alert you see depends on the type of work.

* **[`unprocessed content changes`](https://github.com/alphagov/email-alert-api/blob/master/app/workers/process_content_change_worker.rb)**.

  * This means there is a signficiant delay in generating emails for subscribers with "immediate" frequency subscriptions in response to [a change in some content] on GOV.UK.

* **[`unprocessed messages`](https://github.com/alphagov/email-alert-api/blob/master/app/workers/process_message_worker.rb)**.

  * This means there is a significant delay in generating emails for subscribers with "immediate" frequency subscriptions in response to [a custom message].

* **`incomplete digest runs`**.

  * This could be due to a failure in any of three workers:

    * [\[Daily/Weekly\]DigestInitiatorWorker](https://github.com/alphagov/email-alert-api/blob/a656389b1abdd46226ca37c1682c318f1c2eafee/app/workers/daily_digest_initiator_worker.rb) generates a DigestRunSubscriber work item for each subscriber.
    * [DigestEmailGenerationWorker](https://github.com/alphagov/email-alert-api/blob/a656389b1abdd46226ca37c1682c318f1c2eafee/app/workers/digest_email_generation_worker.rb) does the work of generating the digest email for a specific subscriber.
    * [DigestRunCompletionMarkerWorker](https://github.com/alphagov/email-alert-api/blob/a656389b1abdd46226ca37c1682c318f1c2eafee/app/workers/digest_run_completion_marker_worker.rb) periodically scans all the work items to see if the run is complete.

Each of the alerts is based on custom metrics that we collect using [a periodic job](https://github.com/alphagov/email-alert-api/blob/a656389b1abdd46226ca37c1682c318f1c2eafee/app/workers/metrics_collection_worker.rb). The metric will be something like "amount of unprocessed work older than X amount of time" ([example](https://github.com/alphagov/email-alert-api/blob/a656389b1abdd46226ca37c1682c318f1c2eafee/app/workers/metrics_collection_worker/content_change_exporter.rb#L16)).

## Automatic recovery

Sometimes we lose work due to [a flaw with the Sidekiq queueing system](https://github.com/mperham/sidekiq/wiki/Problems-and-Troubleshooting#my-sidekiq-process-is-crashing-what-do-i-do). In order to cope with this scenario, a [RecoverLostJobsWorker] runs every 30 minutes, and will try to requeue work that has not been processed [within an hour](https://github.com/alphagov/email-alert-api/blob/2f3931ac1ca25fe8c79b2405af98d1de55e1d47b/app/workers/recover_lost_jobs_worker/unprocessed_check.rb#L13). If work is being repeatedly lost, the alert will fire and you'll need to investigate manually.

## Manual steps to fix

Things to check:

* Check [Sentry] for errors.

* Check the [Sidekiq dashboard] for worker failures.

* Check [Kibana] for errors - use ```@fields.worker: <worker class>``` for the query.

* Check the [Email Alert API Technical dashboard] for performance issues.

If all else fails, you can try running the work manually from a console. [The automatic recovery worker](https://github.com/alphagov/email-alert-api/blob/2f3931ac1ca25fe8c79b2405af98d1de55e1d47b/app/workers/recover_lost_jobs_worker/unprocessed_check.rb#L13) code is a good example of how to do this, but you will need to use `new.perform` instead of `perform_async`.

> A digest run may be "complete" - all work items generated, all work items processed - but not marked as such. In this case, you will need to use slightly different commands to investigate the incomplete run:
>
> ```ruby
> # find which digests are "incomplete"
> DigestRun.where("created_at < ?", 1.hour.ago).where(completed_at: nil)
>
> # try manually marking it as complete
> DigestRunCompletionMarkerWorker.new.perform
> ```

[Sentry]: https://sentry.io/organizations/govuk/issues/?project=202220&statsPeriod=6h
[a custom message]: https://github.com/alphagov/email-alert-api/blob/master/docs/api.md#post-messages
[a change in some content]: https://github.com/alphagov/email-alert-api/blob/master/docs/api.md#post-content-changes
[Kibana]: https://kibana.logit.io/s/2dd89c13-a0ed-4743-9440-825e2e52329e/app/kibana#/discover?_g=(refreshInterval:(display:Off,pause:!f,value:0),time:(from:now-1h,mode:quick,to:now))&_a=(columns:!('@message',host),index:'*-*',interval:auto,query:(query_string:(query:'@type:%20sidekiq%20AND%20application:%20email-alert-api%20AND%20@fields.worker:%20ProcessContentChangeWorker')),sort:!('@timestamp',desc))
[RecoverLostJobsWorker]: https://github.com/alphagov/email-alert-api/blob/master/app/workers/recover_lost_jobs_worker.rb
[Sidekiq dashboard]: https://grafana.production.govuk.digital/dashboard/file/sidekiq.json?refresh=1m&orgId=1&var-Application=email-alert-api&var-Queues=All&from=now-3h&to=now
[Email Alert API Technical dashboard]: https://grafana.production.govuk.digital/dashboard/file/email_alert_api_technical.json?refresh=1m&orgId=1
