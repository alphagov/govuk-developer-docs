---
owner_slack: "#govuk-2ndline"
title: 'RabbitMQ: No consumers listening to queue'
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

## Check that there is at least one non-idle consumer for rabbitmq queue {queue_name}

Icinga connects to RabbitMQ's admin API to check on the activity of the
consumers and that at least one consumer is running for a given RabbitMQ
message queue. See [here][check_rabbitmq_plugin] for the plugin that implements
the alert.

For information about how we use RabbitMQ, see [here][rabbitmq_doc].

### `No consumers listening to queue`

This check reports a critical error when **no** consumers are listening to the
queue, meaning messages entering the queue will never be processed.

### `No activity for X seconds: idle times are [X, Y, Z]`

This checks whether the RabbitMQ consumers for a queue have been active in the
last 5 minutes. Consumers in an `idle` state are listening to the queue but are
unable to process the messages on it.

Publishing API [sends a heartbeat message][heartbeat_messages] every minute to
the following queues - `email-alert-service`, `cache_clearing_service-high` and
`content_data_api`. This is configured via the queues bindings (e.g
[email-alert-service's binding][email_alert_binding]) matching the routing key
used in the [heartbeat][heartbeat]. This should ensure that the consumers are
never idle for these queues.

> **Note**
>
> You may see the [high unprocessed messages][high_unprocessed_messages] alert too,
> as issues with consumers processing messages could then lead to a high
> backlog of messages.

## Troubleshooting

### Check the RabbitMQ logs

Check the logs for the `rabbitmq` application which can be achieved logging
into Kibana and searching for `application: rabbitmq`. Is there evidence of any
errors?

### Check the RabbitmQ Grafana dashboard

This [Grafana dashboard][rabbitmq_grafana_dashboard] shows activity across
multiple exchanges and queues. The main exchange we expect to be monitoring is
`published_documents` which handles broadcasting to services such as search and
email-alert-service when content changes across GOV.UK.

Looking at the queue graphs we should look out for the following:

* **Check for high 'ready' messages for the queue** - indicates these messages are
  waiting to be processed in RabbitMQ by the consumer (e.g
  email-alert-service).

* **Check for high 'unacknowledged' messages for the queue** - implies that
  messages have been read by the consumer but the consumer has never sent back
  an ACK to the RabbitMQ broker to say that it has finished processing.

* **Check for high 'redeliver' rate for the queue** - in the event of network
  failure (or a node failure), messages can be redelivered. An example is if
  the consumer dies (its channel is closed, connection is closed, or TCP
  connection is lost).

If we're seeing high 'redeliver' rates, high 'ready' or 'unacknowledged'
messages then this could indicate an issue with the consumer.

### Troubleshooting steps

1. You could try restarting the consumer applications. After restarting, check
   to see if the problem is solved. E.g for email-alert-service, run:

```bash
$ fab $environment class:email_alert_api app.restart:email-alert-service
```

2. If the issue has not resolved, we should check in the consumers application
   logs to see if any errors are being thrown.

[high_unprocessed_messages]: https://docs.publishing.service.gov.uk/manual/alerts/rabbitmq-high-number-of-unprocessed-messages.html
[email_alert_binding]: https://github.com/alphagov/email-alert-service/blob/4412a1b3b0f281733801e1631416ab02fac90e25/lib/tasks/message_queues.rake#L17
[rabbitmq_doc]: https://docs.publishing.service.gov.uk/manual/rabbitmq.html
[check_rabbitmq_plugin]: https://github.com/alphagov/govuk-puppet/blob/eb8a04a7883d4772fa7266c909c7f40563f8f7a0/modules/icinga/files/usr/lib/nagios/plugins/check_rabbitmq_consumers
[heartbeat_messages]: https://github.com/alphagov/publishing-api/blob/d2552f681e772c9e4f5afb3a76605630fa4a588c/lib/tasks/heartbeat_messages.rake
[rabbitmq_grafana_dashboard]: https://grafana.blue.production.govuk.digital/dashboard/file/rabbitmq.json?refresh=10s&orgId=1
[heartbeat]: https://github.com/alphagov/publishing-api/blob/d2552f681e772c9e4f5afb3a76605630fa4a588c/lib/queue_publisher.rb#L43
