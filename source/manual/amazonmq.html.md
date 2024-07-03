---
owner_slack: "#govuk-publishing-platform"
title: Manage Amazon MQ
section: Infrastructure
layout: manual_layout
parent: "/manual.html"
---

[RabbitMQ] is a message broker based on the [Advanced Message Queuing
Protocol][AMQP] (AMQP). Publishing's RabbitMQ cluster is hosted using [Amazon MQ].

[Learn more about RabbitMQ][rabbitmq_tutorial].

## Connect to the RabbitMQ web control panel

1. Install the [krelay](https://github.com/knight42/krelay#installation) kubectl plugin.

    ```sh
    brew install knight42/tap/krelay
    ```

1. Obtain admin credentials to access the GOV.UK EKS Cluster

    ```sh
    # Obtain IAM credentials for the AWS account (integration, staging, production).
    eval $(gds aws govuk-<environment>-admin -e --art 8h)

    # Select the corresponding kubectl context (or create a new admin context if needed)
    kubectl config use-context <your-admin-context-name>
    ```

1. Forward the RabbitMQ HTTPS port to your local machine.

    ```sh
    k relay host/publishingmq.<environment>.govuk-internal.digital 4430:443
    ```

1. Open <https://localhost:4430/> in your browser. The TLS certificate will not match `localhost`, so navigate past the certificate warnings. In Chrome, you can set <chrome://flags/#allow-insecure-localhost> if you prefer.

1. Log into the RabbitMQ Management web interface. The username is `root` and the passwords for each environment are in `2ndline/publishing-amazonmq` in [Secrets Manager](secrets-manager.html) in the **production** AWS account.

## Amazon MQ metrics

A [generic Amazon MQ dashboard][amazonmq-dashboard] shows metrics for queues and exchanges.

## How we run RabbitMQ

### Overview

![A graph showing the message flow](images/rabbitmq_graph.png)

**Producer**: an application that publishes messages to RabbitMQ. On GOV.UK this could
be [publishing-api](https://github.com/alphagov/publishing-api).

**Exchanges** are AMQP entities where messages are sent. They take a message
and route it into zero or more queues. The routing algorithm used depends on
the exchange type and rules called _bindings_.  When a content change is made
in a publishing application (e.g. Travel Advice Publisher), Publishing API
[publishes a message][publishing_api_publishes_message] to our main exchange,
`publishing_documents`.

**Queues** are very similar to queues in other message and task-queueing
systems: they store messages that are consumed by applications. An example of a
queue is `email_alert_service` which is used by
[email-alert-service][email-alert-service] to forward publishing activity to
email-alert-api. Queues are [created by consumer applications][create_queues].

**Bindings** are rules that exchanges use (among other things) to route
messages to queues. To instruct an exchange E to route messages to a queue Q, Q
has to be bound to E. Bindings may have an optional routing key attribute. An
example of a binding is the `email_alert_service` queue is
[bound][binding_config] to the `published_documents` exchange with a routing
key matching of `*.major`. E.g messages sent to the exchange with a routing key
of `guide.major` will be routed to that queue.

**Messages** consist of a JSON payload and publish options (we predominantly
use content type, routing key and persistant).

Options:

* content_type (string) - tells the consumer the type of message. E.g
  `"application/json"`
* routing_key (string) - matches against bindings to filter messages to certain
  queues. E.g `"guide.major"`
* persistant (boolean) - tells RabbitMQ whether to save the message to disk.

Message options are set when a message is published. In our use case, the
message's payload is the content item in JSON format. The code in the
publishing-api to publish a message is [here][publish_message_call].

**Consumer applications** are applications which consume messages from one or
more queues. For email-alert-service this is done by [running this rake
task][message_processors] and using the [major change
processor][major_message_processor] to do the processing of the consumed
messages. All our consumer applications use the
[govuk_message_queue_consumer][message_consumer] gem to consume messages from
RabbitMQ in a standardised way.

You can see live examples of things like queues, exchanges, bindings etc by
connecting to the RabbitMQ control panel (see above).

## Further reading

* [RabbitMQ Tutorials](https://www.rabbitmq.com/getstarted.html)
* [Amazon MQ documentation][Amazon MQ]
* [Bunny](https://github.com/ruby-amqp/bunny) is the RabbitMQ client we use.
* [The Bunny Guides](http://rubybunny.info/articles/guides.html) explain AMQP
  concepts.

[rabbitmq_tutorial]: https://www.rabbitmq.com/tutorials/tutorial-one-ruby.html
[Amazon MQ]: https://aws.amazon.com/amazon-mq/
[RabbitMQ]: https://www.rabbitmq.com/
[AMQP]: https://www.rabbitmq.com/tutorials/amqp-concepts.html
[amazonmq-dashboard]: https://grafana.eks.production.govuk.digital/d/mq/
[create_queues]: https://github.com/alphagov/email-alert-service/blob/f8485df/lib/tasks/message_queues.rake#L9
[publishing_api_publishes_message]: https://github.com/alphagov/publishing-api/blob/1d6bf06/lib/queue_publisher.rb#L26
[publish_message_call]: https://github.com/alphagov/publishing-api/blob/1d6bf06/lib/queue_publisher.rb#L73
[rabbit_config_rake]: https://github.com/alphagov/email-alert-service/blob/main/lib/tasks/message_queues.rake#L17
[rabbit_config_yml]: https://github.com/alphagov/email-alert-service/blob/f8485df/config/rabbitmq.yml
[message_processors]: https://github.com/alphagov/email-alert-service/blob/f8485df/lib/tasks/message_queues.rake#L21
[message_consumer]: https://github.com/alphagov/govuk_message_queue_consumer
[email-alert-service]: https://github.com/alphagov/email-alert-service
[major_message_processor]: https://github.com/alphagov/email-alert-service/blob/2ba8ecd/email_alert_service/models/major_change_message_processor.rb#L35P
[binding_config]: https://github.com/alphagov/govuk-aws/blob/854bf0a/terraform/projects/app-publishing-amazonmq/publishing-rabbitmq-schema.json.tpl#L260-L267
