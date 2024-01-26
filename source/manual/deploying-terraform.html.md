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

### 3. Clone/Checkout `govuk-aws` and `govuk-aws-data`

[`govuk-aws`](https://github.com/alphagov/govuk-aws) is the code that deploys GOV.UK in AWS, and [`govuk-aws-data`](https://github.com/alphagov/govuk-aws-data) provides the data, secrets, and configuration used. Make sure you have the latest version of both, and make sure you're on the main branch of both if you're deploying to production.

## Deploy Terraform via the build script

Before you begin, run the following command using `gds-cli`:

```sh
gds aws govuk-integration-admin -e
```

This will allow you to retrieve several AWS access keys that the script requires to run.

Next run the script:

```sh
tools/build-terraform-project.sh -c <COMMAND> -d ../govuk-aws-data/data/ -e <ENVIRONMENT> -s <STACK> -p <PROJECT> -- -compact-warnings
```

...using the following values:

- COMMAND: the terraform action you want to perform. E.g. `plan`, `apply`
- ENVIRONMENT: the govuk environment you want to deploy to. E.g. `integration`,`staging`
- STACKNAME: the govuk stack you want to deploy to. E.g. `blue` (which is usually for `app-` projects), `govuk` (which is usually for `infra-` projects)
- PROJECT: the terraform project that you want to deploy. E.g. `app-gatling`, `infra-security`

If you chose the apply command, the script will perform a plan to start with, then if the plan succeeds it will prompt you if you want to continue to apply.
