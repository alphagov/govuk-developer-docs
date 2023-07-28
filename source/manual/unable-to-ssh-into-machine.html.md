---
owner_slack: "#govuk-2ndline-tech"
title: Unable to SSH into a machine
section: Infrastructure
layout: manual_layout
parent: "/manual.html"
---

If you are unable to SSH into a machine, there are a number of things to check.

## SSH Key

Sometimes you might try to ssh into a server and nothing happens. Double-check that you
have added the key into the keychain like so: `ssh-add -K ~/.ssh/id_rsa`.

Make sure you have been granted access. For example, if you have yet to be granted access
to production, your attempt to SSH into a production node will fail silently.

## SSH known hosts changed

If you see an error message along the lines of:

```
IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
Someone could be eavesdropping on you right now (man-in-the-middle attack)!
It is also possible that a host key has just been changed.
Add correct host key in /Users/username/.ssh/known_hosts to get rid of this message.
Offending RSA key in /Users/username/.ssh/known_hosts:14
```

It is likely that the jumpbox machine was recently reprovisioned - ask on `#govuk-2ndline-tech` to make sure.
If so, simply delete the associated line (line 14 in the example above).

## Connecting with plain SSH

[GOV.UK Connect] is a tool we use to make working with our machines quicker and
easier. If GOV.UK Connect is not working, or you don't have it set up for some
other reason, you can try manually running the commands it normally runs for
you.

- [Find the class of machine you need](/apps.html).

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

## kex_exchange_identification: Connection closed by remote host

If you are on the VPN and you are unable to connect to an instance (it hangs and then
eventually fails with `kex_exchange_identification: Connection closed by remote host`),
then the instance is unhealthy. There are probably a number of alerts associated with
the instance too.

You'll need to sign into AWS and [reprovision the instance](/manual/reprovision.html).
You may want to click the "Report instance status" button while you're there, to inform
AWS that the instance is unresponsive - this should help AWS to improve their automated
checks in the future.

## Check the system log on the AWS instance

There may be times when a system error has been logged, for example Puppet not correctly
running and populating your SSH key onto the machine.

Follow these steps to access the system log without SSHing into the machine:

1. Log into the AWS console for the relevant environment:

  ```
  gds aws govuk-integration-poweruser -l
  gds aws govuk-staging-poweruser -l
  gds aws govuk-production-poweruser -l
  ```

1. Navigate to the EC2 console and locate the relevant instance

1. From the instance summary, click 'Actions', 'Monitor and troubleshoot', then 'Get system log'
