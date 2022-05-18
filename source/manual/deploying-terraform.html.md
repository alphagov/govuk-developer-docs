---
owner_slack: "#govuk-2ndline-tech"
title: Deploy Terraform
section: Deployment
layout: manual_layout
parent: "/manual.html"
---

We use [Terraform](https://terraform.io) for configuring GOV.UK infrastructure in AWS.

## One-time setup

### 1. Check that you have sufficient access

Which changes you can deploy depends on the role you have assumed
in our AWS environments.

- `govuk-users` can only assume readonly roles, so cannot apply terraform
- people with production access can assume `poweruser` roles, which can deploy anything except IAM
- people with production access can assume `administrator` roles, which can deploy anything

You should always use the least privileged role that will let you accomplish
your task.

Unless your terraform plan needs to make changes to IAM resources, use a
poweruser role.

### 2. Install `gds-cli`

[`gds-cli`](https://github.com/alphagov/gds-cli) is the [preferred way](/manual/get-started.html) of obtaining AWS credentials.

## Deploy Terraform via Jenkins

**Always `plan` first, check that the output is what you expect, then `apply`.**

Before you begin, run the following command using `gds-cli`:

```sh
gds aws govuk-integration-admin -e
```

This will allow you to retrieve several AWS access keys that the Jenkins job requires to run.

In the ['Deploy_Terraform_GOVUK_AWS' Jenkins job](https://deploy.integration.publishing.service.gov.uk/job/Deploy_Terraform_GOVUK_AWS), click "Build with Parameters" and enter the following for each field:

- AWS_ACCESS_KEY_ID: can be retrieved from the above command
- AWS_SECRET_ACCESS_KEY: can be retrieved from the above command
- AWS_SESSION_TOKEN: can be retrieved from the above command
- COMMAND: the terraform action you want to perform. E.g. `plan`, `apply`
- ENVIRONMENT: the govuk environment you want to deploy to. E.g. `integration`,`staging`
- STACKNAME: the govuk stack you want to deploy to. E.g. `blue` (which is usually for `app-` projects), `govuk` (which is usually for `infra-` projects)
- PROJECT: the terraform project that you want to deploy. E.g. `app-gatling`, `infra-security`

All other fields can be left as they are.

Click "build" and terraform should deploy as expected. Remember to deploy to staging and/or production as required.

### Other ways of invoking Jenkins

As of version `v2.15.0` of `gds-cli`, you can use it to deploy terraform via Jenkins.
Note that you should use at least [v5.25.0](https://github.com/alphagov/gds-cli/releases/tag/v5.25.0) of `gds-cli`, otherwise you will need to manually specify the branches of `govuk-aws` and `govuk-aws-data` (see below).

```sh
GITHUB_USERNAME=<your GitHub username> \
  GITHUB_TOKEN=<your GitHub personal access token> \
  gds govuk terraform -r <your role e.g. govuk-integration-admin> \
  -e <environment, eg integration> \
  -p <project to deploy> \
  -s <stack to deploy to, eg blue for projects, govuk for infrastructure> \
  -a <action, eg plan or apply>
  -b <(optional) branch of govuk-aws>
  -d <(optional) branch of govuk-aws-data>
```

This command takes care of requesting temporary AWS credentials with an assumed role and queue the deployment Jenkins job, and is a little less awkward than copying and pasting your credentials into Jenkins repeatedly. You'll still need to view the job progress in Jenkins.

For more details, run `gds govuk terraform --help`.
