---
owner_slack: "#govuk-2ndline"
title: Manage RabbitMQ
section: Infrastructure
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2020-08-24
review_in: 6 months
---

[RabbitMQ][RabbitMQ] is a message broker based on the [Advanced Message Queuing
Protocol][AMQP] (AMQP): it accepts and forwards messages. You can think about
it as a post office: when you put the mail that you want posting in a post box,
you can be sure that a mail person will eventually deliver the mail to
your recipient. In this analogy, RabbitMQ is a postbox, a post office and a
postman.

The major difference between RabbitMQ and the post office is that it doesn't
deal with paper.  Instead it accepts, stores and forwards binary blobs of data
("messages").

[Learn more about RabbitMQ](https://www.rabbitmq.com/tutorials/tutorial-one-ruby.html).

[RabbitMQ]: https://www.rabbitmq.com/
[AMQP]: https://www.rabbitmq.com/tutorials/amqp-concepts.html

## Connecting to the RabbitMQ web control panel

Run `gds govuk connect rabbitmq -e integration aws/rabbitmq` and point your
browser at <http://127.0.0.1:15672>.

## How we run RabbitMQ

### Overview

![A graph showing the message flow](images/rabbitmq_graph.png)

**Exchanges** are AMQP entities where messages are sent. They take a message
and route it into zero or more queues. The routing algorithm used depends on
the exchange type and rules called _bindings_.  When a content change is made
in a publishing application (e.g. Travel Advice Publisher), Publishing API
[sends a message][publishing_api_send_message] to our main exchange,
`publishing_documents`.

Once you have [connected to the control panel][rabbitmq-control], you can view
a [list of our exchanges][exchanges].

[rabbitmq-control]: #connecting-to-the-rabbitmq-web-control-panel
[exchanges]: http://127.0.0.1:15672/#/exchanges

**Queues** in the AMQP model queues are very similar to queues in other message
and task-queueing systems: they store messages that are consumed by
applications. An example of a queue is `email_alert_service` which is used by
[email-alert-service][email-alert-service] to forward publishing activity to
email-alert-api. Queues are [created by consumer
applications](https://github.com/alphagov/email-alert-service/blob/f8485df2f0916285ade33a9cb1e4a7e73c2491ad/lib/tasks/message_queues.rake#L9).

You can see the list of all our queues [here](http://127.0.0.1:15672/#/queues) in the control panel.

**Bindings** are rules that exchanges use (among other things) to route
messages to queues. To instruct an exchange E to route messages to a queue Q, Q
has to be bound to E. Bindings may have an optional routing key attribute. An
example of a binding is the `cache_clearing_service-high` queue is bound the
`published_documents` exchange with a routing key matching of `*.major`. This
means that messages sent to the exchange with a routing key of `guide.major`
will be routed to that queue.

You can see the list of all the bindings defined on the `publishing_documents`
exchange [here](http://127.0.0.1:15672/#/exchanges/%2F/published_documents) in
the control panel.

**Messages** have attributes (e.g. content type, content encoding, routing key,
etc.) and a payload. Some message attributes are used by RabbitMQ, but most are
open to interpretation by applications that receive them. Optional attributes
are known as headers, similar to X-Headers in HTTP. Message attributes are set
when a message is published.  In our use case, the message's payload is the
content item in JSON format.

You can see message activity and metrics on any given queue's page in the control panel,
e.g. the [email_alert_service queue](http://127.0.0.1:15672/#/queues/%2F/email_alert_service).

**Consumer applications** - like [email-alert-service][email-alert-service] are
responsible for configuring queues
[here](https://github.com/alphagov/email-alert-service/blob/f8485df2f0916285ade33a9cb1e4a7e73c2491ad/config/rabbitmq.yml)
and
[here](https://github.com/alphagov/email-alert-service/blob/master/lib/tasks/message_queues.rake#L17),
and [running the individual message
processors](https://github.com/alphagov/email-alert-service/blob/f8485df2f0916285ade33a9cb1e4a7e73c2491ad/lib/tasks/message_queues.rake#L21).
For an example of a processor, see the
[MajorChangeMessageProcessor][major_change_message_processor].  All our
consumer applications use the
[govuk_message_queue_consumer](https://github.com/alphagov/govuk_message_queue_consumer)
gem to consume messages from RabbitMQ in a standardised way.

### Federated `published_documents` exchange

A federated exchange is connected to an upstream exchanges by AMQP and the
messages published to the upstream exchanges are copied over to the federated
exchange.

While the migration of GOV.UK from Carrenza to AWS is ongoing, we run two RabbitMQ clusters,
one in each environment.

The `published_documents` exchange is federated in both directions, i.e. the RabbitMQ cluster
from each provider connects as a client to the exchange in the other provider and forwards
messages to its own exchange.

There is no infinite loop because `max-hops` is set to `1`.

Each cluster has a list of private IP addresses of the other cluster's nodes. The connection
between Carrenza and AWS travels through the VPN.

Since the nodes in AWS use dynamic IP addresses, they are associated to network interfaces
with fixed IPs.

## Heartbeat messages

In order to keep consumers active and connections alive, heartbeat messages are
published to the exchanges. We currently publish heartbeat messages only to the
`published_documents` exchange, with a [rake task][heartbeat_rake_task] which
runs [every minute][whenever-scheduling] via the [whenever gem][whenever-gem].
These heartbeats only apply to certain queues for the exchange, the queues are
email-alert-service, cache_clearing_service-high and content_data_api.

## RabbitMQ metrics

A [generic RabbitMQ dashboard][rabbitmq-dashboard] shows metrics for queues and exchanges.

## Further reading

* [Read more about how we use RabbitMQ](/manual/rabbitmq.html)
* [RabbitMQ Tutorials](https://www.rabbitmq.com/getstarted.html)
* [Bunny](https://github.com/ruby-amqp/bunny) is the RabbitMQ client we use.
* [The Bunny Guides](http://rubybunny.info/articles/guides.html) explain all
  AMQP concepts really well.

[email-alert-service]: https://github.com/alphagov/email-alert-service
[whenever-scheduling]: https://github.com/alphagov/publishing-api/blob/a4a054b768b7c98fcd1448f74fe6e975ab69bb2f/config/schedule.rb#L9-L11
[whenever-gem]: https://github.com/javan/whenever
[heartbeat_rake_task]: https://github.com/alphagov/publishing-api/blob/012cb3f1ceb3b18e7059a367cc4030aa0763afb4/lib/tasks/heartbeat_messages.rake
[rabbitmq-dashboard]: https://grafana.blue.production.govuk.digital/dashboard/file/rabbitmq.json?refresh=10s&orgId=1
[publishing_api_send_message]: https://github.com/alphagov/publishing-api/blob/1d6bf06fcb74519b5c379f803ae1df65f93f74f7/lib/queue_publisher.rb#L26
[major_change_message_processor]: https://github.com/alphagov/email-alert-service/blob/2ba8ecd982c2226158b528e5442b012639797d41/email_alert_service/models/major_change_message_processor.rb#L35P
