---
owner_slack: "#dev-notifications-ai-govuk"
title: GOV.UK Chat Alerts
parent: "/manual.html"
layout: manual_layout
section: Alertmanager alerts
---

> **Note**
>
> For any queries or assistance regarding Chat Alerts, please post in the #dev-notifications-ai-govuk Slack channel

## Alerts by Priority

For any alert, it is worth checking the Grafana `GOV.UK Chat Technical` Dashboards to see if any part of the service is showing signs of an issue:

- [Integration]
- [Staging]
- [Production]

### Pagerduty Alerts

- High5xxRate

The 503 error code has been excluded from being alerted on, as that will be used when the Chat service is disabled, so we do not want that to go to Pagerduty.

### Slack Alerts

- LongRequestDuration
- HighPodCPUFE
- HighPodCPUWorker
- HighPodMemoryFE
- HighPodMemoryWorker

The `LongRequestDuration` alert indicates that a backend part of the service is not responding as expected, and as a result the user experience is severely impacted. For example, we have seen it fire when the RDS Postgres Database is offline.

Any of the `High` alerts usually indicate that the service is under heavy load. In this situation, it may be necessary to increase the number of relevent pods running by modifying the `replicaCount` for FE or `workerReplicaCount` for Worker pods in the `govuk-chat` section of the relevant values Helm Chart file found [here].

[Integration]: https://grafana.eks.integration.govuk.digital/d/govuk-chat-techical
[Staging]: https://grafana.eks.staging.govuk.digital/d/govuk-chat-techical
[Production]: https://grafana.eks.production.govuk.digital/d/govuk-chat-techical
[here]: https://github.com/alphagov/govuk-helm-charts/tree/main/charts/app-config
