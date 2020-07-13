---
owner_slack: "#govuk-2ndline"
title: 'Email Alert API: Unprocessed messages'
section: Icinga alerts
subsection: Email alerts
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2020-07-14
review_in: 6 months
---

`Messages` are similar to [content changes], introduced in September 2019 to support the [Brexit checker].
It is intended to provide a means for applications to alert subscribers to ad hoc
events that may not be represented by a content change. See the [ADR for Messages][adr-messages] for more information.

This alert is triggered when these messages are not processed within the time we would expect. This
may be fine and the emails will eventually go out, but it's worth investigating.

* `warning` - unprocessed `messages` created more than 90 minutes ago
* `critical` - unprocessed `messages` created more than 120 minutes ago

Every 30 minutes, [RecoverLostJobsWorker] automatically requeues jobs for any
unprocessed content changes and messages that are over 1-hour old.

If you see this alert it is likely that something has broken in Email Alert API
that is either blocking one or all recovery attempts.

To diagnose this problem, consult [Sentry](https://sentry.io/organizations/govuk/issues/?project=202220)
to see if there are errors reported.

If you find nothing conclusive in Sentry, go to [Email Alert API sidekiq logs] and check the jobs are running correctly.

If the problem persists, run the [RecoverLostJobsWorker] and/or [ProcessMessageWorker] [directly](https://stackoverflow.com/a/48543738)
to see if any problems occur.

### Still stuck?

* [General troubleshooting tips]
* [Email Alert API troubleshooting] for more information
* [Email Alert API Metrics dashboard] to check if emails are going out


[content changes]: https://docs.publishing.service.gov.uk/manual/alerts/email-alert-api-unprocessed-content-changes.html
[Brexit checker]: https://www.gov.uk/get-ready-brexit-check
[adr-messages]: https://github.com/alphagov/email-alert-api/blob/master/docs/arch/adr-004-message-concept.md

[Email Alert API sidekiq logs]: https://docs.publishing.service.gov.uk/manual/logging.html#kibana
[RecoverLostJobsWorker]: https://github.com/alphagov/email-alert-api/blob/master/app/workers/recover_lost_jobs_worker.rb
[ProcessMessageWorker]: https://github.com/alphagov/email-alert-api/blob/master/app/workers/process_message_worker.rb

[General troubleshooting tips]: /manual/email-troubleshooting.html
[Email Alert API troubleshooting]: /apis/email-alert-api/troubleshooting.html
[Email Alert API Metrics dashboard]: https://grafana.production.govuk.digital/dashboard/file/email_alert_api.json?refresh=10s&orgId=1
