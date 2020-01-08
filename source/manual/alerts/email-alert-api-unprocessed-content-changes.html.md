---
owner_slack: "#govuk-2ndline"
title: 'Email Alert API: Unprocessed content changes'
section: Icinga alerts
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2020-01-08
review_in: 6 months
---

This means that there are some emails informing users of content changes
which haven't been processed within the time we would expect.
This may be fine and the emails will eventually go out, but it's worth some investigation.

* `warning` - `content_changes` unprocessed for over 5 minutes
* `critical` - `content_changes` unprocessed for over 10 minutes

See the [ProcessContentChangeWorker][content-change-worker] for more information.

Some useful queries and Rake tasks:

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

[content-change-worker]: https://github.com/alphagov/email-alert-api/blob/master/app/workers/process_content_change_worker.rb
