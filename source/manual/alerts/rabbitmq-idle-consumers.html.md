---
owner_slack: "#govuk-2ndline"
title: 'RabbitMQ: Consumers idle'
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2020-08-20
review_in: 6 months
---

This checks whether the RabbitMQ consumers for a queue have been active in the last 5 minutes.

When the check fails due to consumers being idle for over 5 minutes, it reports a critical
failure indicating the most recent idle time, and the idle times of each consumer connected
to RabbitMQ:

```
CRITICAL: No activity for X seconds: idle times are [X, Y, Z]
```

Publishing API [sends a heartbeat message][heartbeat_messages] every minute, so in principle
the system should never be in a state in which all consumers have been idle for over 5 minutes.

## How this check works

Icinga connects to RabbitMQ's admin API to check on the activity of the consumers of
a given RabbitMQ message queue. The queue name indicates the consumer, e.g. the [email_alert_service] consumer.

## How to investigate

### Check the RabbitMQ logs

Log into Kibana and check the logs for the `rabbitmq` application.

### Check the RabbitmQ Grafana dashboard

This [Grafana dashboard][rabbitmq_grafana_dashboard] shows activity on the `published_documents`
exchange and the queues bound to it.

### Check the RabbitMQ control panel

1. [Log into the RabbitMQ control panel][rabbitmq_control_panel] to see details of recent
queue activity.

2. Under the "Queues" tab, click on the name of the queue that triggered the alert, e.g. `email_alert_service`,
to see statistics like queued messages count and queued message rates.

If no message has been queued over the last few minutes, [Publishing API][publishing_api] is
likely no longer enqueuing any heartbeat messages.


## Still stuck?

* [Read more about how we use RabbitMQ](/manual/rabbitmq.html)
* [RabbitMQ Tutorials](https://www.rabbitmq.com/getstarted.html)
* [Bunny](https://github.com/ruby-amqp/bunny) is the RabbitMQ client we use.
* [The Bunny Guides](http://rubybunny.info/articles/guides.html) explain all
  AMQP concepts really well.

[publishing_api]: https://github.com/alphagov/publishing-api
[rabbitmq_control_panel]: /manual/rabbitmq.html#connecting-to-the-rabbitmq-web-control-panel
[heartbeat_messages]: https://github.com/alphagov/publishing-api/blob/d2552f681e772c9e4f5afb3a76605630fa4a588c/lib/tasks/heartbeat_messages.rake
[rabbitmq_grafana_dashboard]: https://grafana.publishing.service.gov.uk/dashboard/file/rabbitmq.json
[email_alert_service]: https://github.com/alphagov/email-alert-service
