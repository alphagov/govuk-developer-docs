---
owner_slack: "#dev-notifications-ai-govuk"
title: GOV.UK Chat Alerts
parent: "/manual.html"
layout: manual_layout
section: Monitoring and alerting
---

> **Note**
>
> For any queries or assistance regarding Chat Alerts, please post in the [#dev-notifications-ai-govuk] Slack channel

## Alerts by Priority

For any alert, it is worth checking the Grafana `GOV.UK Chat Technical` dashboards to see if any part of the service is showing signs of an issue:

- [Integration]
- [Staging]
- [Production]

The Grafana dashboards show usage of:

- Application rate limits
- Bedrock tokens usage
- Bedrock invocations
- Bedrock Service Exceptions
- HTTP requests
- Pod CPU & Memory
- Opensearch cluster
- RDS Postgres
- Elasticache Redis
- Sidekiq queues

### Pagerduty Alerts

#### High5xxRate

The [High5xxRate] alert is triggered when 10% of total requests return a 5xx for more than 5 minutes. The 503 error code has been excluded from being alerted on, as that will be used when the Chat service is disabled, so we do not want that to go to Pagerduty.

### Slack Alerts

#### LongRequestDuration

The [LongRequestDuration] alert indicates that a backend part of the service is not responding as expected, and as a result the user experience is severely impacted. For example, we have seen it fire when the RDS Postgres Database is offline.

#### HighPod* alerts

The following alerts relate to EKS Pod performance:

- [HighPodCPUFE]
- [HighPodCPUWorker]
- [HighPodMemoryFE]
- [HighPodMemoryWorker]

Horizontal Pod Autoscaling (HPA) has been employed, so along with the rate limiting in place, we should not see these trigger but if they do, it could indicate an issue with the EKS cluster. HPA configuration can be found in the relevant `values-{environment}.yaml` files [here].

#### SidekiqAnswerQueueLength

The [SidekiqAnswerQueueLength] is used as the metric to scale the worker pods, so an increase in this will likely be down to high load. If the age of the oldest job in the Sidekiq answer queue is increasing, it may be a process has got stuck.

#### SidekiqAnswerJobAge

The [SidekiqAnswerJobAge] alert indicates that a job has been in the answer queue for 15 minutes. We should process jobs from this queue immediately, as any delay will significantly degrade the user experience. If this alert fires, we should ensure that autoscaling is working as expected and jobs are being processed.

#### SidekiqDefaultJobAge

The [SidekiqDefaultJobAge] alert indicates that a Sidekiq job has been in the default queue for over 6 hours. These jobs are not time-sensitive, so our tolerance for delaying their processing is higher. However, if they have not been processed in 6 hours, there is either an issue with jobs not being processed or a concerningly large backlog, and we should investigate.

#### Bedrock token threshold alerts

The [govuk-chat-bedrock-token-threshold-50] and [govuk-chat-bedrock-token-threshold-100] alerts are for us to use as data for deciding if higher limits need to be requested of AWS. These alerts are configured in AWS Cloudwatch Alarms, rather than Prometheus like the other alerts.

The dashboard graph showing Bedrock Service Exceptions is an indication of rate limiting or problems on the AWS side. `ValidationException` happens when the invoke request has too many input tokens and `ServiceUnavailableException` is a result of the model being throttled by AWS.

To get the error message relating to the Cloudwatch error code for the exceptions, the lookup attribute `User name` can be used to filter events in Cloudtrail.

#### ElevatedAnswerErrorStatuses

The [ElevatedAnswerErrorStatuses] alert fires when three or more answers generated in the last 20 minutes have an error status.

To determine what the the issue is you should naviate to the [questions page in the admin console] for the relevant environment (this link is for production). Then view each questions with an error status and navigate to to the error message row.

[#dev-notifications-ai-govuk]: https://gds.slack.com/archives/C06AWTPNJMV
[Integration]: https://grafana.eks.integration.govuk.digital/d/govuk-chat-technical
[Staging]: https://grafana.eks.staging.govuk.digital/d/govuk-chat-technical
[Production]: https://grafana.eks.production.govuk.digital/d/govuk-chat-technical
[High5xxRate]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/monitoring-config/rules/chat_ai.yaml#L4-L25
[LongRequestDuration]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/monitoring-config/rules/chat_ai.yaml#L27-L48
[HighPodCPUFE]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/monitoring-config/rules/chat_ai.yaml#L50-L66
[HighPodCPUWorker]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/monitoring-config/rules/chat_ai.yaml#L68-L84
[HighPodMemoryFE]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/monitoring-config/rules/chat_ai.yaml#L86-L104
[HighPodMemoryWorker]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/monitoring-config/rules/chat_ai.yaml#L106-L124
[here]: https://github.com/alphagov/govuk-helm-charts/tree/main/charts/app-config
[SidekiqAnswerQueueLength]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/monitoring-config/rules/chat_ai.yaml#L154-L171
[SidekiqAnswerJobAge]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/monitoring-config/rules/chat_ai.yaml#L173-L190
[SidekiqDefaultJobAge]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/monitoring-config/rules/chat_ai.yaml#L192-L209
[govuk-chat-bedrock-token-threshold-50]: https://github.com/alphagov/govuk-infrastructure/blob/eb25eaa313bb2ce3775e5819092ea8479674f745/terraform/deployments/chat/cloudwatch_alarms.tf#L9-L67
[govuk-chat-bedrock-token-threshold-100]: https://github.com/alphagov/govuk-infrastructure/blob/eb25eaa313bb2ce3775e5819092ea8479674f745/terraform/deployments/chat/cloudwatch_alarms.tf#L69-L128
[ElevatedAnswerErrorStatuses]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/monitoring-config/rules/chat_ai.yaml#L211-L228
[questions page in the admin console]: https://chat.publishing.service.gov.uk/admin/questions
