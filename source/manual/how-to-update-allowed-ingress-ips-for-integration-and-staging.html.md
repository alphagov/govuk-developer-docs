---
owner_slack: "#govuk-platform-engineering-team"
title: Update Allowed Ingress IPs for Staging and Integration
section: Infrastructure
layout: manual_layout
parent: "/manual.html"
---

We allow the White Chapel Building office networks (both Brattain and GovWifi) to view integration
and staging without requiring HTTP Basic Authorisation. Occasionally the IP addresses of these networks
change and we need to update the list.

To update the list the process is broadly:

1. [Update the AWS WAF rules](#update-the-aws-waf-rules)
    1. [Update the terraform lists](#update-the-terraform-lists)
    2. [Release a new version of the infrastructure sensitive module](#release-a-new-version-of-the-infrastructure-sensitive-module)
    3. [Update the terraform deployment to use the new module version](#update-the-terraform-deployments-to-use-the-new-module-version)
    4. [Apply the terraform](#apply-the-terraform)
2. [Update the Fastly config](#update-the-fastly-config)
    1. [Update the fastly-secrets IP allow lists](#update-the-fastly-secrets-ip-allow-lists)
    2. [Apply the Fastly terraform Workspaces for datagovuk and www](#apply-the-fastly-terraform-workspaces-for-datagovuk-and-www)

## Update the AWS WAF rules

### Update the terraform lists

In the [terraform-govuk-infrastructure-sensitive repo](https://github.com/alphagov/terraform-govuk-infrastructure-sensitive) you need to update
the [modules/variables/main.tf](https://github.com/alphagov/terraform-govuk-infrastructure-sensitive/blob/main/modules/variables/main.tf) file.

You need to update the `office_ips` tfvars section in the sensitive-security-integration module, and also in the sensitive-security-staging module.

*NOTE* currently there is no pre-commit hook or github actions to validate this is ok. You should run `terraform validate` in the module
prior to merging to main.

### Release a new version of the infrastructure-sensitive module

Once the terraform is merged to main you need to:

1. Go to [the infrastructure-sensitive module in the govuk private registry](https://app.terraform.io/app/govuk/registry/modules/private/govuk/infrastructure-sensitive/govuk).
2. Note the current version number (which is listed in the breadcrumb at the top of the page).
3. Click the `Publish New Version` button.
4. From the opened pop up choose a commit (the most recent is at the top, and should be your merge).
5. Enter a higher version number than the current module version, but keep a note of the version number you have published.

Very quickly it should tell you the new version has been published. If you see it is taking a long time you will need to see the details and resolve
whatever is stopping it publishing (usually a terraform syntax error)

### Update the terraform deployments to use the new module version

In [govuk-infrastructure](https://github.com/alphagov/govuk-infrastructure) You
need to update the version of the infrastructure-sensitive modules to your new
version:

* [tfc-configuration/variables-sensitive.tf](https://github.com/alphagov/govuk-infrastructure/blob/main/terraform/deployments/tfc-configuration/variables-sensitive.tf)
* [govuk-publishing-infrastructure/wafs.tf](https://github.com/alphagov/govuk-infrastructure/blob/main/terraform/deployments/govuk-publishing-infrastructure/wafs.tf)

### Apply the terraform

Finally, once you have merged the version updates to the infrastructure-sensitive repo you should run the following terraform workspaces (in this order):

* [tfc-configuration](https://app.terraform.io/app/govuk/workspaces/tfc-configuration)
* [govuk-publishing-infrastructure-integration](https://app.terraform.io/app/govuk/workspaces/govuk-publishing-infrastructure-integration)
* [govuk-publishing-infrastructure-staging](https://app.terraform.io/app/govuk/workspaces/govuk-publishing-infrastructure-staging)

## Update the Fastly config

### Update the fastly-secrets IP allow lists

In the [govuk-fastly-secrets git repo](https://github.com/alphagov/govuk-fastly-secrets) you need to update the `allowed_ip_addresses` list in:

* [secrets/datagovuk/integration.yaml](https://github.com/alphagov/govuk-fastly-secrets/blob/main/secrets/datagovuk/integration.yaml)
* [secrets/datagovuk/staging.yaml](https://github.com/alphagov/govuk-fastly-secrets/blob/main/secrets/datagovuk/staging.yaml)
* [secrets/www/integration.yaml](https://github.com/alphagov/govuk-fastly-secrets/blob/main/secrets/www/integration.yaml)
* [secrets/www/staging.yaml](https://github.com/alphagov/govuk-fastly-secrets/blob/main/secrets/www/staging.yaml)

### Apply the Fastly Terraform Workspaces for datagovuk and www

After the changes above are merged you need to apply the Terraform Workspaces (in this order):

* [govuk-fastly-secrets](https://app.terraform.io/app/govuk/workspaces/govuk-fastly-secrets)
* [govuk-fastly-datagovuk-integration](https://app.terraform.io/app/govuk/workspaces/govuk-fastly-datagovuk-integration)
* [govuk-fastly-datagovuk-staging](https://app.terraform.io/app/govuk/workspaces/govuk-fastly-datagovuk-staging)
* [govuk-fastly-www-integration](https://app.terraform.io/app/govuk/workspaces/govuk-fastly-www-integration)
* [govuk-fastly-www-staging](https://app.terraform.io/app/govuk/workspaces/govuk-fastly-www-staging)
