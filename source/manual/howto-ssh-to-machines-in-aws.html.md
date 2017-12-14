---
owner_slack: "#govuk-infrastructure"
title: SSH into AWS machines
section: AWS
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2017-12-05
review_in: 1 month
---

This document explains how to SSH into machines in AWS, as it's markedly
different than for Carrenza.

In AWS, there are no static hostnames, so we can't have
`backend-1.backend.integration` to SSH to like in Carrenza. EC2 instances have
dynamically assigned IPs, which means hostnames like
`ip-10-1-5-53.eu-west-1.compute.internal`. Each Puppeted instance has a "node
class" (backend, frontend, ...), and the list of instances belonging to these
classes is accessible via `govuk_node_list`.

1. SSH with agent forwarding to the jumpbox:

        ssh -A friendlygiraffe@jumpbox.blue.integration.govuk.digital

2. Use `govuk_node_list` to narrow down the IP addresses you require:

        govuk_node_list -c backend

3. In most cases, you'll get multiple hostnames as the output of that command,
   for example:

        ip-10-1-5-53.eu-west-1.compute.internal
        ip-10-1-6-253.eu-west-1.compute.internal

   Choose one, and copy/paste into a normal SSH command:

        ssh ip-10-1-5-53.eu-west-1.compute.internal

4. If your SSH key has forwarded correctly, you will be on the new machine.

5. If you're bored of copy/paste and would like to just get to a single node,
   you can use the `--single-node` switch on `govuk_node_list`, straight into
   your SSH command:

        ssh `govuk_node_list -c backend --single-node`
