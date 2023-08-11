---
owner_slack: "#govuk-developers"
title: SSH into machines
section: AWS
layout: manual_layout
parent: "/manual.html"
---

# SSH into machines

This document explains how to SSH into machines, and what commands exist to navigate machines and applications quickly. We use a tool called [GOV.UK Connect] to make this easier.

## Usage

If you know the class of machine you want, you can SSH straight from the command line:

```sh
$ gds govuk connect -e staging ssh cache
```

This will automatically SSH into a random `cache` machine on AWS.

You can connect to a consistent machine by its index:

```sh
$ gds govuk connect -e staging ssh cache:1
```

To see all classes, run:

```sh
$ gds govuk connect -e staging ssh *
```

You can connect to specific machines if you know their internal IP address:

```sh
$ gds govuk connect ssh -e integration ip-10-1-6-234.eu-west-1.compute.internal
```

You can also start a Rails Console on a remote server, from your local machine:

```sh
$ gds govuk connect -e staging app-console publishing-api
```

For a full list of commands, run `gds govuk connect --help`.

## Troubleshooting

See [Unable to SSH into a machine](/manual/unable-to-ssh-into-machine.html).
