---
owner_slack: "#govuk-2ndline"
title: 'Email Alert API: High number of delivery attempts have not received status updates'
section: Icinga alerts
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2020-01-07
review_in: 6 months
---

Delivery attempts include status updates from Notify on whether emails have been
sent successfully. You can read more about them in [Notify's documentation][notify-documentation].

The alert is triggered when a proportion of delivery attempts are still `pending`
and we have not received the status updates from Notify within the past hour.
This could mean there is a problem with our system, or there could be a problem
with Notify.

### Check which delivery attempts are affected

```ruby
  DeliveryAttempt.where("created_at > ?", (1.hour + 10.minutes).ago).where(status: 0)
```

### Monitor the dashboard

You can also check the [Email Alert API Metrics dashboard][dashboard] to see if
we are still receiving updates from Notify.

See the [General troubleshooting tips][troubleshooting] section for more information.

[notify-documentation]: https://docs.notifications.service.gov.uk/ruby.html#status-text-and-email
[dashboard]: https://grafana.staging.govuk.digital/dashboard/file/email_alert_api.json?refresh=10s&orgId=1
[troubleshooting]: /manual/alerts/email-alert-api-app-healthcheck-not-ok.html#general-troubleshooting-tips
[sidekiq]: /manual/sidekiq.html#sidekiq-web
