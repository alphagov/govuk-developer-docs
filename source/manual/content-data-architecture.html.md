---
owner_slack: "#govuk-platform-security-reliability-team"
title: Content Data architecture
section: Content Data
type: learn
layout: manual_layout
parent: "/manual.html"
---

[Content Data][] is a service that allows organisations to view performance and content metrics about GOV.UK pages they maintain, so that they can manage their content effectively over time. The data helps them decide what content to improve and prioritise.

Behind the scenes it is made up of:

- [Content Data Admin](#content-data-admin), which manages the frontend of the service
- [Content Data API](#content-data-api), the data warehouse that stores the information used by Content Data Admin

![Overview of the elements involved in Content Data](images/content-data-architecture.png)

## Content Data Admin

![Screenshot of the Content Data app](images/content-data-screenshot.png)

This is a simple Rails app that provides the frontend service that users interact with. It has a database used solely for storing [Signon][] users (required by the [gds-sso][] gem), but mainly relies on metrics stored in Content Data API's data warehouse.

Users of the app can:

- Search for content (filter by time period, title, URL, document type, organisation)
- View performance and content metrics for pages
- [Export data to CSV](#csv-exporter)

This can be accessed at [https://content-data.publishing.service.gov.uk/content/](https://content-data.publishing.service.gov.uk/content/).

### CSV Exporter

This is a feature that allows users to export search results and associated metrics to CSV. It uses a [Sidekiq worker][] to generate the CSV in the background and stores it in an [AWS S3 bucket][]. An email is then sent to the user which contains the downloadable link that is valid for 7 days. The expiry time is configured in the S3 bucket settings under [Lifecycle configuration][].

![Overview of the CSV Exporter process](/images/content-data-architecture-csv-exporter.png)

## Content Data API

This is the data warehouse used by Content Data Admin where all the metrics are stored. The data is collected from various sources:

- [Google Analytics (GA)](#google-analytics-ga)
- [Support API][] (specifically [Feedback Explorer][])
- [Publishing API](#publishing-api)

It can be directly accessed at, e.g, [https://content-data-api.publishing.service.gov.uk/api/v1/metrics](https://content-data-api.publishing.service.gov.uk/api/v1/metrics).

### Data sources

#### Google Analytics (GA)

[Metrics collected from GA](https://lookerstudio.google.com/reporting/1oxcrwkvVPL_mvmJCMFIOikPo7XuShg3X/page/NwHo) for individual GOV.UK pages include:

- Views and navigation
- User feedback
- Internal searches

This data is fed into content-data-api using the [ETL process](#etl-processor).

#### Support API (Feedback Explorer)

[Feedback Explorer][] is a feature provided by the [Support app][], which collects information via forms on GOV.UK, for example:

- The [GOV.UK contact form](https://www.gov.uk/contact/govuk)
- "Was this page useful?" form (at the bottom of every GOV.UK page)

These forms are managed and rendered by the [Feedback app][]. When a user fills in the form on GOV.UK and submits the information, the anonymous data is then sent to [Support API][] to be stored and processed further. Users of the Support app can then query the information in the Feedback Explorer.

![Overview of Feedback Explorer](/images/content-data-architecture-feedback-explorer.png)

Content Data API only collects metrics on the number of feedback comments for pages on GOV.UK from Support API. This data is fed into its data warehouse using the [Extract, Transform, Load (ETL) process](#etl-processor).

#### Publishing API

Content Data API processes messages from the [Publishing API][] in order to detect and track changes to content.

It stores information such as:

- Word count
- PDF count
- Reading time
- Information about editions and relationships with other documents

This data is fed into Content Data API via [AmazonMQ](/manual/amazonmq.html) and the [Streams Processor](#streams-processor).

### How data is fed into the Content Data API warehouse

Data is fed directly into the data warehouse through two methods:

- The Extract, Transform, Load (ETL) Processor
- The Streams Processor

#### ETL Processor

Content Data API runs an [ETL (Extract, Transform, Load)](https://en.wikipedia.org/wiki/Extract,_transform,_load) process daily as a rake task via a [Kubernetes CronJob][], which copies the data from GA and Support API into its data warehouse.

![Overview of the ETL Processor](/images/content-data-architecture-etl-processor.png)

For more information see the [What is the ETL process](/manual/alerts/content-data-api-app-healthcheck-not-ok.html#what-is-the-etl-process) developer doc.

#### Streams Processor

This process is responsible for updating information about GOV.UK content from the Publishing API. Note that this data is different from the data collected from the nightly ETL process.

An overview of the process is as follows:

- Publishing API publishes messages about content changes to the [AmazonMQ content-data-api queue](https://grafana.eks.production.govuk.digital/d/mq/)
- Content Data API subscribes to this queue using a [consumer process][]
- The consumer process then creates [Sidekiq jobs][] (using Redis as a job management store) to ingest these messages via a rake task

![Overview of the Streams Processor](/images/content-data-architecture-streams-processor.png)

[AWS S3 bucket]: https://s3.console.aws.amazon.com/s3/buckets/govuk-production-content-data-csvs?region=eu-west-1&tab=objects
[consumer process]: https://github.com/alphagov/content-data-api/blob/main/lib/tasks/publishing_api_consumer.rake#L3-L7
[Content Data]: https://content-data.publishing.service.gov.uk/content
[Feedback app]: https://github.com/alphagov/feedback
[Feedback Explorer]: https://support.publishing.service.gov.uk/anonymous_feedback/explore
[gds-sso]: https://github.com/alphagov/gds-sso
[Kubernetes CronJob]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/app-config/values-production.yaml#L541-L543
[Lifecycle configuration]: https://s3.console.aws.amazon.com/s3/management/govuk-production-content-data-csvs/lifecycle/view?region=eu-west-1&id=all
[Publishing API]: https://github.com/alphagov/publishing-api
[Sidekiq worker]: https://grafana.eks.production.govuk.digital/d/sidekiq-queues/sidekiq-queue-length-max-delay?orgId=1&var-namespace=apps&var-app=content-data-admin-worker&from=1681272545106&to=1681294145106
[Sidekiq jobs]: https://grafana.eks.production.govuk.digital/d/sidekiq-queues/sidekiq-queue-length-max-delay?orgId=1&var-namespace=apps&var-app=content-data-api-worker
[Signon]: https://signon.publishing.service.gov.uk
[Support API]: https://github.com/alphagov/support-api
[Support app]: https://github.com/alphagov/support
