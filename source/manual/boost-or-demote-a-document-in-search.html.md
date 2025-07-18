---
owner_slack: "#govuk-search"
title: "Boost or demote a document in site search"
parent: "/manual.html"
layout: manual_layout
section: Search on GOV.UK
---

Some kinds of content are more useful to our users than others. To account for this, we configure the VAIS engine to always apply certain “boosts” to search results. These are generally applied by [document type] but some documents are boosted based on their [base path].

Boosts and demotions are configured in the [serving config] in the [govuk-infrastructure] repo and applied through [Terraform].

N.B. Remember that changes to the production environment do not apply automatically in Terraform Cloud.

[document type]: https://github.com/alphagov/govuk-infrastructure/blob/a3e5cf6ef98ce00f157f858a29fd2d84846d2ac0/terraform/deployments/search-api-v2/serving_config_global_default.tf#L47
[base path]: https://github.com/alphagov/govuk-infrastructure/blob/a3e5cf6ef98ce00f157f858a29fd2d84846d2ac0/terraform/deployments/search-api-v2/serving_config_global_default.tf#L107
[Terraform]: https://app.terraform.io/app/govuk/workspaces/search-api-v2-production/runs
[serving config]: https://github.com/alphagov/govuk-infrastructure/blob/a3e5cf6ef98ce00f157f858a29fd2d84846d2ac0/terraform/deployments/search-api-v2/serving_config_global_default.tf
[govuk-infrastructure]: https://github.com/alphagov/govuk-infrastructure
