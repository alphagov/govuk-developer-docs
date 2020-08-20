---
owner_slack: "#govuk-developers"
title: "Email troubleshooting"
section: Emails
type: learn
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2020-08-14
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

> **Note**
>
> Courtesy copies are sent separately to normal emails. Therefore, it is not
> safe to rely on the courtesy copy Google Group to guarantee that emails
> are being sent to subscribers, and instead a better test is to
> subscribe yourself and check that emails arrive.

[dashboard]: https://grafana.production.govuk.digital/dashboard/file/email_alert_api_technical.json?refresh=10s&orgId=1
[google-group]: https://groups.google.com/a/digital.cabinet-office.gov.uk/forum/#!forum/govuk-email-courtesy-copies
[password-store]: https://github.com/alphagov/govuk-secrets/tree/master/pass/2ndline/govuk-notify
