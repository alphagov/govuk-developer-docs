---
owner_slack: "#govuk-2ndline"
title: 'Email Alert API: Unprocessed messages'
section: Icinga alerts
subsection: Email alerts
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2020-08-07
review_in: 6 months
---

This alert indicates that Email Alert API has [messages that were not
processed][ProcessMessageWorker] within 2 hours. Processing a
[message][adr-messages] is the means to establish which subscriber lists should
be notified when an ad hoc message is received and the process to generate
individual emails for this.

We generally expect a message to be have processed within 30 minutes of
it's creation. At 30 minute intervals a job, [RecoverLostJobsWorker], will try
to requeue any messages that have not been processed within an hour.

Thus, seeing this alert indicates that we likely have a problem that needs
manual intervention. Potential causes would be:

* [ProcessMessageWorker] is failing to process messages due to some error

* Sidekiq not running or not operating correctly

* Messages taking an abormally long time to process, which may
  indicate degraded system performance or an unexpectedly large task as part of
  processing. This scenario may resolve automatically.

To diagnose this problem, consult [Sentry] to see if there are errors reported.

If you find nothing conclusive in Sentry, go to the [ProcessMessageWorker
sidekiq logs] and check the jobs are running correctly.

If the problem persists, run the [RecoverLostJobsWorker] and/or
[ProcessMessageWorker] directly to see if any problems occur in real-time.

### Still stuck?

* [Email Alert API troubleshooting] for more information
* [Email Alert API Sidekiq dashboard] to check if jobs are being processed
* [Email Alert API Technical dashboard] to check if emails are going out

[adr-messages]: https://github.com/alphagov/email-alert-api/blob/master/docs/arch/adr-004-message-concept.md

[ProcessMessageWorker]: https://github.com/alphagov/email-alert-api/blob/master/app/workers/process_message_worker.rb
[Sentry]: https://sentry.io/organizations/govuk/issues/?project=202220&statsPeriod=6h
[ProcessMessageWorker sidekiq logs]: https://kibana.logit.io/s/2dd89c13-a0ed-4743-9440-825e2e52329e/app/kibana#/discover?_g=(refreshInterval:(display:Off,pause:!f,value:0),time:(from:now-4h,mode:quick,to:now))&_a=(columns:!('@message',host),index:'*-*',interval:auto,query:(query_string:(analyze_wildcard:!t,query:'@type:%20sidekiq%20AND%20application:%20email-alert-api%20AND%20@fields.worker:%20ProcessMessageWorker')),sort:!('@timestamp',desc))
[RecoverLostJobsWorker]: https://github.com/alphagov/email-alert-api/blob/master/app/workers/recover_lost_jobs_worker.rb

[Email Alert API Sidekiq dashboard]: https://grafana.production.govuk.digital/dashboard/file/sidekiq.json?refresh=1m&orgId=1&var-Application=email-alert-api&var-Queues=All&from=now-3h&to=now
[Email Alert API troubleshooting]: /apis/email-alert-api/troubleshooting.html
[Email Alert API Technical dashboard]: https://grafana.production.govuk.digital/dashboard/file/email_alert_api_technical.json?refresh=1m&orgId=1
