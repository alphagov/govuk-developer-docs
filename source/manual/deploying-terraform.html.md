---
owner_slack: "#re-govuk"
title: Deploy AWS infrastructure with Terraform
section: Deployment
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-11-08
review_in: 3 months
---

We use [Terraform](https://terraform.io) for configuring GOV.UK infrastructure in AWS.
This document describes:

 * How to set up your machine to run Terraform.
 * How to deploy infrastructure changes using Terraform.

## One-time setup

### 1. Check that you have sufficient access

Which changes you can deploy depends on the level of access you have
to our AWS environments. Specifically, the level of access your Amazon Resource Name (ARN) has been given.

- `govuk-users` (`role_user_user_arns`) can't deploy anything.
- `govuk-powerusers` (`role_poweruser_user_arns`) and `govuk-platformhealth-powerusers` (`role_platformhealth_poweruser_user_arns`) can deploy everything except IAM (users and policies).
- `govuk-administrators` (`role_admin_user_arns`) and `govuk-internal-administrators` (`role_internal_admin_user_arns`) can deploy everything including IAM.

You can find which class of user you are (that is, which roles your ARN has been assigned to) in the
[infra-security project in govuk-aws-data](https://github.com/alphagov/govuk-aws-data/tree/master/data/infra-security).

### 2. Install `gds-cli`

See [instructions for installing `gds-cli`](/manual/gds-cli.html).

### 3. Create a read-only GitHub personal access token

Create a [Github personal access token](https://github.com/settings/tokens) with the `read:org` scope.

  * Follow the link above and press the `Generate a new token` button near the
    top of the page.
  * Enter a suitable description for the token under `Note`, for example `Token
    for Jenkins Terraform deployments`.
  * Under `Select scopes`, tick the `read:org` box **only**.
  * Press `Generate token` at the bottom of the form.
  * Please take care to store and handle the token securely. It allows access
    to Jenkins. If you accidentally share your token,
    [revoke it immediately](https://github.com/settings/tokens) and follow the
    [instructions for reporting a potential data security incident][security-incidents].

[security-incidents]: https://sites.google.com/a/digital.cabinet-office.gov.uk/gds/working-at-the-white-chapel-building/security/security-incidents

## Plan and deploy a Terraform project via Jenkins using `deploy.rb`

The Ruby script [`tools/deploy.rb`][deploy-rb] in the `govuk-aws` repository takes care of requesting temporary AWS credentials with an assumed role and queuing the deployment Jenkins job.

To follow these instructions you will need:

* The name of the Terraform project which you want to deploy, for example `app-backend`.
* The stackname of the Terraform project which you want to deploy. Usually, this is `blue` for `app-` projects and `govuk` for `infra-` projects.
* Your GitHub username.
* Your GitHub personal access token (see setup instruction above).
* The name of your AWS role (`govuk-powerusers` or `govuk-adminstrators`).
* A local copy of the `govuk-aws` Git repo, which contains the `deploy.rb` script. The example command assumes that your local repo is in the directory `~/govuk/govuk-aws`.

**Always `plan` first, check that the output is what you expect, then `apply`.**

1. To start the Terraform plan job, run `deploy.rb` like this.

    ```
    GITHUB_USERNAME=<your GitHub username> \
      GITHUB_TOKEN=<your GitHub personal access token> \
      gds aws govuk-integration-admin -- \
      ~/govuk/govuk-aws/tools/deploy.rb blue app-backend integration plan
    ```

1. If your AWS session has expired, you'll be asked for your MFA (two-factor authentication) code.

1. Once the script has run, visit the [`ci-deploy` Jenkins job][ci-deploy-jenkins] to see the job running or queued.

1. If the results of the plan look good, repeat the command with `apply` instead of `plan`.

1. Visit the Jenkins again to check that the `apply` succeeded.

[deploy-rb]: https://github.com/alphagov/govuk-aws/blob/master/tools/deploy.rb
[ci-deploy-jenkins]: https://ci-deploy.integration.publishing.service.gov.uk/job/Deploy_Terraform_GOVUK_AWS
