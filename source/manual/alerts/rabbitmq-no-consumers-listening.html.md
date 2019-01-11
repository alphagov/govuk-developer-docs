---
owner_slack: "#govuk-2ndline"
title: 'RabbitMQ: No consumers listening to queue'
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2018-08-31
review_in: 6 months
---

[Read more about how we use RabbitMQ][rabbitmq]

We run a check that there is at least one non-idle consumer for a named
RabbitMQ queue. (For example, for the `email_alert_service` queue.) The
queue name should indicate the app responsible for consuming the queue.

The check is performed by connecting to RabbitMQ's admin API, so the
information given is from Rabbit's point of view.

Since we send heartbeats every minute (from each instance of the publishing API)
at least one of the consumers for each queue should be active every minute. To
be conservative, the check checks that at least one consumer of the queue is
running and has been active within the last 5 minutes.

If the check succeeds, it will return the most recent time at which
activity happened on the queue.

If the check fails due to no consumers having been active recently, it
will report a critical failure, giving the most recent idle time, and
the idle times of each consumer connected to RabbitMQ:

    CRITICAL: No activity for X seconds: idle times are [X, Y, Z]

If the check fails due to there being no consumers connected to the
queue, it will report a critical failure:

    CRITICAL: "No consumers listening to queue"

## Consequences of idle consumers

If consumers are idle, messages sent to the queue will not be being
processed. This means that the actions which are meant to happen in
response to the messages will not happen. For example, email alerts
about updated content will not be sent if the `email_alert_sevice` queue
isn't running.

Unless there is a wider RabbitMQ failure, messages will not be lost -
they will be processed once the problem is resolved.

## Investigation

RabbitMQ has an admin interface, which allows details of recent activity
on the queues to be seen. To log in, [follow the
instructions in the RabbitMQ docs][rabbitmq_control_panel].

The admin interface allows you to see details (and graphs!) of the
messages sent to each queue, and the number of messages held on the
queues. Look at the queue for which the alert happened. If no messages
have been sent to the queue over the last several minutes, the most
likely failure is that the heartbeat messages are no longer being sent
correctly. Look for recent changes to the [publishing API][publishing_api].

If messages have been received, and the queue has messages held on it
and not being processed, the consumers have either got stuck or stopped
running for some reason. Restarting the consumers for the relevant app
will probably clear this up (but please make sure the team owning the
app are also alerted, since this shouldn't normally happen). For
example:

    fab $environment class:email_alert_api app.restart:email-alert-service


[publishing_api]: https://github.com/alphagov/publishing-api
[rabbitmq]: /manual/rabbitmq.html
[rabbitmq_control_panel]: /manual/rabbitmq.html#connecting-to-the-rabbitmq-web-control-panel
