---
owner_slack: "#govuk-2ndline"
title: 'RabbitMQ: Dead nodes in cluster'
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2020-10-30
review_in: 12 months
---


This can happen if one of the machines in the cluster is killed by AWS and replaced with a new machine. In this scenario, the cluster is still working, but leaving the dead node will cause problems in future e.g. when we try to [reboot the machines to install updates](https://github.com/alphagov/fabric-scripts/blob/a14686667d27790f0978146634b1e4d281552b8c/rabbitmq.py#L57). The check can be found [here][alert_check].

First, you should check which node is dead:

```bash
fab production_aws class:rabbitmq rabbitmq.status
```

If a node is dead, there will be more "nodes" than "running_nodes". Once you know the identity of the dead node, you should verify whether the machine still exists:

```bash
gds govuk connect -e production ssh aws/jumpbox "govuk_node_list -C rabbitmq"
```

If the dead node is not in the list, then it can be safely removed from the cluster. To do this, SSH onto one of the RabbitMQ machines and run the following with the dead node:

```bash
sudo rabbitmqctl forget_cluster_node [dead_node e.g. rabbit@ip-10-13-5-19]
```

For information about how we use RabbitMQ, see [here][rabbitmq_doc].

[rabbitmq_doc]: https://docs.publishing.service.gov.uk/manual/rabbitmq.html
[alert_check]: https://github.com/alphagov/govuk-puppet/blob/ae1be54779ae6912fe693cc66394e6e61afccd9b/modules/govuk_rabbitmq/templates/check_rabbitmq_dead_nodes.cfg.erb
