---
owner_slack: "#govuk-2ndline"
title: Email callbacks from Notify fails
section: Emails
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-05-07
review_in: 3 months
---

Callbacks from Notify may fail and require us to manually query the status of
emails.

There are two rake tasks that can do this using either the `reference` or the
`email_id`

## Query the Notify API for email(s) by reference

[⚙ Run rake task on production][reference]


## Query the Notify API for email(s) by email ID

[⚙ Run rake task on production][email_id]

Example output when a notification is found:

```
Query Notify for emails with the reference ref_123
-------------------------------------------
Notification ID: f163deaf-2d3f-4ec6-98fc-f23fa511518f
Status: delivered
created_at: 2019-01-29 11:12:30 UTC
sent_at: 2019-01-29 11:12:40 UTC
completed_at: 2019-01-29 11:12:52 UTC
```

Example output when a notification is not found:

```
Query Notify for emails with the reference PPP
No results found, empty collection returned
```

Example output when the request fails:

```
Query Notify for emails with the reference ref_123
Returns request error 400, message: [{"error"=>"ValidationError",
"message"=>"bad status is not one of [created, sending, sent,
delivered, pending, failed, technical-failure, temporary-failure,
permanent-failure, accepted, received]"}]
```


[reference]: https://deploy.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=email-alert-api&MACHINE_CLASS=email_alert_api&RAKE_TASK=report:get_notifications_from_notify[reference]
[email_id]: https://deploy.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=email-alert-api&MACHINE_CLASS=email_alert_api&RAKE_TASK=report:get_notifications_from_notify_by_email_id[id]
