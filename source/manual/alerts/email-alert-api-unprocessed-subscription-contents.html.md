---
owner_slack: "#govuk-2ndline"
title: 'Email Alert API: Unprocessed subscription contents'
section: Icinga alerts
subsection: Email alerts
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2020-06-04
review_in: 6 months
---

This means there there are subscription contents being created without emails
associated with them, and implies that emails aren't being sent out.

### Icinga checks

* `warning` - `subscription_contents` created over 10 minutes ago (or 35 minutes
  ago if during publishing times)
* `critical` - `subscription_contents` created over 15 minutes ago (or 50 minutes
  during publishing times)

See the [SubscriptionContentsWorker][subscription-content-worker] for more
information.

### Check which subscription contents are affected

First, enter an Email Alert Api Rails console:

```bash
$ gds govuk connect app-console -e production email-alert-api
```

Then, run this query:

```ruby
SubscriptionContent.where("subscription_contents.created_at < ?", 10.minutes.ago).where(email: nil).joins(:subscription).merge(Subscription.active).count
```

Check the count, then run the above query again to see if the count has
decreased. If it's decreasing, then it means that emails are going out and
there's probably a lot being processed.

If it's not decreasing, the Sidekiq worker might be stuck. See the
[sidekiq][sidekiq] section on how to view the Sidekiq queues, or
read [email troubleshooting].

[subscription-content-worker]: https://github.com/alphagov/email-alert-api/blob/master/app/workers/subscription_contents_worker.rb
[email troubleshooting]: /manual/email-troubleshooting.html
[sidekiq]: /manual/sidekiq.html#sidekiq-web
