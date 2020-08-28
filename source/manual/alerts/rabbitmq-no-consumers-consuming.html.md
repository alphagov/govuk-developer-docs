---
owner_slack: "#govuk-2ndline"
title: 'RabbitMQ: Consumers not processing messages in queue'
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2020-08-21
review_in: 6 months
---

We check that the messages on the `email_alert_service` and `email_unpublishing`
message queues are being consumed.

Unlike the [no consumers listening check][nocon], this one triggers an alert
when a consumer is listening to the queue but failing to process its messages
in a timely fashion.

## How this check works

The Icinga check is performed by connecting to RabbitMQ's admin API, so the
information given is from Rabbit's point of view. It looks at the
number of messages still to be delivered.

A successful check returns the number of unprocessed messages in the queue.

A failing check due to a build up of messages reports the message count and
the threshold that has been crossed to trigger the alert.

## Consequences

A message build up may indicate that there is an issue with the consumer,
or that there is unusually high activity.

For example, if the messages on the `email_alert_service` queue aren't being processed,
email-alert-api will not send out content change email notifications.

Unless there is an issue with RabbitMQ itself, enqueued messages are not lost. They are stored
and will be processed when at least a consumer is running again.

## Investigation

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

If the queue contains unprocessed messages, the consumers are either stuck or
stopped. After notifying the owners of the application, restart the consumers
for the failing queue with:

```sh
$ fab $environment class:email_alert_api app.restart:email-alert-service
```

[rabbitmq_control_panel]: /manual/rabbitmq.html#connecting-to-the-rabbitmq-web-control-panel
[nocon]: /manual/alerts/rabbitmq-no-consumers-listening.html
[email_alert_service]: https://github.com/alphagov/email-alert-service
[rabbitmq_grafana_dashboard]: https://grafana.blue.production.govuk.digital/dashboard/file/rabbitmq.json?refresh=10s&orgId=1
