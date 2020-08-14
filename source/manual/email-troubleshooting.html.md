---
owner_slack: "#govuk-developers"
title: "Email troubleshooting"
section: Emails
type: learn
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2020-05-14
review_in: 6 months
---

This document has tips for troubleshooting unsent emails. For an overview of our
email architecture, read [Email notifications: how they work](/manual/email-notifications-how-they-work.html).

## General troubleshooting tips

### Check the current health of the ecosystem

You can check the [Email Alert API Technical dashboard][dashboard] to monitor
if emails are going out.

### Check that Notify sent the email

Log in to the Notify account by going to <https://www.notifications.service.gov.uk>.
The login credentials are in the [2nd line password store][password-store] under
`govuk-notify/2nd-line-support`. Two-factor authentication links for logging in are
sent to the 2nd line email address.

Click "GOV.UK Email" to visit the dashboard, then click on "emails sent", which
will take you to a form where you can search by email address.

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

[dashboard]: https://grafana.production.govuk.digital/dashboard/file/email_alert_api_technical.json?refresh=10s&orgId=1
[google-group]: https://groups.google.com/a/digital.cabinet-office.gov.uk/forum/#!forum/govuk-email-courtesy-copies
[password-store]: https://github.com/alphagov/govuk-secrets/tree/master/pass/2ndline/govuk-notify
