---
owner_slack: "#govuk-2ndline"
title: Whitehall scheduled publishing
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2020-01-30
review_in: 6 months
---

## 'overdue publications in Whitehall'

This alert means that there are scheduled editions which have passed their
publication due date but haven't been published by the scheduled publishing
workers. Scheduled publishing is performed by Sidekiq workers picking up jobs
from a scheduled queue.

You can see whether Sidekiq picked up the job for processing, and the current
state of the job using [Sidekiq monitoring apps][sidekiq-monitoring].

[sidekiq-monitoring]: /manual/sidekiq.html#monitoring

You can verify that there are overdue published documents using:

- [`publishing:overdue:list` on Integration](https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=publishing:overdue:list)
- [`publishing:overdue:list` on Staging](https://deploy.staging.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=publishing:overdue:list)
- [`publishing:overdue:list` on Production](https://deploy.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=publishing:overdue:list)

You'll see output like this:

```
ID  Scheduled date             Title
```

If there are overdue publications you can publish by running the
following:

- [`publishing:overdue:publish` on Integration](https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=publishing:overdue:publish)
- [`publishing:overdue:publish` on Staging](https://deploy.staging.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=publishing:overdue:publish)
- [`publishing:overdue:publish` on Production](https://deploy.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=publishing:overdue:publish)

### After a database restore

If the above rake tasks aren't working, it could be because the database was
recently restored, perhaps due to the data sync. In that case, you can try
running the following Rake task on a `whitehall_backend` machine:

- [`publishing:scheduled:requeue_all_jobs` on Integration](https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=publishing:scheduled:requeue_all_jobs)
- [`publishing:scheduled:requeue_all_jobs` on Staging](https://deploy.staging.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=publishing:scheduled:requeue_all_jobs)
- [`publishing:scheduled:requeue_all_jobs` on Production](https://deploy.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=publishing:scheduled:requeue_all_jobs)
