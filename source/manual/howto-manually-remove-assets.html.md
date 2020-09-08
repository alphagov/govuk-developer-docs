---
owner_slack: "#govuk-2ndline"
title: Remove an asset
section: Assets
layout: manual_layout
parent: "/manual.html"
---

If you need to remove an asset manually from `assets.publishing.service.gov.uk`,
follow these steps:

1. Mark the asset as deleted. Sometimes it may be necessary to completely scrub an asset from our systems e.g. if it contains secret information. In this case, add `,true` to the appropriate rake task:
  - [`rake assets:delete[<asset.id>]`][rake-delete] (non-Whitehall assets)
  - [`rake assets:whitehall_delete[<legacy URL path>]`][whitehall-rake-delete] (Whitehall assets)
1. Add a cache bust and check that the asset responds with a 404 not found
1. Wait 20 minutes for the cache to clear, or [purge it yourself][clear-cache]
1. Verify that the asset is not there
1. Request removal of the asset using the [Google Search Console](https://www.google.com/webmasters/tools/removals)
1. Remove the asset from the mirrors
  - Remove from AWS: `gds aws govuk-production-poweruser aws s3 rm s3://govuk-production-mirror/assets.publishing.service.gov.uk/<slug>`
  - Log into the [GCP console](https://console.cloud.google.com/)
  - Go to the GOVUK Production project under the DIGITAL.CABINET-OFFICE.GOV.UK organisation
  - Select Storage -> Browser, manually delete the asset in the govuk-production-mirror bucket

[whitehall-rake-delete]: https://deploy.blue.production.govuk.digital/job/run-rake-task/parambuild/?TARGET_APPLICATION=asset-manager&MACHINE_CLASS=backend&RAKE_TASK=assets:whitehall_delete[]
[rake-delete]: https://deploy.blue.production.govuk.digital/job/run-rake-task/parambuild/?TARGET_APPLICATION=asset-manager&MACHINE_CLASS=backend&RAKE_TASK=assets:delete[]
[clear-cache]: https://docs.publishing.service.gov.uk/manual/purge-cache.html#assets
