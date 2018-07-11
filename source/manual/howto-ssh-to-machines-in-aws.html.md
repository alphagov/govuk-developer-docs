---
owner_slack: "#govuk-2ndline"
title: SSH into AWS machines
section: AWS
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-07-11
review_in: 2 months
---

This document explains how to SSH into machines in AWS, as it's markedly
different than for Carrenza.

In AWS, there are no static hostnames, so we can't have
`backend-1.backend.integration` to SSH to like in Carrenza. EC2 instances have
dynamically assigned IPs, which means hostnames like
`ip-10-1-5-53.eu-west-1.compute.internal`. Each Puppeted instance has a "node
class" (backend, frontend, ...), and the list of instances belonging to these
classes is accessible via `govuk_node_list` when logged onto the environment.

To help connecting to the environments, there is a wrapper tool called [`govukcli`](https://github.com/alphagov/govuk-aws/blob/master/tools/govukcli).

## Install

Ensure you have cloned the `govuk-aws` repository:

```
cd ~/govuk
git clone https://github.com/alphagov/govuk-aws
```

Add a symlink to ensure you use the current version:

```
ln -s ~/govuk/govuk-aws/tools/govukcli /usr/local/bin/govukcli
```

## Connecting to instances

The tool uses the idea of "contexts", where a "context" is a specific environment.

To view the contexts run:

`govukcli list-contexts`

Set a context to interact with that environment:

`govukcli set-context integration`

### AWS

In AWS you must specify a node class only. You must use `_` rather than `-` when specifying
the class.

`govukcli ssh calculators_frontend`

This will take you to a random instance of that class.

If you wish to go to a specific node, you can log into the jumpbox:

`govukcli ssh jumpbox`

Return a list of available instances:

`govuk_node_list -c calculators_frontend`

Use the SSH command to connect to a specific hostname.

### Carrenza

If the environment you're using is in Carrenza, you can connect to instances in
the traditional way:

`govukcli ssh backend-1`

You may also use the node class to select a random node:

`govukcli ssh calculators_frontend`

### Troubleshooting

Sometimes you might try to ssh into a server and nothing happens, double check that you added the key into the keychain like so: `ssh-add -K ~/.ssh/id_rsa`.

If that doesn't work run `GOVUKCLI_OUTPUT=debug govukcli ssh backend`
