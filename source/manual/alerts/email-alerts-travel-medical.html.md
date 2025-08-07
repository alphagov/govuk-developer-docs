---
owner_slack: "#govuk-web-support"
title: Travel Advice or Drug and Medical Device email alerts not sent
section: Monitoring and alerting
layout: manual_layout
parent: "/manual.html"
---

GOV.UK's [email-alert-api] sends two kinds of time-sensitive email notifications:

* [travel advice alerts]
* [medical safety alerts], for example product recalls of medical devices

These _email alerts_ are supposed to be delivered to subscribers within a few
hours.

email-alert-api-worker monitors deliverability by comparing records of
what should have been sent against callbacks from GOV.UK Notify, which is the
system that sends the bulk email to subscribers.

> _Email alerts_ have nothing to do with Prometheus/Alertmanager/PagerDuty
> alerts. They're just ambiguously named.

## Find out which mailshot was affected

Search for recent [WARN-level logs from email-alert-api-worker]. Workers log a
`Couldn't find any delivered emails for ...` warning periodically when there
are potentially undelivered medical/travel alerts.

The log message should contain the Content ID and path of the affected
mailshot. Visit the path on GOV.UK to find the title of the alert.

You can also look at recent [INFO-level logs from email-alert-api-worker],
to check the current state of all alerts under consideration and check whether
more than one alert is affected. You'll see messages like
`Checking #{document_type.titleize} records: 5 out of 5 alerts have been delivered to at least one recipient`
(eg) every 15 minutes.

## Verify whether the email was received

The [email-alert-api-alert-listener] mailing list is subscribed to all travel
advice and medical safety alerts. Check whether the message appears there.

## Troubleshooting

* Check whether an email matching the details from the logs was delivered to
  the [email-alert-api-alert-listener] mailing list.

* Check [Notify's service
  status](https://status.notifications.service.gov.uk/).

* Using the Content ID from the logs, use the [email statistics rake task] to
  determine whether the app failed to send messages to Notify, or whether
  Notify failed to deliver them.

* Check the size of email-alert-api's work queue using the [Sidekiq dashboard]
  and [email-alert-api dashboard]. Is there a backlog? If so, is it
  diminishing? Are the workers making sufficient progress?

* Check [logs in
  Kibana](https://kibana.logit.io/s/13d1a0b1-f54f-407b-a4e5-f53ba653fac3/goto/06faa093ecf75957ccc04700ea52515d?security_tenant=global)
  and events in [Sentry] for errors or clues.

* Previously, the introduction of a new content sub-type of medical safety
  alerts caused an [outage][checkbox-incident]. See ["all" checkbox is
  misleading for finder_email_signups](https://trello.com/c/v2ees2fD).

* If all else fails, investigate the Email Alert API database to determine
  whether the content change was received and what state it is in.

## Resend a medical safety alert

1. Find the content ID of the affected content item. In Specialist Publisher,
   go to [Medical
   Alerts](https://specialist-publisher.publishing.service.gov.uk/medical-safety-alerts)
   and choose the affected document. The content ID is the UUID in the URL. For
   example, in
   `https://specialist-publisher.publishing.service.gov.uk/medical-safety-alerts/de8a10f1-eac7-49a8-a8ef-1769a6f6cef9:en`
   the content ID is `de8a10f1-eac7-49a8-a8ef-1769a6f6cef9`.

1. Run the `republish:one[<CONTENT_ID>]` Rake task in specialist-publisher,
   replacing `<CONTENT_ID>` with the one from the previous step.

## Resend a travel advice alert

1. Find the edition ID of the affected content item. In Travel Advice Publisher,
   go to the URL of the country's Edit page. The edition ID is a 24-digit hex
   number, for example `fedc13e231ccd7d63e1abf65`.

1. Run the `email_alerts:trigger[<EDITION_ID>]` Rake task in
   travel-advice-publisher, replacing `<EDITION_ID>` with the one from the
   previous step.

[medical safety alerts]: https://www.gov.uk/drug-device-alerts
[travel advice alerts]: https://www.gov.uk/foreign-travel-advice
[email-alert-api]: https://github.com/alphagov/email-alert-api
[WARN-level logs from email-alert-api-worker]: https://kibana.logit.io/s/13d1a0b1-f54f-407b-a4e5-f53ba653fac3/app/discover?security_tenant=global#/view/4147d5b0-99f8-11ee-aed3-9b7debb07809?_g=(filters:!(),refreshInterval:(pause:!t,value:0),time:(from:now-24h,to:now))&_a=(columns:!(_source),filters:!(('$state':(store:appState),meta:(alias:!n,disabled:!f,index:'filebeat-*',key:kubernetes.labels.app_kubernetes_io%2Fname,negate:!f,params:(query:email-alert-api-worker),type:phrase),query:(match_phrase:(kubernetes.labels.app_kubernetes_io%2Fname:email-alert-api-worker))),('$state':(store:appState),meta:(alias:!n,disabled:!f,index:'filebeat-*',key:level,negate:!f,params:(query:WARN),type:phrase),query:(match_phrase:(level:WARN)))),index:'filebeat-*',interval:auto,query:(language:lucene,query:'%22any%20delivered%22'),sort:!())
[INFO-level logs from email-alert-api-worker]: https://kibana.logit.io/s/13d1a0b1-f54f-407b-a4e5-f53ba653fac3/app/data-explorer/discover/#/view/4147d5b0-99f8-11ee-aed3-9b7debb07809?_g=(filters:!(),refreshInterval:(pause:!t,value:0),time:(from:now-1h,to:now))&_a=(discover:(columns:!(message,level),interval:auto,sort:!()),metadata:(indexPattern:'filebeat-*',view:discover))&_q=(filters:!(('$state':(store:appState),meta:(alias:!n,disabled:!f,index:'filebeat-*',key:kubernetes.labels.app_kubernetes_io%2Fname,negate:!f,params:(query:email-alert-api-worker),type:phrase),query:(match_phrase:(kubernetes.labels.app_kubernetes_io%2Fname:email-alert-api-worker))),('$state':(store:appState),meta:(alias:!n,disabled:!f,index:'filebeat-*',key:level,negate:!f,params:(query:INFO),type:phrase),query:(match_phrase:(level:INFO)))),query:(language:lucene,query:'%22have%20been%20delivered%22'))
[email statistics rake task]: https://github.com/alphagov/email-alert-api/blob/main/docs/alert_check_scheduled_jobs.md#support-tasks
[Sidekiq dashboard]: https://grafana.eks.production.govuk.digital/d/sidekiq-queues/?var-namespace=apps&var-app=email-alert-api-worker&from=now-24h&to=now
[email-alert-api dashboard]: https://grafana.eks.production.govuk.digital/d/app-requests/?var-namespace=apps&var-app=email-alert-api&var-error_status=All&from=now-24h&to=now
[checkbox-incident]: https://docs.google.com/document/d/1AwpXPF1c7fbsOL8KX10ko_wLok4YykabmRfkHJjRqfA/edit#
[Sentry]: https://sentry.io/organizations/govuk/issues/?project=202220&statsPeriod=12h
[email-alert-api-alert-listener]: https://groups.google.com/a/digital.cabinet-office.gov.uk/g/email-alert-api-alert-listener
