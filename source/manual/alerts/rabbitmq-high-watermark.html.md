---
owner_slack: "#govuk-2ndline"
title: 'RabbitMQ: high watermark has been exceeded'
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2019-04-01
review_in: 6 months
---

The RabbitMQ server detects the total amount of RAM installed on
startup. By default, when the RabbitMQ server uses above 40% of the
installed RAM, it raises a memory alarm and blocks all connections. Once
the memory alarm has cleared (e.g. due to the server paging messages to
disk or delivering them to clients) normal service resumes.

If this alert is regularly triggered it is a sign that it is time to
beef up the Rabbit boxes with more RAM. Alternatively, if you don't care
about messages, you can try to purge messages or remove unused queues.

Further information [can be found in the RabbitMQ docs](https://www.rabbitmq.com/memory.html)
