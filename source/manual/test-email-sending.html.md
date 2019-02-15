---
owner_slack: "#govuk-2ndline"
title: Test email sending
section: Emails
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-11-05
review_in: 6 months
---

A courtesy copy of all emails sent from the integration, staging and
production environments is sent to [a Google Group][google-group].
Integration and staging emails have a subject prefixed by the
environment name.

If you need to test the process of subscribing to an email alert, you
can subscribe with govuk-email-courtesy-copies@digital.cabinet-office.gov.uk.
You should then see two copies of the email at that address when you
perform an action that triggers an email alert (the courtesy copy and
the subscriber one).

The process for triggering an alert varies by publishing application,
but it usually involves creating a new edition of some content, then
publishing it with a 'major' update type. The change note you enter
will appear in the email that gets sent.

A useful debug step if you're not sure if an email has been sent is to
check Email Alert API to see if it has created records in its database.

```
$ govuk_app_console email-alert-api
> ContentChange.last
> Email.last
> DeliveryAttempt.last
```

Emails won't be sent if no one is subscribed, so you'll need to do that
first. The integration and staging environments only allow email to be
sent to a small number of email addresses so you cannot test using your
own email address in these environments.

> **Note**
>
> Due to the way that we send the courtesy copy emails and the
> anonymisation integration data sync, we can't fully exercise the code
> that matches content changes with subscriptions. Therefore, it is not
> safe to rely on the courtesy copy Google Group to guarantee that emails
> are being sent to subscribers, and instead a better test is to
> subscribe yourself and check that emails arrive.

[google-group]: https://groups.google.com/a/digital.cabinet-office.gov.uk/forum/#!forum/govuk-email-courtesy-copies
