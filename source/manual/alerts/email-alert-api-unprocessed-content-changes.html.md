---
owner_slack: "#govuk-2ndline"
title: 'Email Alert API: Unprocessed content changes'
section: Icinga alerts
subsection: Email alerts
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2020-07-16
review_in: 6 months
---

This alert is triggered when content changes are not processed within the time we would expect.

* `warning` - `content_changes` unprocessed for over 90 minutes
* `critical` - `content_changes` unprocessed for over 120 minutes

Every 30 minutes, [RecoverLostJobsWorker] automatically requeues jobs for any
unprocessed content changes and messages that are over 1-hour old.

If you see this alert it is likely that something has broken in Email Alert API
that is either blocking one or all recovery attempts.

To diagnose this problem, consult [Sentry](https://sentry.io/organizations/govuk/issues/?project=202220)
to see if there are errors reported.

If you find nothing conclusive in Sentry, go to [Email Alert API sidekiq logs] and check the jobs are running correctly.

If the problem persists, run the [RecoverLostJobsWorker] and/or [ProcessContentChangeWorker][process-content-change-worker] [directly](https://stackoverflow.com/a/48543738)
to see if any problems occur.

### Still stuck?

* [General troubleshooting tips]
* [Email Alert API troubleshooting] for more information
* [Email Alert API Metrics dashboard] to check if emails are going out


[Email Alert API sidekiq logs]: https://docs.publishing.service.gov.uk/manual/logging.html#kibana
[RecoverLostJobsWorker]: https://github.com/alphagov/email-alert-api/blob/master/app/workers/recover_lost_jobs_worker.rb
[process-content-change-worker]: https://github.com/alphagov/email-alert-api/blob/master/app/workers/process_content_change_worker.rb

[General troubleshooting tips]: /manual/email-troubleshooting.html
[Email Alert API troubleshooting]: /apis/email-alert-api/troubleshooting.html
[Email Alert API Metrics dashboard]: https://grafana.production.govuk.digital/dashboard/file/email_alert_api.json?refresh=10s&orgId=1
