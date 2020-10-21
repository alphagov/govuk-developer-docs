---
owner_slack: "#govuk-developers"
title: SSH into machines
section: AWS
layout: manual_layout
parent: "/manual.html"
---

This document explains how to SSH into machines, and what commands exist to navigate machines and applications quickly. We use a tool called [GOV.UK Connect] to make this easier.

## Usage

If you know the class of machine you want, you can SSH straight from the command line:

```sh
$ gds govuk connect -e staging ssh cache
```

This will automatically SSH into a random `cache` machine on AWS.

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

### SSH Key

Sometimes you might try to ssh into a server and nothing happens. Double-check that you
have added the key into the keychain like so: `ssh-add -K ~/.ssh/id_rsa`.

Make sure you have been granted access. For example, if you have yet to be granted access
to production, your attempt to SSH into a production node will fail silently.

### CLI Problems

[GOV.UK Connect] is a tool we use to make working with our machines quicker and easier. If
it's not working, you can try manually running the commands it normally runs for you.

- [Find the class of machine you need (and which cloud it lives in)](https://docs.publishing.service.gov.uk/apps.html).

- Find [the jumpbox for the environment you need](https://github.com/alphagov/govuk-connect/blob/fcbe054874c84968b6af97e45005b00bc5aa285a/lib/govuk_connect/cli.rb#L81).

- SSH to the jumpbox.

  ```sh
  $ ssh -A jumpbox.staging.govuk.digital
  ```

- On the jumpbox, run `govuk_node_list` to find the machine you want.

  ```sh
  $ govuk_node_list -c backend
  ip-10-12-4-106.eu-west-1.compute.internal
  ip-10-12-5-205.eu-west-1.compute.internal
  ip-10-12-6-44.eu-west-1.compute.internal
  ```

- Still on the jumpbox, SSH to one of the machines in the list.

  ```sh
  $ ssh ip-10-12-4-106.eu-west-1.compute.internal
  ```

- Once you're on the machine you need, you can start a Rails console.

  ```sh
  $ govuk_app_console publishing-api
  ```

These common commands, along with `govuk_node_list`, live in
[govuk-puppet](https://github.com/alphagov/govuk-puppet/tree/master/modules/govuk_scripts).

[GOV.UK Connect]: https://github.com/alphagov/govuk-connect
