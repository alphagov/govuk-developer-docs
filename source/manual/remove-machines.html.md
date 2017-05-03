---
owner_slack: "#2ndline"
title: Remove a machine
parent: "/manual.html"
layout: manual_layout
section: Environments
last_reviewed_on: 2017-03-22
review_in: 6 months
---

# Remove a machine

If you need to remove/decommission individual machines or a class of machines,
there are several steps you need to go through.

Before you start, make sure that the machines are no longer needed for anything.

## 1. Remove the node from the puppet-master

You need to remove the nodes from the puppet-master in each environment.
This is needed to clean up exported resources from puppetdb, including
removing checks from Icinga.

First ssh into the puppet master for the environment:

```console
$ ssh puppetmaster-1.management.production
```

Then run this for each machine:

```console
$ govuk_node_clean <machine_name>
```

Where `<machine_name>` might be `machine-name-1.vdc-name.production`.
The suffix is always production. If it was successful, you will get
output like:

```bash
Submitted 'deactivate node' for redirector-1.redirector.production with UUID 0fb445ff-d660-41eb-b6d2-eca40447d4bf
Notice: Revoked certificate with serial 127
Notice: Removing file Puppet::SSL::Certificate redirector-1.redirector.production at '/etc/puppet/ssl/ca/signed/redirector-1.redirector.production.pem'
```

After this, Icinga/Nagios will forget about the machine when it next
runs Puppet. You can force this with:

```console
$ ssh monitoring-1.management.production
$ govuk_puppet --test
```

You may need to wait a few minutes, but it should then disappear from
the "Host Detail" page in Icinga/Nagios.

## 2. Remove from vCloud Director

For preview, connect to the Carrenza VPN and go to [the account page](https://vcloud.carrenza.com/cloud/org/0e7t).
Sign in, go to 'My Cloud', search for the given machine, stop it and then delete it. Repeat as
necessary.

For staging and production, sign in to the vCloud Director instance for
the given environment. Go to 'My Cloud', search for the given machine,
stop it, and then delete it.

## 3. Remove from govuk-provisioning

If your machine class matches a VDC, be careful not to remove firewall
rules that apply to the VDC. [See this PR for an example](https://github.gds/gds/govuk-provisioning/pull/141).

## 4. Remove from puppet

If you are removing the class of machines, you will need to [remove the definitions][def] from Puppet.

[def]: https://github.com/alphagov/govuk-puppet/commit/8a971370a4b35de09a2e1a83ce3421f41f5d0520
