---
owner_slack: "#govuk-2ndline"
title: Whitehall app healthcheck not ok
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2020-09-11
review_in: 12 months
---

See also: [how healthcheck alerts work on GOV.UK](app-healthcheck-not-ok.html)

If the message is a warning about `scheduled_queue`, eg '850 scheduled
edition(s); 840 job(s) queued', this alert means that the number of
editions in the database which are scheduled to be published in the
future is different from the number currently in the queue. This can
happen in Staging and Integration as a result of the data sync from
Production.

Run the `publishing:scheduled:requeue_all_jobs` Rake task to requeue all
scheduled editions:

- [Run in Integration Jenkins](https://deploy.integration.publishing.service.gov.uk//job/run-rake-task/parambuild/?TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=publishing:scheduled:requeue_all_jobs)
- [Run in Staging Jenkins](https://deploy.blue.staging.govuk.digital/job/run-rake-task/parambuild/?TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=publishing:scheduled:requeue_all_jobs)
