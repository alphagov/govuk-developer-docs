---
owner_slack: "#govuk-2ndline"
title: 'RabbitMQ: No consumers listening to queue'
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2020-08-24
review_in: 6 months
---

This check reports a critical error when no consumers are listening to the queue:

```
CRITICAL: "No consumers listening to queue"
```

Publishing API [sends a heartbeat message][heartbeat_messages] every minute to keep
consumers active, so in principle, there should always be at least one consumer listening.

## How this check works

Icinga connects to RabbitMQ's admin API to check that at least one consumer is running
for a given RabbitMQ message queue. The queue name indicates the application consuming the queue,
e.g. the [email_alert_service] consumer.

## Consequences

If no consumers are listening, messages sent to the queue are not processed and their associated
actions are not triggered. e.g. If the `email_alert_service` consumer is not running, content updates
produced by publishing-api trigger no email notifications from Email Alert API.

Unless there is an issue with RabbitMQ itself, enqueued messages are not lost. They are stored
and will be processed when at least a consumer is running again.

## How to fix this alert

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

For more in-depth debugging, [inspect messages][rabbit_mq_inspection] present in the queue.

[rabbitmq_control_panel]: /manual/rabbitmq.html#connecting-to-the-rabbitmq-web-control-panel
[heartbeat_messages]: https://github.com/alphagov/publishing-api/blob/d2552f681e772c9e4f5afb3a76605630fa4a588c/lib/tasks/heartbeat_messages.rake
[rabbit_mq_inspection]: /manual/rabbitmq.html#inspectingremoving-items-from-a-queue
[rabbitmq_grafana_dashboard]: https://grafana.publishing.service.gov.uk/dashboard/file/rabbitmq.json
[email_alert_service]: https://github.com/alphagov/email-alert-service
