---
owner_slack: "#govuk-2ndline"
title: 'RabbitMQ: Consumers idle'
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2020-08-24
review_in: 6 months
---

This checks whether the RabbitMQ consumers for a queue have been active in the
last 5 minutes.

Publishing API [sends a heartbeat message][heartbeat_messages] every minute to
the following queues - `email-alert-service`, `cache_clearing_service-high` and
`content_data_api`. This should ensure that the consumers are never idle
for these queues.

## How this check works

Icinga connects to RabbitMQ's admin API to check on the activity of the
consumers of a given RabbitMQ message queue. This script for this check lives
in [puppet][idle-puppet-config].

## Troubleshooting steps

### Check the RabbitMQ logs

* Check the logs for the `rabbitmq` application which can be achieved using
  [this Kibana query][kibana-query]. Is there evidence of any errors?

### Check the RabbitmQ Grafana dashboard

This [Grafana dashboard][rabbitmq_grafana_dashboard] shows activity across
multiple exchanges and queues. The main exchange we expect to be monitoring is
`published_documents` which handles broadcasting to services such as search and
email-alert-service when content changes across GOV.UK.

Looking at the queue graphs we should look out for the following:

High / growing amount of 'ready' messages, this indicates these messages are
waiting to be processed by the consumer (e.g email-alert-service).

We should also look out for a high amount of unacknowledged messages which
implies that messages have been read by the consumer but the consumer has never
sent back an ACK to the RabbitMQ broker to say that it has finished processing.
If this is down to the consumer dying (its channel is closed, connection is
closed, or TCP connection is lost) then RabbitMQ should `redeliver` the
message, if we're seeing high redelivery rates this could indicate an issue
with the consumer.

To troubleshoot these symptoms:

* Check the status of the consumer, e.g for email-alert-service look on the
  email_alert_api machines - `sudo service email-alert-service status`
* If the services are running we should look in the consumers application logs.
* Check messages received by the consumer are actually being actioned (e.g
  email-alert-api is receiving the messages email-alert-service has received
  from RabbitMQ). To do this we could compare the content changes in
  [email-alert-api][email-alert-api] against whats recorded in the
  email-alert-service logs.

### Check the RabbitMQ control panel

1. [Log into the RabbitMQ control panel][rabbitmq_control_panel] to see details
   of recent queue activity.

2. Under the "Queues" tab, click on the name of the queue that triggered the
   alert, e.g. `email_alert_service`, to see statistics like queued messages
   count and queued message rates.

[email-alert-api]: https://github.com/alphagov/email-alert-api
[idle-puppet-config]: https://github.com/alphagov/govuk-puppet/blob/eb8a04a7883d4772fa7266c909c7f40563f8f7a0/modules/icinga/files/usr/lib/nagios/plugins/check_rabbitmq_consumers
[kibana-query]: https://kibana.logit.io/s/2dd89c13-a0ed-4743-9440-825e2e52329e/app/kibana#/discover?_g=()&_a=(columns:!(_source),index:'*-*',interval:auto,query:(query_string:(query:'application:%20rabbitmq')),sort:!('@timestamp',desc))
[publishing_api]: https://github.com/alphagov/publishing-api
[rabbitmq_control_panel]: /manual/rabbitmq.html#connecting-to-the-rabbitmq-web-control-panel
[heartbeat_messages]: https://github.com/alphagov/publishing-api/blob/d2552f681e772c9e4f5afb3a76605630fa4a588c/lib/tasks/heartbeat_messages.rake
[rabbitmq_grafana_dashboard]: https://grafana.blue.production.govuk.digital/dashboard/file/rabbitmq.json?refresh=10s&orgId=1
