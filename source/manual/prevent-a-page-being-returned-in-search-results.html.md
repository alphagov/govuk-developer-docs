---
owner_slack: "#govuk-search"
title: "Prevent a page being returned in search results"
parent: "/manual.html"
layout: manual_layout
section: Search on GOV.UK
---

## How to filter a page from Site search results

To prevent a page being returned in site search results, a large negative boost can be applied to the DiscoveryEngine serving configuration.

Add the path to the filtered_pages array defined in [here][link-1]

[link-1]: https://github.com/alphagov/govuk-infrastructure/blob/1fa78b9fabcc3cdbfd419e0964a7bec45089bcd3/terraform/deployments/search-api-v2/serving_config_global_default.tf#L116-L120
