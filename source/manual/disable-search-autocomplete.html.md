---
owner_slack: "#govuk-developers"
title: Disable search autocomplete
section: GOV.UK Search
layout: manual_layout
parent: "/manual.html"
---

Autocomplete for GOV.UK site search is a feature that launched in December 2024, while it is a new feature there is a simple mechanism to disable it.

To disable the autocomplete functionality for GOV.UK site search for a GOV.UK environment:

1. Open the appropriate `values-<environment>.yaml` file from [GOV.UK Helm Charts][], for example [values-production.yaml][]
1. Find the `disableSearchAutocomplete` variable and set it to `true`
1. Open a PR to apply the change
1. Once merged the variable will propagate across apps

As pages are [cached][] disabling this feature will not happen instantly and will apply to pages gradually as their cache times expire. It may take up-to 10 minutes for this to be applied to all pages of GOV.UK.

[GOV.UK Helm Charts]: https://github.com/alphagov/govuk-helm-charts
[values-production.yaml]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/app-config/values-production.yaml
[cached]: https://docs.publishing.service.gov.uk/manual/architecture-shallow-dive.html#a-user-visits-a-gov-uk-webpage
