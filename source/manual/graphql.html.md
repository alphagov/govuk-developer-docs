---
owner_slack: "#govuk-publishing-platform"
title: GraphQL
parent: "/manual.html"
layout: manual_layout
---

[GraphQL](https://graphql.org/) is an API query language that is used by GOV.UK to serve some live traffic. Our implementation exists in [Publishing API](https://github.com/alphagov/publishing-api) and is used by multiple frontend applications.

Traffic is allocated somewhat randomly to either Content Store or GraphQL, to allow us to compare response times between the two. The decision is made in the frontend applications based on a level of traffic that has been configured through environment variables for each schema (named `GRAPHQL_RATE_SCHEMA_NAME`).

## Monitoring GraphQL traffic

A Grafana dashboard exists in each environment to provide metrics on the traffic levels and response times of our GraphQL implementation:

- [integration](https://grafana.eks.integration.govuk.digital/d/aeh00wtwwg8owc/graphql-stats)
- [staging](https://grafana.eks.staging.govuk.digital/d/aeh00wtwwg8owc/graphql-stats)
- [production](https://grafana.eks.production.govuk.digital/d/aeh00wtwwg8owc/graphql-stats)

## Switching off public GraphQL traffic

To switch off all public traffic, set the `GRAPHQL_RATE_*` environment variables to zero in the relevant environment, by updating `govuk-helm-charts`:

- [integration](https://github.com/alphagov/govuk-helm-charts/blob/main/charts/app-config/values-integration.yaml)
- [staging](https://github.com/alphagov/govuk-helm-charts/blob/main/charts/app-config/values-staging.yaml)
- [production](https://github.com/alphagov/govuk-helm-charts/blob/main/charts/app-config/values-production.yaml)

> The `govuk-helm-charts` repo requires a review from the Platform Engineering team if changes are being made to production values. In an emergency (e.g. out of hours), this requirement can be switched off by unticking "Require review from Code Owners" in the [repo's branch protection rules](https://github.com/alphagov/govuk-helm-charts/settings/branch_protection_rules/22109538).
