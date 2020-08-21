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

The queue name indicates the application consuming the queue,
e.g. the [email_alert_service] consumer.

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

Log into Kibana and check the logs for the `rabbitmq` application.

### Check the RabbitmQ Grafana dashboard

This [Grafana dashboard][rabbitmq_grafana_dashboard] shows activity on the `published_documents`
exchange and the queues bound to it.

### Check the RabbitMQ control panel

1. [Log into the RabbitMQ control panel][rabbitmq_control_panel] to see details of recent queue activity.

2. Under the "Queues" tab, click on the name of the queue that triggered the alert, e.g. `email_alert_service`, to see statistics like queued messages count and queued message rates.

If the queue contains unprocessed messages, the consumers are either stuck
or stopped. After notifying the owners of the application, restart the consumers
for the failing queue with:

```sh
$ fab $environment class:email_alert_api app.restart:email-alert-service
```

[rabbitmq_control_panel]: /manual/rabbitmq.html#connecting-to-the-rabbitmq-web-control-panel
[nocon]: /manual/alerts/rabbitmq-no-consumers-listening.html
[email_alert_service]: https://github.com/alphagov/email-alert-service
[rabbitmq_grafana_dashboard]: https://grafana.publishing.service.gov.uk/dashboard/file/rabbitmq.json
