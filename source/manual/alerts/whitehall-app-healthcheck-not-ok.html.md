---
owner_slack: "#govuk-2ndline"
title: Whitehall app healthcheck not ok
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2018-08-31
review_in: 6 months
---

If the message is a warning about `scheduled_queue`, eg '850 scheduled
edition(s); 840 job(s) queued', this alert means that the number of
editions in the database which are scheduled to be published in the
future is different from the number currently in the queue. This can
happen in Staging and Integration as a result of the data sync from
Production. Run this Rake task to requeue all scheduled editions:

```
cd /var/apps/whitehall
sudo -u deploy govuk_setenv whitehall bundle exec rake publishing:scheduled:requeue_all_jobs
```
