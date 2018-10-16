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

## 1. Check what you can deploy

Which changes you can deploy depends on the level of access you have
to our AWS environments.

- `govuk-users` can't deploy anything
- `govuk-powerusers` can deploy everything except IAM, ie users and policies.
- `govuk-administrators` can deploy everything including IAM.

You can find which class of user you are [in the infra-security
project in
govuk-aws-data](https://github.com/alphagov/govuk-aws-data/tree/master/data/infra-security).

## 2. Get your credentials

Before deploying you'll have to assume a role for the environment you're deploying to.

```sh
aws sts assume-role \
  --role-session-name "$(whoami)-$(date +%d-%m-%y_%H-%M)" \
  --role-arn <Role ARN> \
  --serial-number <MFA ARN> \
  --duration-seconds 28800 \
  --profile gds \
  --token-code <MFA token>
```

If you've [set up AWS CLI correctly](/manual/aws-cli-access.html) you can get the Role ARN and MFA ARN with `cat ~/.aws/config`.

## 3. Terraform `plan` & `deploy`

👉 [Deploy to integration using Jenkins][deploy-integration]

[deploy-integration]: https://ci-deploy.integration.publishing.service.gov.uk/job/Deploy_Terraform_GOVUK_AWS
