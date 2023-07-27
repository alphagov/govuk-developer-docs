---
owner_slack: "#govuk-2ndline-tech"
title: 'AmazonMQ: High number of unprocessed messages'
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

For information about how we use RabbitMQ on AmazonMQ, see [here][amazonmq_doc].

We check that there is not a significant build up of messages compared to the
normal amounts on certain queues. The queues this alert applies to are:

* [`email_alert_service`][email_service_config]
* [`email_unpublishing`][email_unpublishing_config]
* [`subscriber_list_details_update_major`][email_subscriber_list_major_config]
* [`subscriber_list_details_update_minor`][email_subscriber_list_minor_config]

The plugin which implements this alert is [here][plugin].

The Icinga check is performed by connecting to RabbitMQ's admin API and
triggering if the number of messages on the queues listed above crosses certain
thresholds.

For the `email_alert_service`,  `email_unpublishing`,
`subscriber_list_details_update_major` and `subscriber_list_details_update_minor`
queues the [message thresholds][email_thresholds] are:
25 for critical and 5 for warning.

> **Note**
>
> You may see the [no consumers listening][no_consumers_listening] alert too,
> as issues with consumers processing messages could then lead to a high
> backlog of messages.

## Troubleshooting

For troubleshooting steps, see [here][troubleshooting_steps].

[email_service_config]: https://github.com/alphagov/govuk-puppet/blob/e769c1dc74484625cf7afdfe943c08884cc7d90d/modules/govuk/manifests/apps/email_alert_service/rabbitmq.pp#L57-L63
[email_unpublishing_config]: https://github.com/alphagov/govuk-puppet/blob/e769c1dc74484625cf7afdfe943c08884cc7d90d/modules/govuk/manifests/apps/email_alert_service/rabbitmq.pp#L81-L87
[email_subscriber_list_major_config]: https://github.com/alphagov/govuk-puppet/blob/main/modules/govuk/manifests/apps/email_alert_service/rabbitmq.pp#L73-L79
[email_subscriber_list_minor_config]: https://github.com/alphagov/govuk-puppet/blob/main/modules/govuk/manifests/apps/email_alert_service/rabbitmq.pp#65-L71
[troubleshooting_steps]: /manual/alerts/amazonmq-no-consumers-listening.html#troubleshooting
[no_consumers_listening]: /manual/alerts/amazonmq-no-consumers-listening.html
[rabbitmq_doc]: /manual/rabbitmq.html
[amazonmq_doc]: /manual/amazonmq.html
[email_thresholds]: https://github.com/alphagov/govuk-puppet/blob/8267943e08c314e0a97742fc9443b889d4cf358a/hieradata_aws/common.yaml#L577-L578
[cache_clearing_thresholds]: https://github.com/alphagov/govuk-puppet/blob/8267943e08c314e0a97742fc9443b889d4cf358a/hieradata_aws/common.yaml#L456-L457
[plugin]: https://github.com/alphagov/govuk-puppet/blob/80cff45935481a180dc9bfe8e2ab0ac8a0d80344/modules/icinga/files/usr/lib/nagios/plugins/check_rabbitmq_messages
