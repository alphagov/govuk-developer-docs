---
owner_slack: "#govuk-2ndline"
title: Deploy AWS infrastructure with Terraform
section: Deployment
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-10-10
review_in: 3 months
---

We use [Terraform](https://terraform.io) for configuring the GOV.UK
infrastructure in AWS.

There are two repos,
[govuk-aws](https://github.com/alphagov/govuk-aws) and
[govuk-aws-data](https://github.com/alphagov/govuk-aws-data).

## What you can deploy

Which changes you can deploy depends on the level of access you have
to our AWS environments.

- Users can't deploy anything.
- PowerUsers can deploy everything except IAM, ie users and policies.
- Administrators can deploy everything including IAM.

You can find which class of user you are [in the infra-security
project in
govuk-aws-data](https://github.com/alphagov/govuk-aws-data/tree/master/data/infra-security).

## How to deploy

Before deploying you'll have to [assume a role](/manual/user-management-in-aws.html) for the
environment you're deploying to (test, integration, staging or production).

There is a [CI Jenkins job](https://ci-deploy.integration.publishing.service.gov.uk/job/Deploy_Terraform_GOVUK_AWS/).
This requires you to enter your own AWS access keys (generated from an
assume-role, ie `govukcli aws env` will print them). You will have to
do this for every `plan` and `apply` you run.

While this method requires lots of copying and pasting of access keys,
secret keys and session tokens, it gives us an audit trail of who ran
what and when they did it, also a log of any errors.
