---
owner_slack: "#govuk-developers"
title: How to raise a support ticket with AWS

section: AWS
layout: manual_layout
type: learn
parent: "/manual.html"
---

Sign in to the AWS Management Console.

`gds aws <command> -l`

Where `<command>` maps to an AWS account and IAM role you have permissions to assume into. This should be the AWS account that the problem is associated with e.g. `govuk-production-poweruser`.

Then follow steps 2-6 in the official AWS docs: [Creating a support case](https://docs.aws.amazon.com/awssupport/latest/user/case-management.html#creating-a-support-case)
