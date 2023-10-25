---
owner_slack: "#govuk-2ndline-tech"
title: GOV.UK content mirrors
section: Deployment
layout: manual_layout
parent: "/manual.html"
---

A GOV.UK mirror is a static copy of pages and assets hosted on www.gov.uk or assets.publishing.service.gov.uk (or equivalent domains in integration and staging). A mirror includes:

- HTML pages
- related assets for those pages (e.g. JavaScript, CSS, images, fonts)
- other linked assets (or "attachments") such as CSVs, PDFs etc

## Available mirrors

We maintain three mirrors, ranked by priority:

1. Primary: AWS S3 bucket named `govuk-<environment>-mirror` in eu-west-2
1. Secondary: AWS S3 bucket named `govuk-<environment>-mirror-replica` in eu-west-1 (production only)
1. Tertiary: Google Cloud Storage (GCS) bucket named `govuk-<environment>-mirror`

We use multiple mirrors across various AWS regions and GCP to ensure redundancy and increase availability.

## When is the GOV.UK mirror used?

If [Fastly, our primary CDN](/manual/cdn.html), cannot fetch a page from our backend servers (becuase of a timeout or a 5xx error), then Fastly will attempt to serve a page from a mirror in order of priority.

## How are the mirrors populated?

Every day the [govuk-mirror-sync cronjob][govuk-mirror-sync configuration] crawls the www and assets domains, saves pages and assets to disk and then uploads the files to the primary S3 bucket. The [govuk-mirror] repository contains the code responsible for crawling and saving pages to disk.

S3 Replication automatically copies any changes from the primary S3 bucket to the secondary S3 bucket. This is configured in [govuk-aws].

GCP Storage Transfer Service copies any changes from the primary S3 bucket to the tertiary GCS bucket.

## What is not covered by mirrors?

Certain page types aren't included in the mirrors:

- Smart answer pages (as the govuk-mirror crawler doesn't support following form links)
- [CSV preview pages](https://github.com/alphagov/govuk-helm-charts/pull/1337)

## Troubleshooting

Check the [logs of the govuk-mirror-sync job in Argo][govuk-mirror-sync job] to see there are any errors during crawling, saving pages or uploading to S3.

Check buckets in AWS S3 or GCP to see if they are populated.

You can fetch pages directly from the mirrors by specifying the `Backend-Override` header, e.g. `curl -H 'Backend-Override: mirrorS3' https://www.gov.uk`. The [allowed values](https://github.com/alphagov/govuk-fastly/blob/68427d372df05fd23c6851cfbea610845c6c3997/modules/www/www.vcl.tftpl#L258-L289) are `mirrorS3`, `mirrorS3Replica` and `mirrorGCS`.

[govuk-aws]: https://github.com/alphagov/govuk-aws/blob/2053b554/terraform/projects/infra-mirror-bucket/main.tf#L197
[govuk-mirror]: https://github.com/alphagov/govuk-mirror
[govuk-mirror-sync configuration]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/govuk-jobs/templates/govuk-mirror-sync-cronjob.yaml
[govuk-mirror-sync job]: https://argo.eks.production.govuk.digital/applications/cluster-services/govuk-jobs?view=tree&orphaned=false&resource=name%3Agovuk-mirror-sync
