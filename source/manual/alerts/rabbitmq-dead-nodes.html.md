---
owner_slack: "#govuk-2ndline-tech"
title: 'RabbitMQ: Dead nodes in cluster'
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---


This can happen if one of the machines in the cluster is killed by AWS and replaced with a new machine. In this scenario, the cluster is still working, but leaving the dead node will cause problems in future. The check can be found [here][alert_check].

First, check which node is dead:

```bash
gds govuk connect -e production ssh aws/rabbitmq "sudo rabbitmqctl cluster_status"
```

If a node is dead, there will be more "nodes" than "running_nodes". Once you know the identity of the dead node, you should verify whether the machine still exists:

```bash
gds govuk connect -e production ssh aws/jumpbox "govuk_node_list -C rabbitmq"
```

If the dead node is not in the list, then it can be safely removed from the cluster. To do this, run the following with the dead node:

```bash
gds govuk connect -e production ssh aws/rabbitmq "sudo rabbitmqctl forget_cluster_node rabbit@ip-xx-xx-x-xx"
```

[rabbitmq_doc]: /manual/rabbitmq.html
[alert_check]: https://github.com/alphagov/govuk-puppet/blob/main/modules/govuk_rabbitmq/templates/check_rabbitmq_dead_nodes.cfg.erb
[restart_an_application]: /manual/restart-application.html

## Unhealthy nodes

In some cases the nodes may not actually be dead. For example, RabbitMQ believes the host is not running, but it is up and running in AWS.

To resolve this issue, identify the node that isn’t running, e.g. `rabbit@ip-10-13-4-190` and use this to SSH into the box:

```bash
ssh -J <Your user name>@jumpbox.<GOV.UK environment>.govuk.digital <Your user name>@<RabbitMQ ip address>.eu-west-1.compute.internal
```

Then restart the RabbitMQ service:

```
sudo service rabbitmq-server restart
```

## Further reading

* [How we use RabbitMQ][rabbitmq_doc]
* [Restart an application][restart_an_application]
