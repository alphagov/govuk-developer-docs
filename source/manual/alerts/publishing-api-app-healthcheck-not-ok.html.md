---
owner_slack: "#govuk-2ndline"
title: Publishing API app healthcheck not ok
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2019-07-22
review_in: 6 months
---

Along with some common checks, the Publishing API has the following
specific checks.

## `sidekiq_queue_latency`

The latency on the `downstream_high` Sidekiq queue is checked, as this
is critical for prompt publishing.

If there is a backlog in the queue, one possible workaround is to try
restarting Sidekiq. This has been used to workaround issues where the
Sidekiq jobs have got stuck when encountering issues with RabbitMQ.
