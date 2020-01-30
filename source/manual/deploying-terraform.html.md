---
owner_slack: "#re-govuk"
title: Deploy Terraform
section: Deployment
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2020-01-28
review_in: 6 months
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

## Deploying manually on Jenkins

> **This is not the recommended approach.**
>
> It's slightly easier to start with, but you'll quickly want to switch to using the `deploy.rb` helper script (see next section), to avoid pasting secrets over and again!

### 1. Generate an AWS token and key

First make sure you have [`gds-cli`](/manual/access-aws-console.html) installed.

👉 [Instructions for installing `gds-cli`](/manual/access-aws-console.html)

Run the following to generate a token and key.

```
gds aws <your-role e.g. govuk-integration-poweruser> -e
```

### 2. Run the Jenkins job

**Always `plan` first, check that the output is what you expect, then `apply`.**

Manually run the Jenkins job, pasting the token and key from the previous step.

👉 [Deploy terraform directly from Jenkins][ci-deploy-jenkins]

## Deploying with `deploy.rb`

### 1. Create a read-only GitHub personal access token

Create a [GitHub personal access token](https://github.com/settings/tokens) with the `read:org` scope.

> Take care to store and handle the token securely. If you accidentally share your token,
  [revoke it immediately](https://github.com/settings/tokens) and follow the
  [instructions for reporting a potential data security incident][security-incidents].

### 2. Remotely trigger a terraform deploy via Jenkins

The Ruby script [`tools/deploy.rb`][deploy-rb] in the `govuk-aws` repository takes care of requesting temporary AWS credentials with an assumed role and queuing the deployment Jenkins job.

**Always `plan` first, check that the output is what you expect, then `apply`.**

```
GITHUB_USERNAME=<your GitHub username> \
  GITHUB_TOKEN=<your GitHub personal access token> \
  gds aws <your role e.g. govuk-integration-admin> -- \
  ~/govuk/govuk-aws/tools/deploy.rb blue app-backend integration plan
```

You will need to change the arguments to the `deploy.rb` script.

* `app-backend` should be the name of the project you want to deploy
* `blue` is for `app-` projects, `govuk` is for `infra-` projects
* `integration` is the starting point, then `staging`, etc.

### 3. Visit Jenkins to check the output of the job

Once the script has run, visit the [`ci-deploy` Jenkins job][ci-deploy-jenkins] to see the job running or queued.

[deploy-rb]: https://github.com/alphagov/govuk-aws/blob/master/tools/deploy.rb
[ci-deploy-jenkins]: https://ci-deploy.integration.publishing.service.gov.uk/job/Deploy_Terraform_GOVUK_AWS
[security-incidents]: https://sites.google.com/a/digital.cabinet-office.gov.uk/gds/working-at-the-white-chapel-building/security/security-incidents
