---
owner_slack: "#govuk-2ndline"
title: 'Email Alert API: High number of messages on sidekiq retry queue'
section: Icinga alerts
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2020-01-21
review_in: 6 months
---

### High retry queue size (retry_size)

This means there are a high number of items in the retry queue. The Email Alert
API relies on the retry queue for rate limiting, so it’s not unusual to see
items in the queue, but if it is very high it suggests that there may be a
problem down the line which is preventing jobs from being processed. It may
also imply the threshold is too low if a large number of emails have been sent
out due to a content change.

See the [sidekiq][sidekiq] section for more information about the Sidekiq queues.

[sidekiq]: /manual/sidekiq.html
