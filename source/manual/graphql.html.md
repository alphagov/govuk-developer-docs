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

Changes to production values in govuk-helm-charts require a review from the Platform Engineering team, which can be requested via #govuk-platform-engineering Slack channel.

### Emergency procedure (e.g. out of hours)

If an urgent change is required and it is not practical to go through the normal Helm chart workflow, you can update the environment variables directly on the cluster for the affected frontend applications.

> ⚠️ This should only be used in emergencies. Any direct changes must be reconciled with govuk-helm-charts as soon as possible.

#### Step 1: Disable Argo CD auto-sync

- Open the [Argo CD UI](https://argo.eks.production.govuk.digital/applications?showFavorites=false&proj=&sync=&autoSync=&health=&namespace=&cluster=&labels=)
- Find the relevant frontend application.
- Go to Details.
- Untick ENABLE AUTO-SYNC.
  - Ignore the AUTOMATED DISABLE AUTO-SYNC option.
  - Ignore the sync status indicator at the top of the UI that says “Auto sync is enabled”.

This prevents Argo from immediately reverting your manual changes.

#### Step 2: Edit the deployment

Run the following command: `kubectl edit deploy <frontend_app_name>`

In the editor:

- Locate the `GRAPHQL_RATE_*` environment variables.
- Set all of them to `"0"`.
- Save and exit.

The pod should restart automatically after the change.

#### Step 3: Verify rollout

In the Argo CD UI:

- Sync status will show as "OutOfSync".
- App health will briefly appear as "Progressing" before changing to "Healthy".
- Live manifest will reflect changes made in the cluster.

If the pods do not restart automatically, trigger a manual restart: `kubectl rollout restart deploy <frontend_app_name>`

#### After the incident (in-hours)

- Apply the same changes in `govuk-helm-charts` repository via a pull request.
- Follow the standard review and approval process.
- Once the Helm chart changes are deployed, re-enable Auto-Sync in Argo CD for the affected applications.

This ensures the system returns to a fully managed and declarative state.
