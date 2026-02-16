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

### Pagerduty Alerts

- High5xxRate

The 503 error code has been excluded from being alerted on, as that will be used when the Chat service is disabled, so we do not want that to go to Pagerduty.

### Slack Alerts

- LongRequestDuration
- HighPodCPUFE
- HighPodCPUWorker
- HighPodMemoryFE
- HighPodMemoryWorker
- SidekiqAnswerQueueLength
- SidekiqAnswerJobAge
- SidekiqDefaultJobAge
- govuk-chat-bedrock-token-threshold-50
- govuk-chat-bedrock-token-threshold-100

The `LongRequestDuration` alert indicates that a backend part of the service is not responding as expected, and as a result the user experience is severely impacted. For example, we have seen it fire when the RDS Postgres Database is offline.

Any of the `High*` alerts relate to EKS Pod performance. Horizontal Pod Autoscaling has been employed, so along with the rate limiting in place, we should not see these trigger but if they do, it could indicate an issue with the EKS cluster. HPA configuration can be found in the relevant `values-{environment}.yaml` files [here].

`SidekiqAnswerQueueLength` is used as the metric to scale the worker pods, so an increase in this will likely be down to high load. If the age of the oldest job in the Sidekiq answer queue is increasing, it may be a process has got stuck.

The `SidekiqAnswerJobAge` alert indicates that a job has been in the answer queue for 15 minutes. We should process jobs from this queue immediately, as any delay will significantly degrade the user experience. If this alert fires, we should ensure that autoscaling is working as expected and jobs are being processed.

The `SidekiqDefaultJobAge` alerts indicate that a Sidekiq job has been in the default queue for over 6 hours. These jobs are not time-sensitive, so our tolerance for delaying their processing is higher. However, if they have not been processed in 6 hours, there is either an issue with jobs not being processed or a concerningly large backlog, and we should investigate.

The bedrock token threshold alerts are for us to use as data for deciding if higher limits need to be requested of AWS. These alerts are configured in AWS Cloudwatch Alarms, rather than Prometheus like the other alerts. The dashboard graph showing Bedrock Service Exceptions is an indication of rate limiting or problems on the AWS side. `ValidationException` happens when the invoke request has too many input tokens and `ServiceUnavailableException` is a result of the model being throttled by AWS. To get the error message relating to the Cloudwatch error code for the exceptions, the lookup attribute `User name` can be used to filter events in Cloudtrail.

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

[#dev-notifications-ai-govuk]: https://gds.slack.com/archives/C06AWTPNJMV
[Integration]: https://grafana.eks.integration.govuk.digital/d/govuk-chat-technical
[Staging]: https://grafana.eks.staging.govuk.digital/d/govuk-chat-technical
[Production]: https://grafana.eks.production.govuk.digital/d/govuk-chat-technical
[here]: https://github.com/alphagov/govuk-helm-charts/tree/main/charts/app-config
