---
owner_slack: "#govuk-2ndline"
title: email-alert-api app healthcheck not ok
section: Icinga alerts
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-12-03
review_in: 6 months
---

If there is a health check error showing for Email Alert API, you can click on
the alert to find out more details about what’s wrong. We've listed some common
problems and remedies later on in this document.

## You may not need to do anything

Some alerts tend to trigger when emails are sent out. Check to see if emails have
sent out by looking at the [Email Alert API Metrics Grafana dashboard][dashboard].

This affects the following alerts:
* High queue alerts (all)

In this case you can wait until the emails have all been sent out.

## General troubleshooting tips

### Check that Notify sent the email

Log in to the Notify account by going to <https://www.notifications.service.gov.uk>.
The login credentials are in the [2nd line password store][password-store] under
`govuk-notify/2nd-line-support`. Two-factor authentication links for logging in are
sent to the 2nd line email address.

From the dashboard, you can search by email address.

### Check the courtesy copy inbox

A courtesy copy of every email sent from integration, staging and production
is available in the ['govuk-email-courtesy-copies' Google Group][google-group].
Integration and staging emails have a subject prefixed by the
environment name.

If you need to test the process of subscribing to an email alert, you
can subscribe with `govuk-email-courtesy-copies@digital.cabinet-office.gov.uk`.
You should then see two copies of the email at that address when you
perform an action that triggers an email alert (the courtesy copy and
the subscriber one).

The process for triggering an alert varies by publishing application,
but it usually involves creating a new edition of some content, then
publishing it with a 'major' update type. The change note you enter
will appear in the email that gets sent.

> **Note**
>
> Due to the way that we send the courtesy copy emails and the
> anonymisation integration data sync, we can't fully exercise the code
> that matches content changes with subscriptions. Therefore, it is not
> safe to rely on the courtesy copy Google Group to guarantee that emails
> are being sent to subscribers, and instead a better test is to
> subscribe yourself and check that emails arrive.

## Check the email alert API

A useful debug step if you're not sure if an email has been sent is to
check Email Alert API to see if it has created records in its database.

```
$ govuk_app_console email-alert-api

# Note that we are not using `Email.last` because its primary key is `id`,
# which is a string and alphabetically ordered rather than by create date

> ContentChange.where(created_at: DateTime.now - 15.minutes...DateTime.now)
> Email.where(created_at: DateTime.now - 15.minutes...DateTime.now)
> DeliveryAttempt.where(created_at: DateTime.now - 15.minutes...DateTime.now)
```

Emails won't be sent if no one is subscribed, so you'll need to do that
first. The integration and staging environments only allow email to be
sent to a small number of email addresses so you cannot test using your
own email address in these environments.

## Common alerts

### Unprocessed digest runs (digest_runs)

This means that there are some digest runs which haven't been processed within
the time we would expect. Some useful queries:

#### Check which digest runs are affected

```ruby
DigestRun.where("created_at < ?", 1.hour.ago).where(completed_at: nil)
```

### High queue size (queue_size)

This means that there are a high number of items in the queue. This may
indicate a problem down the line which is preventing workers from being
processed. It may also imply the threshold is too low if a large number of
emails have being sent out due to a content change.

### High queue latency (queue_latency)

This means the time it takes for a job to be processed is unusually high. This
may indicate a problem down the line which is preventing workers from being
processed. It may also imply the threshold is too low if a large number of
emails have being sent out due to a content change.

### High retry queue size (retry_size)

This means there are a high number of items in the retry queue. The Email Alert
API relies on the retry queue for rate limiting, so it’s not unusual to see
items in the queue, but if it is very high it suggests that there may be a
problem down the line which is preventing jobs from being processed. It may
also imply the threshold is too low if a large number of emails have been sent
out due to a content change.

### Status updates (status_update)

This means that we haven’t received status updates from Notify on some emails
and it’s been 72 hours since the emails were sent out. This could mean there is
a problem with our system, or there could be a problem with Notify.

[dashboard]: https://grafana.staging.govuk.digital/dashboard/file/email_alert_api.json?refresh=10s&orgId=1
[google-group]: https://groups.google.com/a/digital.cabinet-office.gov.uk/forum/#!forum/govuk-email-courtesy-copies
[password-store]: https://github.com/alphagov/govuk-secrets/tree/master/pass/2ndline/govuk-notify
