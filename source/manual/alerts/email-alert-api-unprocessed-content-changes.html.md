---
owner_slack: "#govuk-2ndline"
title: 'Email Alert API: Unprocessed content changes'
section: Icinga alerts
subsection: Email alerts
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2020-07-09
review_in: 6 months
---

This means that there are some emails informing users of content changes
which haven't been processed within the time we would expect.
This may be fine and the emails will eventually go out, but it's worth some investigation.

### Icinga checks

* `warning` - `content_changes` unprocessed for over 90 minutes
* `critical` - `content_changes` unprocessed for over 120 minutes

See the [ProcessContentChangeAndGenerateEmailsWorker][content-change-worker] for
more information.

### Useful queries

First, enter an Email Alert Api Rails console:

```bash
$ gds govuk connect app-console -e production email-alert-api
```

#### Check which content changes are affected

```ruby
ContentChange.where("created_at < ?", 120.minutes.ago).where(processed_at: nil)
```

#### Check number of subscription contents built for a content change (you would expect this number to keep going up)

```ruby
SubscriptionContent.where(content_change: content_change).count
```

#### Resend the emails for a content change (ignore ones that have already gone out)

```ruby
ProcessContentChangeAndGenerateEmailsWorker.new.perform(content_change.id)
```

#### Resend the emails for a content change in bulk (ignore ones that have already gone out)

```ruby
ContentChange.where("created_at < ?", 120.minutes.ago).where(processed_at: nil).map { |content_change| ProcessContentChangeAndGenerateEmailsWorker.new.perform(content_change.id)  }
```

### Useful rake tasks

#### Check sent, pending and failed email counts for a content change

- [content_change_email_status_count][]

#### Check failed email ids and failure reasons for a content change

- [content_change_failed_emails][]

#### Resend failed emails by email ids

- [resend_failed_emails:by_id][]

#### Resend failed emails by date range

- [resend_failed_emails:by_date][]

### Still stuck?

Read [email troubleshooting].

[content-change-worker]: https://github.com/alphagov/email-alert-api/blob/master/app/workers/process_content_change_and_generate_emails_worker.rb
[email troubleshooting]: /manual/email-troubleshooting.html
[content_change_email_status_count]: https://deploy.blue.production.govuk.digital/job/run-rake-task/parambuild/?TARGET_APPLICATION=email-alert-api&MACHINE_CLASS=email_alert_api&RAKE_TASK=report:content_change_email_status_count['one_required_content_change_id','optional_second_content_change_id','and_so_on']
[content_change_failed_emails]: https://deploy.blue.production.govuk.digital/job/run-rake-task/parambuild/?TARGET_APPLICATION=email-alert-api&MACHINE_CLASS=email_alert_api&RAKE_TASK=report:content_change_failed_emails['one_required_content_change_id','optional_second_content_change_id','and_so_on']
[resend_failed_emails:by_id]: https://deploy.blue.production.govuk.digital/job/run-rake-task/parambuild/?TARGET_APPLICATION=email-alert-api&MACHINE_CLASS=email_alert_api&RAKE_TASK=troubleshoot:resend_failed_emails:by_id['some-id,%20another-id']
[resend_failed_emails:by_date]: https://deploy.blue.production.govuk.digital/job/run-rake-task/parambuild/?TARGET_APPLICATION=email-alert-api&MACHINE_CLASS=email_alert_api&RAKE_TASK=troubleshoot:resend_failed_emails:by_date[%272020-01-01T10:00:00Z,%202020-01-01T11:00:00Z%27]
