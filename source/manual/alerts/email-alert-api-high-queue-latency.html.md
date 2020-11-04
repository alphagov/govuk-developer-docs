---
owner_slack: "#govuk-2ndline"
title: 'Email Alert API: high latency for sidekiq queue'
section: Icinga alerts
subsection: Email alerts
layout: manual_layout
parent: "/manual.html"
---

### High queue latency (queue_latency)

This means the time it takes for a job to be processed is unusually high. See
the Sidekiq ['Queue Latency'][Sidekiq dash] graph for more detail.

For more information on the individual queues and what they do, see
[here][email queues].

Some diagnostic steps you could take are below:

* Check the Sidekiq ['Queue Length'][Sidekiq dash] graph to see if we have a
  high number of emails queued up.
* If there is a high amount of emails in the queue, are we processing them at a
  normal speed? Under high load we regularly send requests to Notify at a rate
  of ~300 email requests per second. To check this, look at the ['Email Send
  Attempts'][technical dash] graph.
* If we're sending email requests slower than usual, refer to the [Email Alert
  API machine metrics dashboard][machine metrics] or the [AWS RDS postgres
  dashboard][postgres dash] to see if we're experiencing resourcing issues.
* Are the workers reporting any problems or any issues being raised in
  [Sentry]?
* Check [Kibana] to see our Sidekiq logs for Email Alert API.

See [here][Sidekiq] for more information about Sidekiq.

[Sidekiq]: https://docs.publishing.service.gov.uk/manual/sidekiq.html
[Sentry]: https://sentry.io/organizations/govuk/issues/?project=202220&statsPeriod=12h
[Sidekiq dash]: https://grafana.blue.production.govuk.digital/dashboard/file/sidekiq.json?refresh=1m&orgId=1&var-Application=email-alert-api&var-Queues=All&from=now-3h&to=now
[technical dash]: https://grafana.blue.production.govuk.digital/dashboard/file/email_alert_api_technical.json
[Kibana]: https://kibana.logit.io/s/2dd89c13-a0ed-4743-9440-825e2e52329e/app/kibana#/discover?_g=(refreshInterval:(display:Off,pause:!f,value:0),time:(from:now-1h,mode:quick,to:now))&_a=(columns:!('@message',host),index:'*-*',interval:auto,query:(query_string:(query:'@type:%20sidekiq%20AND%20application:%20email-alert-api')),sort:!('@timestamp',desc))
[email queues]: https://github.com/alphagov/email-alert-api/blob/master/config/sidekiq.yml
[machine metrics]: https://grafana.blue.production.govuk.digital/dashboard/file/machine.json?refresh=1m&orgId=1&var-hostname=email_alert_api*&var-cpmetrics=cpu-system&var-cpmetrics=cpu-user&var-filesystem=All&var-disk=All&var-tcpconnslocal=All&var-tcpconnsremote=All
[postgres dash]: https://grafana.production.govuk.digital/dashboard/file/aws-rds.json?orgId=1&var-region=eu-west-1&var-dbinstanceidentifier=blue-postgresql-primary&from=now-3h&to=now
