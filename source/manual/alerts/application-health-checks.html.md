---
title: 'Application health checks'
parent: /manual.html
layout: manual_layout
section: Alerts
---

# Application health checks

### 'publisher app health check not ok'

If the message is a warning about 'scheduled\_queue', eg '71 scheduled
edition(s); 3 item(s) queued', this alert means that the number of
editions in the database which are scheduled to be published in the
future is different from the number currently in the queue. This can
happen in Staging and Integration as a result of the data sync from
Production. Run this Rake task to requeue all scheduled editions:

    cd /var/apps/publisher
    sudo -u deploy govuk_setenv publisher bundle exec rake editions:requeue_scheduled_for_publishing

### 'whitehall app health check not ok'

If the message is a warning about 'scheduled\_queue', eg '850 scheduled
edition(s); 840 job(s) queued', this alert means that the number of
editions in the database which are scheduled to be published in the
future is different from the number currently in the queue. This can
happen in Staging and Integration as a result of the data sync from
Production. Run this Rake task to requeue all scheduled editions:

    cd /var/apps/whitehall
    sudo -u deploy govuk_setenv whitehall bundle exec rake publishing:scheduled:requeue_all_jobs

