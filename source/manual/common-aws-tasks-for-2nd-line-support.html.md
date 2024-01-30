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

## Logging into the AWS web console

Once you've [set up AWS access](/manual/get-started.html#9-access-aws-for-the-first-time), you can log into the AWS console for the relevant environment by running:

```
gds aws govuk-<environment>-<role> -l
```

See [these notes](https://github.com/alphagov/govuk-aws-data/blob/main/data/infra-security/integration/common.tfvars#L1-L13) about the different AWS IAM roles e.g.

```
gds aws govuk-integration-readonly -l
```

It will then ask you to supply your aws-vault password, followed by your 2FA code.

## Getting help with AWS

### Read the docs

The [AWS docs](https://docs.aws.amazon.com/) are comprehensive, and the
GOV.UK developer docs explain how to do common tasks.

### Raise an AWS support request

We pay AWS for Premium Support. You are strongly encouraged to contact AWS to
help you solve problems when using AWS products. Contacting AWS Support is a
very common procedure.

See our documentation on [how to escalate to AWS
support](/manual/how-to-escalate-to-AWS-support.html)

### Internal support

Usually, 2nd-line Tech Support should be able to investigate issues related to AWS.

During working hours, one of the Site Reliability Engineers (SREs) on the
Platform Engineering or Platform Security and Reliability teams may be able to
provide advice or expert knowledge. Outside office hours, you should escalate
to AWS Support if the engineers on call can't resolve an issue themselves.

If you are experiencing an incident, refer to the [So, you're having an
incident](/manual/incident-what-to-do.html) documentation.

## Troubleshooting

### How to view ALB metrics

You can see metrics for load balancers in CloudWatch. See the AWS documentation
on [load balancer CloudWatch metrics] for more detail.

[load balancer CloudWatch metrics]: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-cloudwatch-metrics.html

### How to query Athena logs

See [how to query CDN logs](/manual/query-cdn-logs.html)

### How to identify AWS managed DB performance issues

If you find an AWS managed DB is experiencing performance issues, it's often
worth having a look at the CloudWatch metrics for the service. This might tell
you which resource is the limiting factor impacting performance.

It is also worth looking at AWS's troubleshooting documentation, such as
the [DocumentDB documentation].

[DocumentDB documentation]: https://docs.aws.amazon.com/documentdb/latest/developerguide/user_diagnostics.html

## How to restore an AWS managed DB from a backup

View the documentation on [how to backup and restore in AWS RDS].

[how to backup and restore in AWS RDS]: /manual/howto-backup-and-restore-in-aws-rds.html

## Learn

### How do we do DNS?

GOV.UK is effectively a DNS registrar for some third-level domain names, for
example service.gov.uk.

See [how GOV.UK does DNS](/manual/dns.html).

[govuk-aws]: https://github.com/alphagov/govuk-aws
