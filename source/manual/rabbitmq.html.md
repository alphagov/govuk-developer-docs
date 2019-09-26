---
owner_slack: "#govuk-2ndline"
title: Manage RabbitMQ
section: Infrastructure
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-07-18
review_in: 6 months
---

## How we run RabbitMQ

We run a RabbitMQ cluster, which is used to trigger events when
documents are published. The general process is that messages are
published onto "exchanges" in RabbitMQ. Applications create "queues"
which listen to the exchanges, and gather the messages sent to the
exchanges together. Applications then run "consumers" which receive
messages from the queues.

While the migration of gov.uk to AWS is in progress we actually run
two clusters, one in carrenza and one in AWS.
The published_documents exchange is federated in both directions, which
means that the cluster in AWS connects as a client to the exchange in 
Carrenza and forward messages to its own exchange, and the same thing 
happens the other way around, there is no loop because max-hops is set to 1.
Each cluster has a list of the other's nodes IPs, those are private IP
and connection goes through the VPN between Carrenza and AWS.
Since the nodes in AWS use non fixed IPs, they have additional
network interfaces with a fixed IP associated to it.
If a consumer is trying to get to a queue that originates on the other
side of the VPN and the queue is empty, you should check if the 
federation is ok.

In order to ensure that our consumers remain active, we publish
"heartbeat" messages to the exchanges every minute. This helps to avoid
problems with consumers dropping their connections due to inactivity,
but also allows us to monitor activity easily.

### Sending heartbeats

Heartbeat messages are sent every minute by cron. Currently, we only
send heartbeat messages to one exchange: the `published_documents`
exchange. These heartbeats are sent via a [rake task][heartbeat_rake_task]
in the `publishing-api` app.

[heartbeat_rake_task]: https://github.com/alphagov/publishing-api/blob/012cb3f1ceb3b18e7059a367cc4030aa0763afb4/lib/tasks/heartbeat_messages.rake

### Checking if the federation is ok

Connect to one of the cluster's nodes through ssh via the jumpbox.
As root run:

```bash
$ rabbitmqctl eval 'rabbit_federation_status:status().'
```

you should get: {status,running}
If not something is wrong and the federation is broken.
Check the logs in /var/log/rabbitmq and verify that the credentials and
IPs address for the federation are correct by running as root :

```bash
$ rabbitmqctl list_parameters
```

## Viewing RabbitMQ metrics

Metrics from RabbitMQ are collected with a CollectD plugin, and are
available in Graphite/Grafana. There is a [generic RabbitMQ
dashboard][rabbitmq-dashboard] which shows the main metrics for queues
and exchanges.

[rabbitmq-dashboard]: https://grafana.publishing.service.gov.uk/dashboard/file/rabbitmq.json

## Connecting to the RabbitMQ web control panel

1.  Create an SSH tunnel to access the web control panel

    For Carenza environments:

    ```bash
    $ ssh rabbitmq-1.backend.staging -L 15672:127.0.0.1:15672
    ```

    For AWS environments:

    ```bash
    $ ssh $(ssh integration "govuk_node_list --single-node -c rabbitmq").integration -CNL 15672:127.0.0.1:15672
    ```

2.  Log in to the web control panel

    Point your browser at <http://127.0.0.1:15672>

    The username is root. The password you can obtain from the govuk-secrets
    repo if you have access. Look for govuk\_rabbitmq::root\_password in the file for the
    relevant environment in
    <https://github.com/alphagov/govuk-secrets/tree/master/puppet/hieradata> or <https://github.com/alphagov/govuk-secrets/tree/master/puppet_aws/hieradata>

3.  Do your business
4.  Tidy up

    Close the SSH connection you set up earlier with CTRL+C or by typing
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

    > **Note**
    >
    > Fetching messages actually removes them from the queue. By leaving
    the "Requeue" option set to "Yes", they will be added back to queue.

3.  Delete the messages

    > **Note**
    >
    > There is a risk that you might delete the wrong message(s). This
    > is because the contents of the queue may have changed.

    Repeat, but change the "Requeue" option to "No".

## Previewing a message for a document_type

The publishing API generates messages when content is updated and posts them
to the rabbitMQ exchange. Each message has a shared format, however the contents
of the message is affected by the publishing app and what data it sends to the
publishing API.

As messages for different formats can vary, we have created a rake task in the
publishing API app to allow us to easily generate example messages. The example
message is generated from the most recently published message (based off of
last public_updated_at) for the entered document type:

```bash
$ bundle exec rake queue:preview_recent_message[<document_type>]
```

## Connecting to your local RabbitMQ

Your local RabbitMQ is running as long as your development VM is running.
To see the control panel go to <http://dev.gov.uk:15672>.

On the development VM the credentials are just root/root.
