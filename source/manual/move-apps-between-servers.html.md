---
owner_slack: "#govuk-2ndline-tech"
title: Move apps between servers
section: Infrastructure
layout: manual_layout
parent: "/manual.html"
---

Most frontend and backend apps on GOV.UK share a small number of servers. In some circumstances, apps may use more than their share of resources and may affect other apps on the same server. In these cases, apps can be moved to their own servers using those steps.

> **Note**
>
> You need to be at least a Power User in AWS to be able to run the following procedure. You can check by looking in the [govuk-aws-data] repository. Some IAM changes may require Administrator access, so you'll need to ask someone in the GOV.UK Platform Engineering team to run these for you.

1. Add Terraform configuration ([1][aws-terraform-config-1], [2][aws-terraform-config-2], [3][aws-terraform-config-3]) to create the new servers, load balancers, security groups, DNS entries etc.
1. Add data to complement the configuration above ([1][aws-terraform-data-1], [2][aws-terraform-data-2]).
1. [Deploy][] the Terraform configuration. You need to do this three times for each environment:
  1. `infra-security-groups` project in the `govuk` stack.
  1. `app-name-of-your-app` project in the `blue` stack (replace `app-name-of-your-app` with the name you configured above).
  1. `infra-public-services` project in the `govuk` stack (only if your app is accessible directly from the public internet).

For each deployment, set the environment to one of `integration`, `staging` or `production` and run the `plan` command first to double-check the changes before running the `apply` command to make the changes.

👉 [Deploy AWS infrastructure with Terraform][deploy-aws]

[aws-terraform-config-1]: https://github.com/alphagov/govuk-aws/pull/494
[aws-terraform-config-2]: https://github.com/alphagov/govuk-aws/pull/501
[aws-terraform-config-3]: https://github.com/alphagov/govuk-aws/pull/503/files#diff-c77caf224de69366e98d474cc9a6d473
[aws-terraform-data-1]: https://github.com/alphagov/govuk-aws-data/pull/103
[aws-terraform-data-2]: https://github.com/alphagov/govuk-aws-data/pull/104
[Deploy]: https://deploy.integration.publishing.service.gov.uk/job/Deploy_Terraform_GOVUK_AWS/
[deploy-aws]: /manual/deploying-terraform.html
