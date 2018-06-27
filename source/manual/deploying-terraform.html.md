---
owner_slack: "#govuk-2ndline"
title: Deploying Terraform
section: AWS
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-06-27
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

- ReadOnly users can't deploy anything.
- PowerUsers can deploy everything except IAM, ie users and policies.
- Administrators can deploy everything including IAM.

You can find which class of user you are [in the infra-security
project in
govuk-aws-data](https://github.com/alphagov/govuk-aws-data/tree/master/data/infra-security).

## How to deploy

There are three methods of deploying Terraform: a shell script, the
Terragov Ruby gem, and the CI Jenkins.

Before deploying via any of these methods, you'll have to [assume a
role](/manual/user-management-in-aws.html) for the
environment you're deploying to (test, integration, staging or
production).

### The shell script

In `govuk-aws`, there's a shell script
`./tools/build-terraform-project.sh`, which takes the following
options:

```
-c   The Terraform command (CMD) to run, eg "init", "plan" or "apply".
-d   The root of the data directory (DATA_DIR) to take .tfvars
     files from.
-e   The ENVIRONMENT to deploy to eg "integration".
-s   Specify the STACKNAME of the ".tfvars" and ".backend" files.
-p   Specify which PROJECT to create, eg "infra-networking".
```

For example, if you have `govuk-aws` and `govuk-aws-data` checked out
into `~/govuk/` and wanted to `terraform plan` a deploy of
`app-backend`, you would invoke it like so:

```
./tools/build-terraform-project.sh \
    -d ../govuk-aws-data/data \
    -s blue \
    -p app-backend \
    -e integration \
    -c plan
```
### Terragov

There's an unofficial, privately maintained Ruby gem for working with
our Terraform directory setup at
[surminus/terragov](https://github.com/surminus/terragov).

To install it, `gem install terragov`, or run `bundle install` inside
the `govuk-aws` repository.

It works in much the same way as the shell script, but takes a config
file so you don't have to specify all of the options every time,
per-project you're deploying. An example `terragov_config.yml` looks
like:

```
---
default:
  stack: 'blue'
  repo_dir: '~/govuk/govuk-aws'
  data_dir: '~/govuk/govuk-aws-data/data'

infra-security-groups:
  stack: 'govuk'
```

### CI Jenkins

There is also a [CI Jenkins
job](https://ci-deploy.integration.publishing.service.gov.uk/job/Deploy_Terraform_GOVUK_AWS/).
This requires you to enter your own AWS access keys (generated from an
assume-role, ie `govukcli aws env` will print them). You will have to
do this for every `plan` and `apply` you run.

While this method requires lots of copying and pasting of access keys,
secret keys and session tokens, it gives us an audit trail of who ran
what and when they did it, also a log of any errors more than just on
a person's laptop.
