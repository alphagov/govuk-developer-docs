---
owner_slack: "#govuk-2ndline"
title: 'Email Alert API: Unprocessed content changes'
section: Icinga alerts
subsection: Email alerts
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2020-08-07
review_in: 6 months
---

This alert indicates that Email Alert API has [content changes that were not
processed][ProcessContentChangeWorker] within 2 hours. Processing a content change
is the means to establish which subscriber lists should be notified when GOV.UK
content changes and the process to generate individual emails for the change in
content.

We generally expect a content change to be have processed within 30 minutes of
it's creation. At 30 minute intervals a job, [RecoverLostJobsWorker], will try
to requeue any content changes that have not been processed within an hour.

Thus, seeing this alert indicates that we likely have a problem that needs
manual intervention. Potential causes would be:

* [ProcessContentChangeWorker] is failing to process content changes due to
  some error

* Sidekiq not running or not operating correctly

* Content changes taking an abormally long time to process, which may indicate
  degraded system performance or an unexpectedly large task as part of
  processing. This scenario may resolve automatically.

To diagnose this problem, consult [Sentry] to see if there are errors reported.

If you find nothing conclusive in Sentry, go to the [ProcessContentChangeWorker
sidekiq logs] and check the jobs are running correctly.

If the problem persists, run the [RecoverLostJobsWorker] and/or
[ProcessContentChangeWorker] directly to see if any problems occur in real-time.

### Still stuck?

* [Email Alert API troubleshooting] for more information
* [Email Alert API Sidekiq dashboard] to check if jobs are being processed
* [Email Alert API Technical dashboard] to check if emails are going out

[RecoverLostJobsWorker]: https://github.com/alphagov/email-alert-api/blob/master/app/workers/recover_lost_jobs_worker.rb
[Sentry]: https://sentry.io/organizations/govuk/issues/?project=202220&statsPeriod=6h
[ProcessContentChangeWorker sidekiq logs]: https://kibana.logit.io/s/2dd89c13-a0ed-4743-9440-825e2e52329e/app/kibana#/discover?_g=(refreshInterval:(display:Off,pause:!f,value:0),time:(from:now-1h,mode:quick,to:now))&_a=(columns:!('@message',host),index:'*-*',interval:auto,query:(query_string:(query:'@type:%20sidekiq%20AND%20application:%20email-alert-api%20AND%20@fields.worker:%20ProcessContentChangeWorker')),sort:!('@timestamp',desc))
[RecoverLostJobsWorker]: https://github.com/alphagov/email-alert-api/blob/master/app/workers/recover_lost_jobs_worker.rb
[ProcessContentChangeWorker]: https://github.com/alphagov/email-alert-api/blob/master/app/workers/process_content_change_worker.rb

[Email Alert API Sidekiq dashboard]: https://grafana.production.govuk.digital/dashboard/file/sidekiq.json?refresh=1m&orgId=1&var-Application=email-alert-api&var-Queues=All&from=now-3h&to=now
[Email Alert API troubleshooting]: /apis/email-alert-api/troubleshooting.html
[Email Alert API Technical dashboard]: https://grafana.production.govuk.digital/dashboard/file/email_alert_api_technical.json?refresh=1m&orgId=1
