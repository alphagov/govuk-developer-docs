---
owner_slack: "#govuk-2ndline"
title: 'RabbitMQ: Consumers not processing messages in queue'
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2018-11-14
review_in: 6 months
---

[Read more about how we use RabbitMQ][rabbitmq]

For some named RabitMQ queues, we run a check that messages are being
consumed.  This is currently only the case for the
`email_alert_service` and `email_unpublishing` queues.  The queue name
should indicate the app responsible for consuming the queue.

This is different to [the check that there are consumers][nocon].
This alert catches the case where a consumer is connected to the queue
but failing to process messages in a timely fashion.

The check is performed by connecting to RabbitMQ's admin API, so the
information given is from Rabbit's point of view.  It looks at the
number of messages still to be delivered.

If the check succeeds, it will return the number of unprocessed
messages in the queue.

If the check fails due to a build up of messages, it will report how
many messages there are, and what the threshold is.

## Consequences of message build-up

If messages are building up, it may indicate that the service which
consumes them has hit a problem, or there is an unusually high amount
of activity.  For example, email alerts about updated content will not
be sent if the `email_alert_sevice` queue isn't being processed.

Unless there is a wider RabbitMQ failure, messages will not be lost -
they will be processed once the problem is resolved.

## Investigation

The same approach as "[RabbitMQ: No consumers listening to
queue][nocon]".

[rabbitmq]: /manual/rabbitmq.html
[rabbitmq_control_panel]: /manual/rabbitmq.html#connecting-to-the-rabbitmq-web-control-panel
[nocon]: /manual/alerts/rabbitmq-no-consumers-listening.html
