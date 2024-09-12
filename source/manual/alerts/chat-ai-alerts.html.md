---
owner_slack: "#dev-notifications-ai-govuk"
title: Chat AI Alerts
parent: "/manual.html"
layout: manual_layout
section: Alertmanager alerts
---

## Alerts by Priority

> **Note**
>
> For any queries or assistance regarding Chat Alerts, please post in the #dev-notifications-ai-govuk Slack channel

### Pagerduty Alerts

- High5xxRate
- LongRequestDuration

These alerts indicate that a part of the service is not responding as expected, and as a result the user experience is severely impacted. For example, we have seen `LongRequestDuration` fire when the RDS Postgres Database is offline. For these alerts, it is worth checking the Grafana Dashboard `Chat AI Dashboard` to see if any of the backend services are showing signs of an issue.

### Slack Alerts

- HighPodCPUFE
- HighPodCPUWorker
- HighPodMemoryFE
- HighPodMemoryWorker

Any of these alerts usually indicate that the service is under high load. In this situation, it may be necessary to increase the number of relevent pods running by modifying the `replicaCount` for FE or `workerReplicaCount` for Worker pods in the `govuk-chat` section of the values Helm Chart file.
