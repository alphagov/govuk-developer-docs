---
owner_slack: "#govuk-2ndline"
title: 'Email Alert API: Unprocessed subscription contents'
section: Icinga alerts
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2020-01-07
review_in: 6 months
---

This means there there are subscription contents being created without emails
associated with them, and implies that emails aren't being sent out.

### Icinga checks

* `warning` - `subscription_contents` created over 10 minutes ago (or 35 minutes
  ago if during publishing times)
* `critical` - `subscription_contents` created over 15 minutes ago (or 50 minutes
  during publishing times)

See the [subscription_contents_worker][subscription-content-worker]
for more information.

### Check which subscription contents this affects

```ruby
SubscriptionContent.where("subscription_contents.created_at < ?", 10.minutes.ago).where(email: nil).joins(:subscription).merge(Subscription.active)
```

Check the count, then run the above query again to see if the count has
decreased. If it's decreasing, then it means that emails are going out and
there's probably a lot being processed.
If it's not decreasing the Sidekiq worker might be stuck, see the [sidekiq][sidekiq]
section on how to view the Sidekiq queues.

 You can also check the [Email Alert API Metrics dashboard][dashboard].

[subscription-content-worker]: https://github.com/alphagov/email-alert-api/blob/21e0af3e640963415e02506d927387088061ddd0/app/workers/subscription_contents_worker.rb
[dashboard]: https://grafana.staging.govuk.digital/dashboard/file/email_alert_api.json?refresh=10s&orgId=1
[sidekiq]: /manual/sidekiq.html#sidekiq-web
