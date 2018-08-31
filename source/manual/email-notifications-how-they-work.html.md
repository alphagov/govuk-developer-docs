---
owner_slack: "#govuk-2ndline"
title: "Email notifications: how they work"
section: Emails
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-08-02
review_in: 6 months
---

## High-level overview

The purpose of the email notifications system is to inform users when
content they are interested in is added to or changed on GOV.UK. Users
indicate their interest by subscribing to receive updates for an area of
interest (such as topic or government department).

The applications that comprise the email notifications system are:

### Email Alert API

* Stores the persistent data involved in email alerts, such as processed content changes, subscribers and their subscriptions.
* Provides an HTTP JSON API to alter stored data, such as: create alerts, set up lists and set up subscription preferences.
* Coordinates sending of notifications with the underlying email sending service, which is currently GOV.UK Notify.

### Email Alert Frontend

* Provides a user interface to sign up to a mailing list.
* Provides a user interface for a user to manage their subscriptions.
* Communicates with Email Alert API to make changes.

### Email Alert Service

* Listens to the Publishing API message queue.
* Communicates with Email Alert API when an appropriate Publishing API event occurs to trigger an alert. This is usually a ‘major’ edit to some content.

### GOV.UK Notify

* Used as a means to send emails.
* Does not know about subscribers or lists.

Other than these applications, a number of frontend and publishing apps
communicate with the service. Frontend applications use Email Alert API
to create new mailing lists and as a redirect destination for signing
up. Travel Advice Publisher and Specialist Publisher communicate
directly with Email Alert API to send alerts to have a greater degree of
control.

To have a near real-time overview of the status of data passing through
the Email Alert API, view the [metrics dashboard][dashboard].

## Integration with GOV.UK Notify

The email notifications system uses GOV.UK Notify as a means to send
emails to users. Email Alert API will request Notify to send an email
and at a later time Notify will inform the Email Alert API whether that
was successful.

Notify will also inform the Email Alert API whenever a subscriber reports
an email as spam. Email Alert API will then unsubscribe the affected subscriber
from all emails.

Communication from Email Alert API to Notify is done via a HTTP API
which is authenticated by an API key. Communication from Notify to Email
Alert API is done via a verified HTTP callback with a bearer token.
Email Alert API is an internal application, so to enable callbacks two
endpoints are exposed publicly through
https://email-alert-api-public.publishing.service.gov.uk.

A courtesy copy of every email sent is available in [a Google Group][google-group].

You can [login to the Notify account](https://www.notifications.service.gov.uk) using the credentials 
in the [2nd line password store][password-store] under `govuk-notify/2nd-line-support`.
Two-factor authentication links for logging in are sent to the 2nd line email address.

[dashboard]: https://grafana.publishing.service.gov.uk/dashboard/file/email_alert_api.json?refresh=10s&orgId=1
[password-store]: https://github.com/alphagov/govuk-secrets/tree/master/pass/2ndline/govuk-notify
[google-group]: https://groups.google.com/a/digital.cabinet-office.gov.uk/forum/#!forum/govuk-email-courtesy-copies
