---
owner_slack: "#govuk-2ndline"
title: Count active subscribers to a subscription list
section: Emails
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-08-20
review_in: 6 months
---

If you need to retrieve the number of active subscriptions to a subscriber list,
including a breakdown of subscriptions that are Immediate, Daily or Weekly, there
is a rake task in email-alert-api:

`query:count_subscribers['subscriber-list-slug']`

[Run rake task on production][rake-task-production]

[rake-task-production]: https://deploy.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=email-alert-api&MACHINE_CLASS=email_alert_api&RAKE_TASK=query:count_subscribers['subscriber-list-slug']
