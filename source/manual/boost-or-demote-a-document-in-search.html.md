---
owner_slack: "#govuk-search"
title: "Boost or demote a document in site search"
parent: "/manual.html"
layout: manual_layout
section: Search on GOV.UK
---

Some kinds of content are more useful to our users than others. To account for this, we configure the VAIS engine to always apply certain “boosts” to search results. These are generally applied by [document type] but some documents are boosted based on their [base path].

Boosts and demotions are configured in the [serving config] in the [govuk-infrastructure] repo and applied through [Terraform].

Changes to the integration and staging environment are planned and applied automatically in Terraform cloud when a PR is merged. However they are only planned in Production, the apply must be run manually by a developer.

## Deleting a boost control

To delete a boost control, it is necessary to follow a two step process.

### Step 1

Open a PR to remove all references to the boost control you want to delete. Plan and apply the terraform. [Example PR removing a reference].

### Step 2

Open a second PR to delete the boost control. Plan and apply the terraform. [Example PR of deleting a boost control].

[document type]: https://github.com/alphagov/govuk-infrastructure/blob/a3e5cf6ef98ce00f157f858a29fd2d84846d2ac0/terraform/deployments/search-api-v2/serving_config_global_default.tf#L47
[base path]: https://github.com/alphagov/govuk-infrastructure/blob/a3e5cf6ef98ce00f157f858a29fd2d84846d2ac0/terraform/deployments/search-api-v2/serving_config_global_default.tf#L107
[Terraform]: https://app.terraform.io/app/govuk/workspaces/search-api-v2-production/runs
[serving config]: https://github.com/alphagov/govuk-infrastructure/blob/a3e5cf6ef98ce00f157f858a29fd2d84846d2ac0/terraform/deployments/search-api-v2/serving_config_global_default.tf
[govuk-infrastructure]: https://github.com/alphagov/govuk-infrastructure
[Example PR removing a reference]: https://github.com/alphagov/govuk-infrastructure/pull/1932
[Example PR of deleting a boost control]: https://github.com/alphagov/govuk-infrastructure/pull/1933
