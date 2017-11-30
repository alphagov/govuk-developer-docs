---
owner_slack: "#email"
title: Testing Email
parent: "/manual.html"
layout: manual_layout
section: Deployment
important: true
last_reviewed_on: 2017-11-29
review_in: 1 month
---

## Introduction

When deploying an application that sends email alerts we need to test that functionality.

### Testing email alerts

A courtesy copy of all email sent from the integration, staging and production 
environments is sent to [a google group](https://groups.google.com/a/digital.cabinet-office.gov.uk/forum/#!forum/govuk-email-courtesy-copies).
Integration and staging emails will have a subject prefixed by the environmnent.

If you need to test the process of subscribing to an email alert you can subscribe
with govuk-email-courtesy-copies@digital.cabinet-office.gov.uk. You should then
see two copies of the email at that address when you perform an action that triggers
an email alert (the courtesy copy and the subscriber one).

Our integration and staging environments only allow email to be sent to a small
number of email addresses so you cannot test using your own email address in these
environments.
