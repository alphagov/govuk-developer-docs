---
owner_slack: "#govuk-2ndline-tech"
title: 'Email Alert API: high latency for sidekiq queue'
section: Icinga alerts
subsection: Email alerts
layout: manual_layout
parent: "/manual.html"
---

This alert triggers when there is a significant delay in the time from the
Email Alert API system creating an email until it is sent.

## Understanding the alert

The latency value itself is a measure, in seconds, of the amount of time that
the oldest email in the [Sidekiq] queue has been waiting. This latency builds
up when there are more emails to send than workers to send them and this alert
triggers once this latency reaches an alarming level.

## Impact

The user impact of this alert depends on the queue. A delay for the
`send_email_transactional` queue indicates that users are blocked from
completing user journeys (such as sign-in or sign up), thus a delay of minutes
is frustrating.

For the other [queues] the impact of delayed email is less significant for
users (there aren't assurances on how rapidly an email should be sent)
and indicates a risk that the system is experiencing significantly
degraded performance and may become perpetually overloaded. For
example, if there aren't sufficient resources to send all of Monday's emails
on Monday we could find there aren't resources to send both Monday _and_
Tuesday's emails the next day and so forth.

## How to investigate

You should be looking for evidence of performance degradation, the presence of
errors and whether an abnormal quantity of emails is being created. Some
diagnostic steps you could take are:

* check the [Sidekiq dashboard] to understand the level of work Sidekiq is
  doing and has to do;
* monitor the [Email Alert API Technical dashboard][technical dash] to see
  the rate emails are being sent at and look at broader view of Email Alert API
  status;
* check whether workers are raising errors to [Sentry];
* check [Kibana] to see the Sidekiq logs for Email Alert API;
* you can investigate the health of the [underlying application
  machines][machine metrics] and the [RDS PostgeSQL database
  instance][postgres dash].

[Sidekiq]: /manual/sidekiq.html
[queues]: https://github.com/alphagov/email-alert-api/blob/main/config/sidekiq.yml
[Sidekiq dashboard]: https://grafana.blue.production.govuk.digital/dashboard/file/sidekiq.json?refresh=1m&orgId=1&var-Application=email-alert-api&var-Queues=All&from=now-3h&to=now
[technical dash]: https://grafana.blue.production.govuk.digital/dashboard/file/email_alert_api_technical.json
[Sentry]: https://sentry.io/organizations/govuk/issues/?project=202220&statsPeriod=12h
[Kibana]: https://kibana.logit.io/s/2dd89c13-a0ed-4743-9440-825e2e52329e/app/kibana#/discover?_g=(refreshInterval:(display:Off,pause:!f,value:0),time:(from:now-1h,mode:quick,to:now))&_a=(columns:!('@message',host),index:'*-*',interval:auto,query:(query_string:(query:'@type:%20sidekiq%20AND%20application:%20email-alert-api')),sort:!('@timestamp',desc))
[machine metrics]: https://grafana.blue.production.govuk.digital/dashboard/file/machine.json?refresh=1m&orgId=1&var-hostname=email_alert_api*&var-cpmetrics=cpu-system&var-cpmetrics=cpu-user&var-filesystem=All&var-disk=All&var-tcpconnslocal=All&var-tcpconnsremote=All
[postgres dash]: https://grafana.production.govuk.digital/dashboard/file/aws-rds.json?orgId=1&var-region=eu-west-1&var-dbinstanceidentifier=email-alert-api-postgres&from=now-3h&to=now
