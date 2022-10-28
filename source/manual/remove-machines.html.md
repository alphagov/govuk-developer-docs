---
owner_slack: "#govuk-2ndline-tech"
title: Remove a machine
parent: "/manual.html"
layout: manual_layout
section: Infrastructure
---

Before you start, make sure that the machines you are removing are no longer
needed for anything.

## Removing a class of machine

If you are removing a class of machines, you will need to [remove the definitions][def] from Puppet.

[def]: https://github.com/alphagov/govuk-puppet/commit/8a971370a4b35de09a2e1a83ce3421f41f5d0520

### 1. Remove from Terraform

Firstly, [deploy Terraform][terraform] for the relevant project using the `destroy` action. This will remove all the EC2 instances.

Then, remove the project itself from [govuk-aws][].

If you're removing a single machine, change the `asg_size` for the
relevant project in [govuk-aws-data][]
([example][whitehall-backend-asg-size]) and deploy Terraform.
It is not possible to disable alerts for the machine before
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
