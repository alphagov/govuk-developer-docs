---
owner_slack: "#govuk-2ndline"
title: Whitehall scheduled publishing
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2018-08-31
review_in: 6 months
---

### 'overdue publications in Whitehall'

This alert means that there are scheduled editions which have passed
their publication due date but haven't been published by the scheduled
publishing workers. Scheduled publishing is performed by sidekiq workers
picking up jobs from a scheduled queue.

You can see whether sidekiq picked up the job for processing, and the
current state of the job using [Sidekiq monitoring
apps](applications/sidekiq-monitoring.html).

You can verify that there are overdue published documents using:

    $ fab $environment class:whitehall_backend whitehall.overdue_scheduled_publications

You'll see output like this:

    ID  Scheduled date             Title

If there are overdue publications you can publish by running the
following:

    $ fab $environment class:whitehall_backend whitehall.schedule_publications

#### After a database restore

If the above rake tasks aren't working, it could be because the database was recently restored, perhaps due to the data sync. In that case, you can try running the following Rake task on a `whitehall_backend` machine:

```bash
$ cd /var/apps/whitehall
$ sudo -u deploy govuk_setenv whitehall bundle exec rake publishing:scheduled:requeue_all_jobs
```
