---
owner_slack: "#govuk-2ndline-tech"
title: Travel Advice or Drug and Medical Device email alerts not sent
section: Pagerduty alerts
layout: manual_layout
parent: "/manual.html"
---

We expect that when new GOV.UK content is published, or when existing content
is updated in a significant way, emails will be sent to any subscribers to
notify them of the change.

We actively monitor this for [medical safety alerts][] and [travel advice
alerts][] with scheduled jobs running in [email-alert-api][].

These jobs determine a list of content that we expect subscribers to have
been emailed. We use the Notify system's callback to record whether emails
sent out via this alert have been received.

## Finding out more details about the failed check

Open this [Kibana Search][kibana last 24 hours] to see potentially undelivered
alerts in the last 24 hours (note the same alerts will appear on each run, so
you might see the same alert more than once in this log view)

This will get you the Content ID and Path of the alert, and visiting the path
on GOV.UK will get you the title of the alert.

## Verifying whether the email was received

To verify if the Gmail account has received the email or not you can join the
google group 'Email Alert API Alert Listener', which is subscribed to all travel
advice and medical safety alerts, and see if the email has been received.

## Troubleshooting

* If an email matching the details in the logs has been received by the google
  account, it is possible that a false alarm has occurred. Check to see if there
  is a Notify outage. (NOTIFY STATUS PAGE)
* Using the Content ID from the logs, get send/delivery statistics from
  email-alert-api using the [email statistics rake task][] in email-alert-api
  to determine whether there was a problem sending the emails to Notify, or
  problems returned from Notify after it attempted to deliver them.
* determine whether Email Alert API has a backlog of work to do using the
  [Sidekiq dashboard][] and [Email Alert API Technical
  dashboard][tech dashboard] - the email may just be delayed;
* whether the change was a result of a new type of medical safety content
  sub-type, this was the previous cause of an [incident][checkbox-incident] and
  is recorded as [GOV.UK Tech Debt][checkbox tech debt];
* check the [Kibana logs][] and [Sentry][] for any errors or clues;
* if all else fails you may need to investigate the Email Alert API database
  to determine whether the content change was received and what state it is in.

## Resending medical safety emails

If you need to force the sending of a travel advice email alert, run the
`email_alerts:trigger[PUT_EDITION_ID_HERE]` rake task in Travel Advice
Publisher.

The edition ID of the travel advice content item can be found in the
URL of the country's edit page in Travel Advice Publisher and looks like
`fedc13e231ccd7d63e1abf65`.

## Resending travel advice emails

If you need to force the sending of a travel advice email alert, run the
`email_alerts:trigger[PUT_EDITION_ID_HERE]` rake task in Travel Advice
Publisher.

The edition ID of the travel advice content item can be found in the
URL of the country's edit page in Travel Advice Publisher and looks like
`fedc13e231ccd7d63e1abf65`.

[medical safety alerts]: https://www.gov.uk/drug-device-alerts
[travel advice alerts]: https://www.gov.uk/foreign-travel-advice
[email-alert-api]: https://github.com/alphagov/email-alert-api
[kibana last 24 hours]: https://kibana.logit.io/s/13d1a0b1-f54f-407b-a4e5-f53ba653fac3/app/discover?security_tenant=global#/view/4147d5b0-99f8-11ee-aed3-9b7debb07809?_g=(filters%3A!()%2CrefreshInterval%3A(pause%3A!t%2Cvalue%3A0)%2Ctime%3A(from%3Anow-24h%2Cto%3Anow))
[email statistics rake task]: /repos/email-alert-api/alert_check_scheduled_jobs.html#support-tasks
[Sidekiq dashboard]: https://grafana.eks.production.govuk.digital/d/sidekiq-queues/sidekiq3a-queue-length-max-delay?orgId=1&var-namespace=apps&var-app=email-alert-api-worker&from=now-24h&to=now
[tech dashboard]: https://grafana.eks.production.govuk.digital/d/app-requests/app3a-request-rates-errors-durations?orgId=1&refresh=1m&var-namespace=apps&var-app=email-alert-api&var-error_status=All&from=now-24h&to=now
[checkbox-incident]: https://docs.google.com/document/d/1AwpXPF1c7fbsOL8KX10ko_wLok4YykabmRfkHJjRqfA/edit#
[checkbox tech debt]: https://trello.com/c/v2ees2fD/199-all-checkbox-is-misleading-for-finderemailsignups
[Kibana logs]: https://kibana.logit.io/s/2dd89c13-a0ed-4743-9440-825e2e52329e/goto/43fc79ee47ac49f248e0f29a174be240
[Sentry]: https://sentry.io/organizations/govuk/issues/?project=202220&statsPeriod=12h
