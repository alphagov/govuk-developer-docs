---
owner_slack: "#govuk-2ndline"
title: Publishing API app healthcheck not ok
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2020-03-10
review_in: 6 months
---

Along with some common checks, the Publishing API has the following
specific checks.

## `sidekiq_queue_latency`

The latency on the `downstream_high` Sidekiq queue is checked, as this
is critical for prompt publishing.

See the [sidekiq][sidekiq] section for more information about the Sidekiq queues.

[sidekiq]: /manual/sidekiq.html
