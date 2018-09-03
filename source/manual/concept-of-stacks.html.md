---
owner_slack: "#govuk-2ndline"
title: Stacks in AWS
section: AWS
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-09-03
review_in: 6 months
---

When designing the infrastructure for GOV.UK in AWS we built in the concept of
being able to deploy multiple "stacks" within a single environment.

The implementation detail is described in the
[related architectural decision record (ADR)][adr].

## Definition of a stack

A stack is a namespace for a piece of infrastructure. It is not used at an
application level and should not be visible to end users.

For example, you could build an entire infrastructure within an
[Amazon VPC][amazon-vpc] using the "stackname" of "blue".

This would deploy configuration based upon namespaced data found in
[govuk-aws-data][].

If you wished to upgrade a piece of infrastructure without interrupting the
current service, you could deploy something using the "green" stackname.

For instance, you may wish to deploy a new [Amazon RDS][amazon-rds] instance
with a newer version of a database server.

You could then specifically test this implementation by pointing an application
at the stack specific endpoint.

When you are happy with the results, you could then switch top level DNS over
and remove the older RDS instance.

[adr]: https://github.com/alphagov/govuk-aws/blob/master/doc/architecture/decisions/0015-dns-infrastructure.md
[amazon-vpc]: https://aws.amazon.com/vpc
[amazon-rds]: https://aws.amazon.com/rds/
[govuk-aws-data]: https://github.com/alphagov/govuk-aws-data
