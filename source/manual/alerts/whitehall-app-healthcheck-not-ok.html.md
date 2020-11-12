---
owner_slack: "#govuk-2ndline"
title: Whitehall app healthcheck not ok
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

See also: [how healthcheck alerts work on GOV.UK](app-healthcheck-not-ok.html)

If the message is a warning about `scheduled_queue`, eg '850 scheduled
edition(s); 840 job(s) queued', this alert means that the number of
editions in the database which are scheduled to be published in the
future is different from the number currently in the queue.

Run the `publishing:scheduled:requeue_all_jobs` Rake task to requeue all
scheduled editions:

- [Run in Integration Jenkins](https://deploy.integration.publishing.service.gov.uk//job/run-rake-task/parambuild/?TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=publishing:scheduled:requeue_all_jobs)
- [Run in Staging Jenkins](https://deploy.blue.staging.govuk.digital/job/run-rake-task/parambuild/?TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=publishing:scheduled:requeue_all_jobs)

Historically, this error has happened in the staging and integration
environments, after the nightly [data sync](/manual/govuk-env-sync.html).
We [no longer spawn scheduling workers](https://github.com/alphagov/govuk-puppet/pull/10842)
for Whitehall on Staging and Integration, so this will no longer affect
those environments. The alert and rake task fix could still prove useful
on Production.

If we find this never happens on Production, we should remove the alert
altogether (from govuk-puppet and from [Whitehall](https://github.com/alphagov/whitehall/pull/5882)),
and delete this manual.
