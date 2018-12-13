---
owner_slack: "#govuk-2ndline"
title: email-alert-api app healthcheck not ok
section: Icinga alerts
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-08-31
review_in: 6 months
---

If there is a health check error showing for Email Alert API, you can click on the alert to find out more details about what’s wrong. Here are the possible problems you may see:

## Unprocessed content changes (content_changes)

This means that there are some content changes which haven't been processed within the time we would expect. This may be fine and the emails will eventually go out, but it's worth some investigation. Some useful queries:

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
SubscriptionContentWorker.new.perform(content_change.id)
```

## Unprocessed digest runs (digest_runs)

This means that there are some digest runs which haven't been processed within the time we would expect. Some useful queries:

#### Check which digest runs are affected

```ruby
DigestRun.where("created_at < ?", 1.hour.ago).where(completed_at: nil)
```

## High queue size (queue_size)

This means that there are a high number of items in the queue. This may indicate a problem down the line which is preventing workers from being processed. It may also imply the threshold is too low if a large number of emails have being sent out due to a content change.

## High queue latency (queue_latency)

This means the time it takes for a job to be processed is unusually high. This may indicate a problem down the line which is preventing workers from being processed. It may also imply the threshold is too low if a large number of emails have being sent out due to a content change.

## High retry queue size (retry_size)

This means there are a high number of items in the retry queue. The Email Alert API relies on the retry queue for rate limiting, so it’s not unusual to see items in the queue, but if it is very high it suggests that there may be a problem down the line which is preventing jobs from being processed. It may also imply the threshold is too low if a large number of emails have been sent out due to a content change.

## Status updates (status_update)

This means that we haven’t received status updates from Notify on some emails and it’s been 72 hours since the emails were sent out. This could mean there is a problem with our system, or there could be a problem with Notify.

## Subscription contents without emails (subscription_content)

This means that there are subscription contents being created without emails associated with them, this implies that emails aren't being sent out. Some useful queries:

#### Check which subscription contents this affects

```ruby
SubscriptionContent.where("subscription_contents.created_at < ?", 1.minute.ago).where(email: nil).joins(:subscription).merge(Subscription.active)
```

## Technical failures (technical_failure)

This means that we’ve received a technical failure status code back from Notify or a request to send an email via Notify failed within the last hour. This means that there may be a problem with our system or that Notify is unable to send emails.

In non-production environments, this failure may also mean that we’re attempting to send emails to people who are not members of the Notify team for the relevant environment.

In this case, ensure the contents of the  `govuk::apps::email_alert_api::email_address_override_whitelist` key in [hieradata](https://github.com/alphagov/govuk-puppet/blob/master/hieradata/common.yaml) and [hieradata_aws](https://github.com/alphagov/govuk-puppet/blob/master/hieradata_aws/common.yaml) matches the members of the staging/integration Notify teams.

You can login to the Notify account by going to the [GOV.UK Notify Admin Interface](https://www.notifications.service.gov.uk).
The login credentials are in the [2nd line password store][password-store] under `govuk-notify/2nd-line-support`.

[password-store]: https://github.com/alphagov/govuk-secrets/tree/master/pass/2ndline/govuk-notify
