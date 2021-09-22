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

### SSH known hosts changed

If you see an error message along the lines of:

```
IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
Someone could be eavesdropping on you right now (man-in-the-middle attack)!
It is also possible that a host key has just been changed.
Add correct host key in /Users/username/.ssh/known_hosts to get rid of this message.
Offending RSA key in /Users/username/.ssh/known_hosts:14
```

It is likely that the jumpbox machine was recently reprovisioned - ask on `#govuk-2ndline` to make sure.
If so, simply delete the associated line (line 14 in the example above).

## Connecting with plain SSH

[GOV.UK Connect] is a tool we use to make working with our machines quicker and
easier. If GOV.UK Connect is not working, or you don't have it set up for some
other reason, you can try manually running the commands it normally runs for
you.

- [Find the class of machine you need](https://docs.publishing.service.gov.uk/apps.html).

- Find [the jumpbox for the environment you need](https://github.com/alphagov/govuk-connect/blob/095d49445d25e2afe845c00b32fb35589087f292/lib/govuk_connect/cli.rb#L81).

- Use ssh to run `govuk_node_list` on the jumpbox to find the machine you want.

  ```sh
  $ ssh jumpbox.staging.govuk.digital govuk_node_list -c backend
  ip-10-12-4-106.eu-west-1.compute.internal
  ip-10-12-5-205.eu-west-1.compute.internal
  ip-10-12-6-44.eu-west-1.compute.internal
  ```

- SSH to one of the machines in the list using the jumpbox:

  ```sh
  $ ssh -J jumpbox.staging.govuk.digital ip-10-12-4-106.eu-west-1.compute.internal
  ```

- Once you're on the machine you need, you can start a Rails console.

  ```sh
  $ govuk_app_console publisher
  ```

These common commands, along with `govuk_node_list`, live in
[govuk-puppet](https://github.com/alphagov/govuk-puppet/tree/master/modules/govuk_scripts).

[GOV.UK Connect]: https://github.com/alphagov/govuk-connect
