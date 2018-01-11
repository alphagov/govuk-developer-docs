---
owner_slack: "#2ndline"
title: SSH into AWS machines
section: AWS
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-01-11
review_in: 3 months
---

This document explains how to SSH into machines in AWS, as it's markedly
different than for Carrenza.

In AWS, there are no static hostnames, so we can't have
`backend-1.backend.integration` to SSH to like in Carrenza. EC2 instances have
dynamically assigned IPs, which means hostnames like
`ip-10-1-5-53.eu-west-1.compute.internal`. Each Puppeted instance has a "node
class" (backend, frontend, ...), and the list of instances belonging to these
classes is accessible via `govuk_node_list`.

Ensure that your [SSH configuration](ssh-config.html) is up to date.

### Use SSH proxy configuration

Using the SSH configuration supplied above, you should be able to go directly
to instances using:

`ssh ip-1-2-3-4.eu-west-1.compute.internal.integration`

This is useful when responding to machines within Icinga.

If you do not know the hostname of the type of node to connect to, list them by
running:

`ssh integration "govuk_node_list -c <node type>"`

Example:

```
$ ssh integration "govuk_node_list -c backend"
ip-10-1-5-57.eu-west-1.compute.internal
ip-10-1-6-88.eu-west-1.compute.internal
```

### Agent forwarding

SSH with agent forwarding to the jumpbox:

        ssh -A friendlygiraffe@integration

2. Use `govuk_node_list` to narrow down the IP addresses you require:

        govuk_node_list -c backend

3. In most cases, you'll get multiple hostnames as the output of that command,
   for example:

        ip-10-1-5-57.eu-west-1.compute.internal
        ip-10-1-6-88.eu-west-1.compute.internal

   Choose one, and copy/paste into a normal SSH command:

        ssh ip-10-1-5-57.eu-west-1.compute.internal

5. To get to a single node, you can use the `--single-node` switch on
   `govuk_node_list`, straight into your SSH command:

        ssh `govuk_node_list -c backend --single-node`
