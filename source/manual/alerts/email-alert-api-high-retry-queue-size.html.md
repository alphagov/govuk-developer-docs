---
owner_slack: "#govuk-2ndline"
title: 'Email Alert API: High number of messages on sidekiq retry queue'
section: Icinga alerts
subsection: Email alerts
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2020-07-21
review_in: 6 months
---

### High retry queue size (retry_size)

This means there are a high number of items in the retry queue. This happens
when an error occurs running a Sidekiq worker and the job is queued to retry.
A high amount of items indicates that there is a potential problem in
communicating with Notify. To investigate the cause you should consult the
Email Alert API Sidekiq logs in [Kibana][kibana]
(`application:email-alert-api AND tags:sidekiq`) and
[Email Alert API Sentry][sentry]. Note, that due to transitory network issues
communicating with Notify there are often a small amount of items in the queue.

See the [sidekiq][sidekiq] section for more information about the Sidekiq queues,
or read [email troubleshooting].

[email troubleshooting]: /manual/email-troubleshooting.html
[sidekiq]: /manual/sidekiq.html
