---
owner_slack: "#re-govuk"
title: Deploy Terraform
section: Deployment
layout: manual_layout
parent: "/manual.html"
---

We use [Terraform](https://terraform.io) for configuring GOV.UK infrastructure in AWS.

## One-time setup

### 1. Check that you have sufficient access

Which changes you can deploy depends on the level of access you have
to our AWS environments.

- `govuk-users` can't deploy anything.
- `*-powerusers` can deploy anything except IAM.
- `*-administrators` can deploy anything.

You can find which class of user you are [infra-security project in govuk-aws-data](https://github.com/alphagov/govuk-aws-data/tree/master/data/infra-security).

### 2. Install `gds-cli`

[`gds-cli`][gds-cli] is the [preferred way](/manual/get-started.html) of obtaining
AWS credentials.

As of version `v2.15.0` of `gds-cli`, you can use it to deploy terraform via Jenkins.

### 3. Get GitHub Credentials

You need to obtain your GitHub credentials by creating a read-only GitHub personal access token. This [GitHub personal access token](https://github.com/settings/tokens) should be
created with the `read:org` scope only.

> Take care to store and handle the token securely. If you accidentally share your token,
  [revoke it immediately](https://github.com/settings/tokens) and follow the
  [instructions for reporting a potential data security incident][security-incidents].

## Deploying Terraform

**Always `plan` first, check that the output is what you expect, then `apply`.**

There are 2 ways of deploying terraform:

1. [`gds-cli`][gds-cli] as of version `v2.15.0`
2. `deploy.rb` script in [govuk-aws][deploy-rb] repository

### 1. gds-cli

To deploy terraform using [`gds-cli`][gds-cli], you should run:

```sh
GITHUB_USERNAME=<github_username> GITHUB_TOKEN=<github_token> \
gds govuk terraform -e <environment> -p <project> -s <stack> -a <action> -r <aws_role>
```

Where:

1. `<github_username>` is the name of your GitHub account
1. `<github_token>` is the GitHub token that you created as described [above](#3-get-github-credentials)
1. `<environment>` is the govuk environment you want to deploy to. E.g. `integration`,`staging`
1. `<project>` is the terraform project that you want to deploy. E.g. `app-gatling`
1. `<stack>` is the govuk stack you want to deploy to. E.g. `blue`, `govuk`
1. `<action>` is the terraform action you want to perform. E.g. `plan`, `apply`
1. `<aws_role>` is the govuk aws role you want to use for terraforming. E.g. `govuk-integration-admin`

After you deploy, you can visit the [`deploy` Jenkins job][deploy-jenkins] to see the job running or queued.

### 2. `deploy.rb` script in govuk-aws

The Ruby script [`tools/deploy.rb`][deploy-rb] in the `govuk-aws` repository takes care of requesting temporary
AWS credentials with an assumed role and queuing the deployment Jenkins job.

You can use it by running:

```sh
GITHUB_USERNAME=<your GitHub username> \
  GITHUB_TOKEN=<your GitHub personal access token> \
  gds aws <your role e.g. govuk-integration-admin> -- \
  ~/govuk/govuk-aws/tools/deploy.rb blue app-backend integration plan
```

You will need to change the arguments to the `deploy.rb` script. E.g.

- `app-backend` should be the name of the project you want to deploy
- `blue` is for `app-` projects, `govuk` is for `infra-` projects usually
- `integration` is the starting point, then `staging`, etc.

Once the script has run, visit the [`deploy` Jenkins job][deploy-jenkins] to see the job running or queued.

[gds-cli]: https://github.com/alphagov/gds-cli
[deploy-rb]: https://github.com/alphagov/govuk-aws/blob/master/tools/deploy.rb
[deploy-jenkins]: https://deploy.integration.publishing.service.gov.uk/job/Deploy_Terraform_GOVUK_AWS
[security-incidents]: https://sites.google.com/a/digital.cabinet-office.gov.uk/gds/working-at-the-white-chapel-building/security/security-incidents
