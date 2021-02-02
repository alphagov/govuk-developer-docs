---
owner_slack: "#govuk-2ndline"
title: Common AWS tasks for 2nd line support
section: AWS
layout: manual_layout
type: learn
parent: "/manual.html"
---

This document details some of the tasks that GOV.UK 2nd line support may
carry out regarding AWS.

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

Usually, 2nd line support should be able to investigate issues related to AWS.

During working hours, one of the Site Reliability Engineers on the replatforming
team may be able to provide advice or expert knowledge. Outside of working hours,
you should escalate to AWS support if the engineers on call can't resolve an
issue themselves.

If you are experiencing an incident, refer to the
[So, you're having an incident][] documentation.

[So, you're having an incident]: https://docs.publishing.service.gov.uk/manual/incident-what-to-do.html

## Users

### Add a developer as an AWS admin

_**Note**: This task doesn't need to be done by 2nd line._

_**Note**: Users with production access can already assume an admin role
in every environment. Read [assuming all roles for users with production access][]._

You can modify the AWS roles that a developer can assume in the
[govuk-aws-data][] repository.

Typically this involves adding a user ARN (a line containing the person's email
address) to a list named `role_internal_admin_user_arns`.

See these two example PRs:

* https://github.com/alphagov/govuk-aws-data/pull/837
* https://github.com/alphagov/govuk-aws-data/pull/819

Once you have put up a PR to change the developer's role, you'll need to assume
the admin role in order to apply the Terraform change.

[assuming all roles for users with production access]: https://docs.publishing.service.gov.uk/manual/get-started.html#assuming-all-roles-for-users-with-production-access
[govuk-aws-data]: https://github.com/alphagov/govuk-aws-data

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

## Maintenance tasks

### Remove an instance from an Auto Scaling Group

Remove an instance from an Auto Scaling Group (ASG) when you want that instance
to stop receiving requests. For example, if you would like to reboot a machine
or if a machine is unhealthy, you would first remove that machine from the ASG.

_**Note**: There is guidance for [rebooting a machine][]._

Read [how to detach an instance from an ASG][] in the AWS documentation.

Avoid removing an instance from an ALB Target Group if the target group's
instances are managed by an ASG. Instead, simply remove the instance from the
ASG. Removing an instance from an associated ASG will remove the instance
from all target groups automatically (conversely, adding an instance to an
ASG will add the instance to associated target groups).

_**Note**: check if the ASG has just a single instance. If so, removing the
instance from the ASG may cause downtime for a service._

When removing an instance from an ASG, you can choose whether to replace that
instance in the ASG. Unless you plan on putting the instance back into the ASG
(for example, when rebooting), you'll want AWS to bring up a new instance for
you automatically, and to subsequently terminate the detached instance.

If you do not want a detached instance to serve traffic again in future, you
should terminate it. Detaching an instance from an ASG does not terminate the
instance automatically. Once connections have drained from a detached instance,
you can terminate the instance via the AWS EC2 user interface.

[rebooting a machine]: https://docs.publishing.service.gov.uk/manual/alerts/rebooting-machines.html
[how to detach an instance from an ASG]: https://docs.aws.amazon.com/autoscaling/ec2/userguide/detach-instance-asg.html

## How to restore an AWS managed DB from a backup

View the documentation on [how to backup and restore in AWS RDS][].

[how to backup and restore in AWS RDS]: https://docs.publishing.service.gov.uk/manual/howto-backup-and-restore-in-aws-rds.html

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

  Be careful here, provisioning a machine is slow, flaky and
  requires manual intervention (e.g. sometimes we need to manually run puppet
  on a new instance, must deploy apps to new instances from Jenkins).
  Check that the new instances are healthy before removing the healthy old
  instances.

## How to scale horizontally

You can increase the number of EC2 instances running in an ASG via a config
change in govuk-aws and govuk-aws-data.

In an emergency, you can also manually bump up the number of instances in
the ASG via the AWS console, but you're encouraged to use Terraform to do this,
since you'll need to make the change in Terraform anyway.

Here's an example set of PRs:

* https://github.com/alphagov/govuk-aws-data/pull/805
* https://github.com/alphagov/govuk-aws/pull/1385

You will need to apply Terraform for this to have an effect.

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

[govuk-aws]: https://github.com/alphagov/govuk-aws
[userdata scripts]: https://github.com/alphagov/govuk-aws/blob/master/terraform/userdata/20-puppet-client
[govuk-puppet]: https://github.com/alphagov/govuk-puppet
