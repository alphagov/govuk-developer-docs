---
owner_slack: "#2ndline"
title: RabbitMQ
section: Tools
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/2nd-line/rabbitmq.md"
last_reviewed_on: 2017-02-25
review_in: 6 months
---

## How we run RabbitMQ

We run a RabbitMQ cluster, which is used to trigger events when
documents are published. The general process is that messages are
published onto "exchanges" in RabbitMQ. Applications create "queues"
which listen to the exchanges, and gather the messages sent to the
exchanges together. Applications then run "consumers" which receive
messages from the queues.

In order to ensure that our consumers remain active, we publish
"heartbeat" messages to the exchanges every minute. This helps to avoid
problems with consumers dropping their connections due to inactivity,
but also allows us to monitor activity easily.

### Sending heartbeats

Heartbeat messages are sent every minute by cron. Currently, we only
send heartbeat messages to one exchange: the `published_documents`
exchange. These heartbeats are sent via a rake task in the
`content-store` app.
## Connecting to the RabbitMQ web control panel

1.  Create an SSH tunnel to access the web control panel

For example for integration:

> ssh rabbitmq-1.backend.integration -L 15672:127.0.0.1:15672

2.  Log in to the web control panel

Point your browser at <http://127.0.0.1:15672>

The username is root. The password you can obtain from the deployment
repo. Look for govuk\_rabbitmq::root\_password in the file for the
relevant environment in:

<https://github.gds/gds/deployment/tree/master/puppet/hieradata>

3.  Do your business
4.  Tidy up

Close the ssh connection you set up earlier with CTRL+C or by typing
"exit".

## Inspecting/removing items from a queue

We had an instance where an application was unable to process a message
in the queue, but left the message on the queue. This meant it was
backing up. Removing the message from the queue was the right solution
in our case.

1.  Find the queue

Click on the "Queues" tab. Then click on the name of the queue.

2.  Find the messages

Scroll down and click "Get messages". Clicking the "Get Message(s)"
button that appears will fetch however many messages you ask for.

Note: Fetching messages actually removes them from the queue. By leaving
the "Requeue" option set to "Yes", they will be added back to queue.

3.  Delete the messages

Note: there is a risk that you might delete the wrong message(s). This
is because the contents of the queue may have changed.

Repeat, but change the "Requeue" option to "No".
