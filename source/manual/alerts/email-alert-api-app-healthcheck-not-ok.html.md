---
owner_slack: "#govuk-2ndline"
title: email-alert-api app healthcheck not ok
section: Icinga alerts
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-09-27
review_in: 6 months
---

If there is a health check error showing for Email Alert API, you can click on
the alert to find out more details about what’s wrong. Here are the possible
problems you may see:

Some of the alerts below tend to trigger when emails are sent out. Check to see
if emails have sent out by looking at the
[Email Alert API Metrics Grafana dashboard][dashboard].

This affects the following alerts:

* Unprocessed content changes
* Subscription content
* High queue alerts (all)
* Subscription content

In this case you can wait until the emails have all been sent out.

## Unprocessed content changes (content_changes)

This means that there are some content changes which haven't been processed
within the time we would expect. This may be fine and the emails will
eventually go out, but it's worth some investigation. Some useful queries and
Rake tasks:

#### Check which content changes are affected

```ruby
ContentChange.where("created_at < ?", 10.minutes.ago).where(processed_at: nil)
```

#### Check number of subscription contents built for a content change (you would expect this number to keep going up)

```ruby
SubscriptionContent.where(content_change: content_change).count
```

#### Resend the emails for a content change (ignore ones that have already gone out)

```ruby
ProcessContentChangeWorker.new.perform(content_change.id)
```

#### Resend the emails for a content change in bulk (ignore ones that have already gone out)

```ruby
ContentChange.where("created_at < ?", 10.minutes.ago).where(processed_at: nil).map { |content_change| ProcessContentChangeWorker.new.perform(content_change.id)  }
```

#### Check sent, pending and failed email counts for a content change

```sh
 $ bundle exec rake report:content_change_email_status_count[<content_change_id>]
```

#### Check failed email ids and failure reasons for a content change

```sh
 $ bundle exec rake report:content_change_failed_emails[<content_change_id>]
```

## Unprocessed digest runs (digest_runs)

This means that there are some digest runs which haven't been processed within
the time we would expect. Some useful queries:

#### Check which digest runs are affected

```ruby
DigestRun.where("created_at < ?", 1.hour.ago).where(completed_at: nil)
```

## High queue size (queue_size)

This means that there are a high number of items in the queue. This may
indicate a problem down the line which is preventing workers from being
processed. It may also imply the threshold is too low if a large number of
emails have being sent out due to a content change.

## High queue latency (queue_latency)

This means the time it takes for a job to be processed is unusually high. This
may indicate a problem down the line which is preventing workers from being
processed. It may also imply the threshold is too low if a large number of
emails have being sent out due to a content change.

## High retry queue size (retry_size)

This means there are a high number of items in the retry queue. The Email Alert
API relies on the retry queue for rate limiting, so it’s not unusual to see
items in the queue, but if it is very high it suggests that there may be a
problem down the line which is preventing jobs from being processed. It may
also imply the threshold is too low if a large number of emails have been sent
out due to a content change.

## Status updates (status_update)

This means that we haven’t received status updates from Notify on some emails
and it’s been 72 hours since the emails were sent out. This could mean there is
a problem with our system, or there could be a problem with Notify.

## Subscription contents without emails (subscription_content)

This means that there are subscription contents being created without emails
associated with them, this implies that emails aren't being sent out. Some
useful queries:

#### Check which subscription contents this affects

```ruby
SubscriptionContent.where("subscription_contents.created_at < ?", 1.minute.ago).where(email: nil).joins(:subscription).merge(Subscription.active)
```

Check the count, then run the above query again to see if the count has
decreased. If it's decreasing, then it means that emails are going out and
there's probably a lot being processed. You can also check the
[Email Alert API Metrics dashboard][dashboard].

[dashboard]: https://grafana.publishing.service.gov.uk/dashboard/file/email_alert_api.json?refresh=10s&orgId=1
