---
owner_slack: "#govuk-2ndline"
title: email-alert-api app healthcheck not ok
section: Icinga alerts
subsection: Email alerts
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2020-07-16
review_in: 6 months
---

If there is a health check error showing for Email Alert API, you can click on
the alert to find out more details about what’s wrong. We've listed some common
problems and remedies later on in this document.

## You may not need to do anything

The high queue alerts tend to trigger when emails are sent out. Normally Notify
sends out a bulk of emails around 9.30am, which can cause a spike but this returns
to normal after 10.15am. You can monitor emails have been sent by looking at the
[Email Alert API Metrics Grafana dashboard][dashboard].

## ...but if you do

Read [Email troubleshooting] for how to debug.

[dashboard]: https://grafana.staging.govuk.digital/dashboard/file/email_alert_api.json?refresh=10s&orgId=1
[Email troubleshooting]: /manual/email-troubleshooting.html
