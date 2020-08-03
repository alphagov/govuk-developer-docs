---
owner_slack: "#govuk-2ndline"
title: 'RabbitMQ: high watermark has been exceeded'
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

The RabbitMQ server detects the total amount of RAM installed on startup. By
default, when the RabbitMQ server uses above 40% of the installed RAM, it
raises a memory alarm and blocks all connections. Once the memory alarm has
cleared (e.g. due to the server paging messages to disk or delivering them to
clients) normal service resumes.

If this alert is regularly triggered it is a sign that it is time to beef up
the Rabbit boxes with more RAM. Alternatively, if you don't care about
messages, you can try to purge messages or remove unused queues.

It's also possible for this alert to trigger even if there are no free memory issues.

Under the hood, the alert queries the [RabbitMQ Management API](https://www.rabbitmq.com/management.html) and checks if the response contains `mem_alert` and `disk_free_alarm`.

The RabbitMQ Management API depends on the `rabbitmq_management` plugin being enabled. If it isn't enabled then it won't generate a response which contains `mem_alert` and `disk_free_alarm`.

To enable the plugin, connect to the server which is alerting and first disable then enable the plugin:

```
$ rabbitmq-plugins disable rabbitmq_management
$ rabbitmq-plugins enable rabbitmq_management
```

Further information
[can be found in the RabbitMQ docs](https://www.rabbitmq.com/memory.html).
