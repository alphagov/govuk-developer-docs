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

## Dealing with GraphQL alerts

### Elevated GraphQL request duration

This alert is triggered when a certain request duration for GraphQL queries exceeds a [defined level](https://github.com/alphagov/govuk-helm-charts/blob/794a9b191454f979e048a3be22f46be0e94b6708/charts/monitoring-config/rules/graphql.yaml#L4-L26).

#### Look for changes in traffic to specific schemas

The queries for some schemas are known to execute faster than others, due to differing complexity between them. The average response times could be pushed upwards by a higher number of requests for a specific schema.

The [GraphQL dashboards](#monitoring-graphql-traffic) include data broken down by schema, which could be useful in identifying changes in traffic to a specific schema.

It may be necessary to [switch off traffic](#switching-off-public-graphql-traffic) until this is optimised.

#### Look for slow requests to specific URLs

[Logit](/manual/logit.html) can be used to identify specific URLs that are slow performing.

The following Kibana query will show all requests the the Publishing API read replica's `live_content` endpoint:

```dql
kubernetes.labels.app_kubernetes_io/name:"publishing-api-read-replica" AND "/graphql/content/*"
```

Look at the `logjson.request_time` field to identify the total request duration. Sort this column in descending order to see the slowest queries.

A specific URL being slow could be caused by that specific page having a larger amount of data than others of the same schema. Check to see if other pages of the same schema are affected, then consider optimising the query. It may be necessary to [switch off traffic](#switching-off-public-graphql-traffic) until this is optimised.

### Elevated GraphQL error rate

This alert is triggered when the rate of 200 responses from GraphQL queries fall below a [defined level](https://github.com/alphagov/govuk-helm-charts/blob/794a9b191454f979e048a3be22f46be0e94b6708/charts/monitoring-config/rules/graphql.yaml#L28-L49).

> Note: GraphQL will return a 200 response code when the client makes an invalid query (e.g. requesting a field that does not exist). This is because there is no server error, rather the client has provided invalid data. See [the documentation](https://graphql.org/learn/response/#errors) for more details on error responses.

The [GraphQL dashboards](#monitoring-graphql-traffic) include error codes broken down by frontend application. This will give information of what type of error is occuring and whether it affects requests from one or many frontend applications.

The [app request rates, errors and durations dashboard](https://grafana.eks.production.govuk.digital/d/app-requests/app3a-request-rates-errors-durations?var-namespace=apps&var-app=publishing-api-read-replica&var-error_status=$__all&orgId=1&from=now-6h&to=now&timezone=browser&refresh=1m) could be useful to see when the errors started to occur and their frequency.

If the errors are server-side application errors (i.e. 500 response codes), these are logged in [Sentry](/manual/sentry.html). Navigate to the [`app-publishing-api` project](https://govuk.sentry.io/issues/?project=202242&query=GraphqlController) to examine any recent errors logged from the `GraphqlController`.

It may be necessary to [switch off traffic](#switching-off-public-graphql-traffic) until the error is fixed.

## Switching off public GraphQL traffic

### Specific schemas

If a specific schema is identified as being slow, it may be useful to switch off traffic to that schema until the query can be optimised. This is done by removing the environment variables from the relevant frontend application ([example PR](https://github.com/alphagov/govuk-helm-charts/pull/3927/changes)) or setting the value to zero.

### All schemas

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
