---
owner_slack: "#re-govuk"
title: Remove a machine
parent: "/manual.html"
layout: manual_layout
section: Infrastructure
---

Before you start, make sure that the machines you are removing are no longer
needed for anything.

## Carrenza

## 1. Remove the node from the puppetmaster

You need to remove the nodes from the puppetmaster in each environment.
This is needed to clean up exported resources from Puppet, including
removing checks from Icinga.

First, disable Puppet on the machines you wish to remove.

Next, SSH into the puppetmaster for the environment:

```console
$ ssh puppetmaster-1.management.production
```

Then run this on each machine:

```console
$ govuk_node_clean <machine_name>
```

Where `<machine_name>` might be `machine-name-1.vdc-name.production` (Carrenza)
To find the names of the machines, you can list the nodes on puppetmaster:

```console
$ sudo puppet cert list --all
```

If `govuk_node_clean` was successful, you will get output like:

```bash
Submitted 'deactivate node' for redirector-1.redirector.production with UUID 0fb445ff-d660-41eb-b6d2-eca40447d4bf
Notice: Revoked certificate with serial 127
Notice: Removing file Puppet::SSL::Certificate redirector-1.redirector.production at '/etc/puppet/ssl/ca/signed/redirector-1.redirector.production.pem'
```

After this, Icinga will forget about the machine when it next
runs Puppet. You can force this with:

```console
$ ssh monitoring-1.management.production
$ govuk_puppet --test
```

You may need to wait a few minutes, but it should then disappear from
the "Host Detail" page in Icinga.

### 2. Remove from vCloud Director

Sign in to the vCloud Director instance for the given environment.
Go to 'My Cloud', search for the given machine, stop it, and then
delete it.

### 3. Remove from govuk-provisioning

If your machine class matches a vDC, be careful not to remove firewall
rules that apply to the vDC.

## AWS

### 1. Remove from Terraform

If you're removing a class of machines, first [deploy Terraform][terraform]
for the relevant project using the `destroy` action. This will remove all the
EC2 instances.

Then, remove the project itself from [govuk-aws][].

If you're removing a single machine, change the `asg_size` for the
relevant project in [govuk-aws-data][]
([example][whitehall-backend-asg-size]) and deploy Terraform.  Unlike
Carrenza, it is not possible to disable alerts for the machine before
it is removed, as the ASG will terminate arbitrary instances to shrink
to the desired size.

If there are particular machines in the ASG that you do not want terminated
you can enable "Scale in Protection" on them before you reduce the size of the ASG. You
can find [more information on this in the AWS Docs](https://docs.aws.amazon.com/autoscaling/ec2/userguide/as-instance-termination.html).

[terraform]: /manual/deploying-terraform.html#ci-jenkins
[govuk-aws]: https://github.com/alphagov/govuk-aws/tree/master/terraform/projects
[govuk-aws-data]: https://github.com/alphagov/govuk-aws-data/tree/master/data
[whitehall-backend-asg-size]: https://github.com/alphagov/govuk-aws-data/blob/master/data/app-whitehall-backend/production/common.tfvars#L4

### 2. Remove the node from the puppetmaster

Icinga will forget about the machine after Puppet runs on the
puppetmaster and then on the monitoring machine, which could be up to
an hour.  You can force this by running Puppet on the puppetmaster:

```console
$ gds govuk connect -e <environment> ssh puppetmaster
$ govuk_puppet --verbose
```

And then on the monitoring machine:

```console
$ gds govuk connect -e <environment> ssh monitoring
$ govuk_puppet --verbose
```

## Removing a class of machine

If you are removing a class of machines, you will need to [remove the definitions][def] from Puppet.

[def]: https://github.com/alphagov/govuk-puppet/commit/8a971370a4b35de09a2e1a83ce3421f41f5d0520
