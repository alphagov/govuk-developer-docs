---
owner_slack: "#govuk-2ndline-tech"
title: Common AWS tasks for Technical 2nd Line
section: AWS
layout: manual_layout
type: learn
parent: "/manual.html"
---

This document details some of the tasks that GOV.UK Technical 2nd Line may
carry out regarding AWS.

## Logging into AWS

Once you've [set up AWS access](/manual/get-started.html#9-access-aws-for-the-first-time), you can log into the AWS console for the relevant environment by running:

```
gds aws govuk-<environment>-<role> -l
```

See [these notes](https://github.com/alphagov/govuk-aws-data/blob/main/data/infra-security/integration/common.tfvars#L1-L13) about the different AWS IAM roles e.g.

```
gds aws govuk-integration-readonly -l
```

It will then ask you to supply your AWS vault password, followed by your 2FA code.

## Getting help with AWS

### Read the docs

The [AWS docs](https://docs.aws.amazon.com/) are comprehensive, and the
GOV.UK developer docs explain how to do common tasks.

### Raise an AWS support request

We pay AWS for Premium Support. You are strongly encouraged to contact AWS to
help you solve problems when using AWS products. Contacting AWS Support is a
very common procedure.

See our documentation on [how to escalate to AWS support][].

[how to escalate to AWS support]: https://docs.publishing.service.gov.uk/manual/how-to-escalate-to-AWS-support.html

### Internal support

Usually, Technical 2nd Line should be able to investigate issues related to AWS.

During working hours, one of the Site Reliability Engineers on the Platform Engineering
team may be able to provide advice or expert knowledge. Outside of working hours,
you should escalate to AWS support if the engineers on call can't resolve an
issue themselves.

If you are experiencing an incident, refer to the
[So, you're having an incident][] documentation.

[So, you're having an incident]: https://docs.publishing.service.gov.uk/manual/incident-what-to-do.html

## Troubleshooting

### How to view ALB metrics

You can see metrics for load balancers in CloudWatch. See the AWS documentation
on [load balancer CloudWatch metrics][] for more detail.

[load balancer CloudWatch metrics]: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-cloudwatch-metrics.html

### How to query Athena logs

See the documentation on [how to query CDN logs][].

[how to query cdn logs]: https://docs.publishing.service.gov.uk/manual/query-cdn-logs.html

### How to identify AWS managed DB performance issues

If you find an AWS managed DB is experiencing performance issues, it's often
worth having a look at the CloudWatch metrics for the service. This might tell
you which resource is the limiting factor impacting performance.

It is also worth looking at AWS's troubleshooting documentation, such as
the [DocumentDB documentation][].

[DocumentDB documentation]: https://docs.aws.amazon.com/documentdb/latest/developerguide/user_diagnostics.html

## How to analyse and find out the performance limiting factor of an EC2 instance

EC2 instances have limits on CPU, memory, network, and storage, which can
impact application performance. To identify the machine resource that is the
performance limiting factor, visit the [machine metrics dashboard][] (in the
relevant environment!), which shows CPU, memory, disk, and TCP stats.
This should help you find bottlenecks.

You can also see the [EC2 troubleshooting documentation][] and contact AWS Support.

[machine metrics dashboard]: https://grafana.blue.production.govuk.digital/dashboard/file/machine.json?refresh=1m&orgId=1
[EC2 troubleshooting documentation]: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-troubleshoot.html

## Detaching an instance from an Auto Scaling Group

Log into the AWS console for the relevant environment:

  ```
  gds aws govuk-integration-poweruser -l
  gds aws govuk-staging-poweruser -l
  gds aws govuk-production-poweruser -l
  ```

First, make a note of the instance ID in case you need to investigate the logs later
following an incident. If you forget to do this, follow the instructions below on
how to find a detached instance.

Refer to the AWS documentation on steps for on [how to detach an instance from an ASG][]

If a machine is unhealthy, you may want to detach an instance from its Auto
Scaling Group (ASG). Detaching the instance stops it receiving requests.

Avoid removing an instance from an ALB Target Group if the target group's
instances are managed by an ASG. Instead, simply remove the instance from the
ASG. Removing an instance from an associated ASG will remove the instance
from all target groups automatically (conversely, adding an instance to an
ASG will add the instance to associated target groups).

When detaching an instance from an ASG, you can choose whether to replace that
instance in the ASG via a checkbox in the detach confirmation window: 'Add a
new instance to the Auto Scaling group to balance the load'. This option will
need to be selected, otherwise an error will likely be thrown, as by default,
the ASG's minimum capacity of instances will be equal to the amount instances
running (desired capacity).

_**Note**: check if the ASG has just a single instance. If so, removing the
instance from the ASG may cause downtime for a service._

The detached instance will stick around, so make sure to
terminate it when you no longer need it. See the section below for further details.

[how to detach an instance from an ASG]: https://docs.aws.amazon.com/autoscaling/ec2/userguide/detach-instance-asg.html#detach-instance-console

## How to find a detached instance

If you made a note of the instance id before you detached it, you should be able to find it in
the console. If you forgot this step, you can work out which is the detached instance for an
application by comparing the instances you get for the application under 'instances' (which displays all instances)
and the instances you get for an application by looking at the ASG for that application's instances
(which displays only attached instances).

## Logging into a detached instance

When you've found the detached instance in the AWS console, you can click on the instance ID column to get the summary. This includes the private IP. Copy this, and use it with the gds govuk connect command instead of an app/machine type, eg:

`gds govuk connect ssh -e integration ip-10-1-4-96.eu-west-1.compute.internal`

## Terminating an instance

Refer to the AWS documentation for steps on [how to terminate an instance][].

If you do not want a detached instance to serve traffic again in future, you
should terminate it. Detaching an instance from an ASG does not terminate the
instance automatically. Once connections have drained from a detached instance,
you can terminate the instance via the AWS EC2 user interface.

[how to terminate an instance]: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/terminating-instances.html#terminating-instances-console

Note that when you've detached and terminated an instance, you may get sentry alerts from puppet about healthchecks for the affected application(s) not
returning OK, as it still expects the old instance to be healthy. These should disappear when puppet next runs (every 30 minutes) and picks up the
new instance.

## How to scale up vertically

You can increase the resources for EC2 instances by modifying the instance type in govuk-aws-data.

We typically make this change very gradually. The process usually looks like this:

1. Merge a PR changing the instance type (example: https://github.com/alphagov/govuk-aws-data/pull/827)
2. Apply the Terraform change to all environments
3. In the AWS UI, cycle the running instances gradually, to avoid downtime.

  Cycling an instance might involve removing the smaller instances one by one,
  waiting for connections to the instance to drain, and then killing the
  instance. This will prompt AWS to bring up the new bigger instances
  automatically.

  Be careful here, [provisioning a machine](#how-are-instances-provisioned) is
  slow, flaky and requires manual intervention (e.g. sometimes we need to
  manually run puppet on a new instance, must deploy apps to new instances from
  Jenkins). Check that the new instances are healthy before removing the
  healthy old instances.

## How to scale horizontally

You can increase the number of EC2 instances running in an ASG via a config
change in govuk-aws and govuk-aws-data.

In an emergency, you can also [manually bump up the number of instances in the
ASG via the AWS console][], but you're encouraged to use Terraform to do this,
since you'll need to make the change in Terraform anyway.

Here's an example set of PRs:

* https://github.com/alphagov/govuk-aws-data/pull/805
* https://github.com/alphagov/govuk-aws/pull/1385

You will need to apply Terraform for this to have an effect.

[manually bump up the number of instances in the ASG via the AWS console]: https://docs.publishing.service.gov.uk/manual/auto-scaling-groups.html#removing-a-specific-instance

## How to restore an AWS managed DB from a backup

View the documentation on [how to backup and restore in AWS RDS][].

[how to backup and restore in AWS RDS]: https://docs.publishing.service.gov.uk/manual/howto-backup-and-restore-in-aws-rds.html

## How to resize a persistent disk

If you're not sure how to do this, ask an Site Reliability Engineer to give you a walk through.

See the docs: https://docs.publishing.service.gov.uk/manual/manually-resize-ebs.html.

## How to replace an instance with a persistent disk

_If you're not sure how to do this, ask an Site Reliability Engineer to give
you a walk through._

Assuming we want to destroy and recreate a VM, but have the new VM attach to the
old persistent disk

1. Find the VM and note down the details of the persistent volume you want to keep
1. Shutdown the VM
1. Detach the EBS volume from the VM.
1. Delete the VM
1. Run terraform apply which will now recreate the VM
1. Manually re-attach the EBS volume to the new VM
1. Reboot the machine to make sure the persistent disk reattaches between reboots
1. Initiate a puppet run to make sure that everything works

## Learn

### How do we do DNS?

See the documentation on [how GOV.UK does DNS][].

GOV.UK manages the DNS for other domain names used by third parties, for example
service.gov.uk. At the moment this will remain with the SREs until further
decisions have been made.

[how GOV.UK does DNS]: https://docs.publishing.service.gov.uk/manual/dns.html

## How are instances provisioned?

We typically use Terraform config in [govuk-aws][] to provision infrastructure,
such as EC2 instances.

There are a few exceptions to this, such as ad-hoc instances started from
Concourse via the AWS CLI - these are mainly for data science projects.

We use [userdata scripts][] to run commands on our instances at launch. These
scripts install various core bits of software needed by a particular instance
and then typically use [govuk-puppet][] to provision our instances.

Finally, new instances send Jenkins their Fully Qualified Domain Name (FQDN)
and puppet class. Jenkins automatically [deploys apps][] to newly provisioned
instances.

[govuk-aws]: https://github.com/alphagov/govuk-aws
[userdata scripts]: https://github.com/alphagov/govuk-aws/blob/master/terraform/userdata/20-puppet-client
[govuk-puppet]: https://github.com/alphagov/govuk-puppet
[deploys apps]: https://deploy.integration.publishing.service.gov.uk/job/Deploy_Node_Apps/
