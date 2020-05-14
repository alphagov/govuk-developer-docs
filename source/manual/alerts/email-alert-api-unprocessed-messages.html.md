---
owner_slack: "#govuk-2ndline"
title: 'Email Alert API: Unprocessed messages'
section: Icinga alerts
subsection: Email alerts
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2020-01-07
review_in: 6 months
---

`Messages` are similar to [content changes][content-changes], introduced in
September 2019 to support the [GOV.UK Get ready for Brexit checker][brexit-checker].
It is intended to provide a means for applications to alert subscribers to ad hoc
events that may not be represented by a content change. See the [ADR for Messages][adr-messages] for more information.

This alert is triggered when these messages are not processed within the time we
would expect. This may be fine and the emails will eventually go out, but it's worth some investigation.

* `warning` - unprocessed `messages` created more than 5 minutes ago
* `critical` - unprocessed `messages` created more than 10 minutes ago

See the [ProcessMessageWorker][process-message-worker] for more information.

## Useful queries

### Check which messages this affects

```ruby
Message.where("created_at < ?", 5.minutes.ago).where(processed_at: nil)
```

Check the count, then run the above query again to see if the count has
decreased. If it's decreasing, then it means that emails are going out and
there's probably a lot being processed.
If it's not decreasing the Sidekiq worker might be stuck, see the [sidekiq][sidekiq]
section on how to view the Sidekiq queues.

### Check number of subscription contents built for a message (you would expect this number to keep going up)

```ruby
SubscriptionContent.where(message: message).count
```

### Resend the emails for a message (ignore ones that have already gone out)

```ruby
ProcessMessageWorker.new.perform(message.id)
```

### Resend the emails for a message in bulk (ignore ones that have already gone out)

```ruby
Message.where("created_at < ?", 10.minutes.ago).where(processed_at: nil).map { |message| ProcessMessageWorker.new.perform(message.id)  }
```

You can also check the [Email Alert API Metrics dashboard][dashboard] to monitor
if emails are going out and see the [general troubleshooting tips][troubleshooting]
section for more information.

[sidekiq]: /manual/sidekiq.html#sidekiq-web
[content-changes]: https://docs.publishing.service.gov.uk/manual/alerts/email-alert-api-unprocessed-content-changes.html
[brexit-checker]: https://www.gov.uk/get-ready-brexit-check
[adr-messages]: https://github.com/alphagov/email-alert-api/blob/master/doc/arch/adr-004-message-concept.md
[process-message-worker]: https://github.com/alphagov/email-alert-api/blob/master/app/workers/process_message_worker.rb
[dashboard]: https://grafana.production.govuk.digital/dashboard/file/email_alert_api.json?refresh=10s&orgId=1
[troubleshooting]: https://docs.publishing.service.gov.uk/manual/alerts/email-alert-api-app-healthcheck-not-ok.html#general-troubleshooting-tips
