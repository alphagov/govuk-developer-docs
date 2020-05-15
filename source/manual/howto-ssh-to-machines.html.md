---
owner_slack: "#govuk-developers"
title: SSH into machines
section: AWS
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2020-02-10
review_in: 6 months
---

This document explains how to SSH into machines, and what commands exist to navigate machines and applications quickly. We use a tool called [GOV.UK Connect] to make this easier.

## Usage

If you know the class of machine you want, you can SSH straight from the command line:

```sh
$ gds govuk connect -e staging ssh cache
```

This will automatically SSH into a random `cache` machine on AWS. To see all classes, run:

```sh
$ gds govuk connect -e staging ssh *
```

You can also start a Rails Console on a remote server, from your local machine:

```sh
$ gds govuk connect -e staging app-console publishing-api
```

For a full list of commands, run `gds govuk connect --help`.

## Troubleshooting

### SSH Key

Sometimes you might try to ssh into a server and nothing happens. Double-check that you
have added the key into the keychain like so: `ssh-add -K ~/.ssh/id_rsa`.

Make sure you have been granted access. For example, if you have yet to be granted access
to production, your attempt to SSH into a production node will fail silently.

### CLI Problems

The jumpbox is a special node that knows about all of the other nodes in its environment.

List the IP addresses of every node in the environment:

```sh
jumpbox$ govuk_node_list
```

This long list of IPs is not very useful on its own, but you can filter it by node class:

```sh
jumpbox$ govuk_node_list -c backend
```

And if you can't remember the names of the node classes, there's a built-in helper:

```sh
jumpbox$ govuk_node_list --classes
```

Once you have found the IP of the machine you want to SSH into, you can manually SSH
directly from the jumpbox machine:

```sh
jumpbox$ ssh ip-10-1-5-22.eu-west-1.compute.internal
```

You can also do this from your local machine by appending the environment to the address:

```sh
local$ ssh ip-10-1-5-22.eu-west-1.compute.internal.integration
```

### Application node

Now you're on the node running the application you want to explore. There are two main
ways of interacting with the running application.

You can start up an application console (typically Rails):

```sh
node$ govuk_app_console
```

...or you can start up a database console (typically PostgreSQL):

```sh
node$ govuk_app_dbconsole
```

These common commands, along with `govuk_node_list`, live in
[govuk-puppet](https://github.com/alphagov/govuk-puppet).

[GOV.UK Connect]: https://github.com/alphagov/govuk-connect
