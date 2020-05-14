---
owner_slack: "#govuk-2ndline"
title: 'Email Alert API: Incomplete digest runs'
section: Icinga alerts
subsection: Email alerts
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2020-01-08
review_in: 6 months
---

### Incomplete digest runs (digest_runs)

This means that there are some digest runs which haven't been processed within
the time we would expect.

* `warning` - `digest_runs` unprocessed for over 20 minutes
* `critical` - `digest_runs` unprocessed for over 1 hour

See the [DigestEmailGenerationWorker][digest-email-generation-worker] for more information.

#### Check which digest runs are affected

```ruby
DigestRun.where("created_at < ?", 1.hour.ago).where(completed_at: nil)
```

Although the digest run failed, it could be that it was successful for the
majority of recipients and only one delivery failed. To get an idea of the
scale of the problem:

```ruby
digest_run = DigestRun.where("created_at < ?", 1.hour.ago).where(completed_at: nil).first

# check the number of subscribers on the digest run
digest_run.digest_run_subscribers.count

# check the number of subscribers where a success wasn't reported
digest_run.digest_run_subscribers.incomplete_for_run(digest_run.id).count
```

If it's only one or two digest run subscribers that failed, we can try
re-running the worker individually:

```ruby
digest_run_subscriber = digest_run.digest_run_subscribers.incomplete_for_run(digest_run.id).first
DigestEmailGenerationWorker.new.perform(digest_run_subscriber.id)
```

This should at least alert you to the issue. For example, you may see
this error:

> ActiveRecord::RecordNotUnique (PG::UniqueViolation: ERROR:  duplicate key value violates unique constraint "index_subscription_contents_on_subscription_and_content_change")
> DETAIL:  Key (subscription_id, content_change_id)=(ddee30d5-fe1f-42ca-bc33-1004c93a8625, cdbe3251-4bc7-436f-adff-8a778c74eb94) already exists.

You can use these values to dig in further:

```ruby
SubscriptionContent.find_by(subscription_id: "ddee30d5-fe1f-42ca-bc33-1004c93a8625", content_change_id: "cdbe3251-4bc7-436f-adff-8a778c74eb94").email
=> #<Email subject: "Update from GOV.UK – Somalia travel advice", body: "Update on GOV.UK.\n\n---\n[Somalia travel advice](htt...", created_at: "2020-03-16 12:04:00", updated_at: "2020-03-16 12:49:24", address: "REDACTED", id: "05576896-1b74-4c6f-9744-7657fd752b69", finished_sending_at: "2020-03-16 12:49:22", archived_at: "2020-03-16 13:31:57", subscriber_id: 1834366, status: "sent", failure_reason: nil, marked_as_spam: nil>
```

We can see in this example that the email was actually delivered
(`status: "sent"`), so the only thing that failed was marking the delivery
as complete. We can then resolve by:

```ruby
digest_run_subscriber.mark_complete!
digest_run.mark_complete!
```

You may also need to run `DigestRunWorker.new.perform` to re-send the counts
to statsd so that the alert gets removed from Icinga.

[digest-email-generation-worker]: https://github.com/alphagov/email-alert-api/blob/master/app/workers/digest_email_generation_worker.rb
