---
owner_slack: "#govuk-2ndline"
title: 'Email Alert API: Incomplete digest runs'
section: Icinga alerts
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2020-01-08
review_in: 6 months
---

### Incomplete digest runs (digest_runs)

This means that there are some digest runs which haven't been processed within
the time we would expect.

* `warning` - `digest_runs` unprocessed for over 20 minutes
* `critical` - `digest_runs` unprocessed for over 1 hour

See the [DigestEmailGenerationWorker][digest-email-generation-worker] for more information.

#### Check which digest runs are affected

```ruby
DigestRun.where("created_at < ?", 1.hour.ago).where(completed_at: nil)
```

[digest-email-generation-worker]: https://github.com/alphagov/email-alert-api/blob/master/app/workers/digest_email_generation_worker.rb
