---
owner_slack: "#govuk-2ndline"
title: Remove an asset
section: Assets
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2020-02-25
review_in: 6 months
---

If you need to remove an asset manually from `assets.publishing.service.gov.uk`,
follow these steps:

1. Mark the asset as deleted and remove it from S3
   - [`rake assets:delete_and_remove_from_s3[<asset.id>]`][rake-delete-and-remove-from-s3] (non-Whitehall assets)
   - [`rake assets:whitehall_delete_and_remove_from_s3[<full URL path>]`][whitehall-rake-delete-and-remove-from-s3] (Whitehall assets)
1. Add a cache bust and check that the asset responds with a 404 not found
1. Wait 20 minutes for the cache to clear, or [purge it yourself][clear-cache]
1. Verify that the asset is not there
1. Request removal of the asset using the [Google Search Console](https://www.google.com/webmasters/tools/removals)
1. Remove the asset from the mirrors.
    1. Remove from AWS: `gds aws govuk-production-poweruser aws s3 rm s3://govuk-production-mirror/assets.publishing.service.gov.uk/<slug>`
    1. Log into the [GCP console](https://console.cloud.google.com/)
    1. Go to the GOVUK Production project under the DIGITAL.CABINET-OFFICE.GOV.UK organisation
    1. Select Storage -> Browser, manually delete the asset in the govuk-production-mirror bucket

[whitehall-rake-delete-and-remove-from-s3]: https://deploy.blue.production.govuk.digital/job/run-rake-task/parambuild/?TARGET_APPLICATION=asset-manager&MACHINE_CLASS=backend&RAKE_TASK=assets:delete_and_remove_from_s3[]
[rake-delete-and-remove-from-s3]: https://deploy.blue.production.govuk.digital/job/run-rake-task/parambuild/?TARGET_APPLICATION=asset-manager&MACHINE_CLASS=backend&RAKE_TASK=assets:whitehall_delete_and_remove_from_s3[]
[clear-cache]: https://docs.publishing.service.gov.uk/manual/purge-cache.html#assets
