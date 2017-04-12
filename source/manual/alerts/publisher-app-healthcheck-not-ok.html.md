---
title: 'publisher app health check not ok'
parent: /manual.html
layout: manual_layout
section: Icinga alerts
---

# 'publisher app health check not ok'

If the message is a warning about `scheduled_queue`, eg '71 scheduled
edition(s); 3 item(s) queued', this alert means that the number of
editions in the database which are scheduled to be published in the
future is different from the number currently in the queue. This can
happen in Staging and Integration as a result of the data sync from
Production. Run this Rake task to requeue all scheduled editions:

```
cd /var/apps/publisher
sudo -u deploy govuk_setenv publisher bundle exec rake editions:requeue_scheduled_for_publishing
```
