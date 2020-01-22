---
owner_slack: "#govuk-2ndline"
title: 'Email Alert API: high latency for sidekiq queue'
section: Icinga alerts
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2020-01-21
review_in: 6 months
---

### High queue latency (queue_latency)

This means the time it takes for a job to be processed is unusually high. This
may indicate a problem down the line which is preventing workers from being
processed. It may also imply the threshold is too low if a large number of
emails have being sent out due to a content change.

See the [sidekiq][sidekiq] section for more information about the Sidekiq queues.

[sidekiq]: /manual/sidekiq.html
