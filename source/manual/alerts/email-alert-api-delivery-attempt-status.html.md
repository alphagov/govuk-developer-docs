---
owner_slack: "#govuk-2ndline"
title: 'Email Alert API: High number of delivery attempts'
section: Icinga alerts
subsection: Email alerts
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2020-07-16
review_in: 6 months
---

The first thing to do is determine what kind of failure is affecting the
delivery attempts.

## Internal failures (`internal_failure`)

This means that we’ve failed to make a request to Notify within the last hour
due to a problem in our code. The reason for this failure should be visible in
Sentry.

## Technical failures (`technical_failure`)

This means that we’ve received a technical failure status code back from Notify
or a request to send an email via Notify failed within the last hour. This
means that there may be a problem with our system or that Notify is unable to
send emails.

Emails given a `technical_failure` status will **not** be retried automatically.
To retry these you will need to use the [resend tasks].

In non-production environments, this failure may also mean that we’re
attempting to send emails to people who are not members of the Notify team for
the relevant environment.

In this case, ensure the contents of the
`govuk::apps::email_alert_api::email_address_override_whitelist` key in
[hieradata][] and [hieradata_aws][] matches the members of the
staging/integration Notify teams.

You can login to the Notify account by going to the
[GOV.UK Notify Admin Interface][notify]. The login credentials are in the
[2nd line password store][password-store] under
`govuk-notify/2nd-line-support`.

## Still stuck?

Read [email troubleshooting].

[email troubleshooting]: /manual/email-troubleshooting.html
[notify]: https://www.notifications.service.gov.uk
[hieradata]: https://github.com/alphagov/govuk-puppet/blob/master/hieradata/common.yaml
[hieradata_aws]: https://github.com/alphagov/govuk-puppet/blob/master/hieradata_aws/common.yaml
[password-store]: https://github.com/alphagov/govuk-secrets/tree/master/pass/2ndline/govuk-notify
[resend tasks]: /apis/email-alert-api/support-tasks.html#resend-failed-emails
