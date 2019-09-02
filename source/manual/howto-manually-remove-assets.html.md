---
owner_slack: "#govuk-2ndline"
title: Remove an asset
section: Assets
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-09-02
review_in: 6 months
---

If you need to remove an asset manually from `assets.publishing.service.gov.uk`,
follow these steps:

1. `ssh backend-1.production`
1. `govuk_app_console asset-manager`
1. `asset = Asset.find("asset-id-from-url")` (e.g. `57a9c52b40f0b608a700000a`) or for a Whitehall asset `asset = WhitehallAsset.find_by(legacy_url_path: '/government/uploads/system/uploads/attachment_data/file/id/path.extension')`
1. Make a note of the path of the asset: `asset.file.path` - this will be used to delete the file from the file system
1. Mark the asset as deleted (and remove it from S3 if necessary - this will prevent restoration)
   - [`rake assets:delete[<asset.id>]`][rake-delete]
   - [`rake assets:delete_and_remove_from_s3[<asset.id>]`][rake-delete-and-remove-from-s3]
1. Remove the asset from asset-manager file system (it may not be here as these are automatically removed after S3 upload)
    1. `ssh asset-master-1.production`
    1. `cd /mnt/uploads/asset-manager/assets`
    1. Use the path identified in step 5 to check for the file by removing the `/var/apps/asset-manager/uploads/assets` prefix
    1. `sudo rm path/to/file`
1. Add a cache bust and check that the asset responds with a 404 not found
1. Wait 20 minutes for the cache to clear, or [purge it yourself][clear-cache]
1. Verify that the asset is not there
1. Request removal of the asset using the [Google Search Console](https://www.google.com/webmasters/tools/removals)

> **Note**
>
> You might need to look at the timestamps or other information to figure
> out which records to delete if two assets share the same filename.
>
> HM Courts & Tribunals Service (HMCTS) occasionally request this through Zendesk.

[rake-delete]: https://deploy.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=asset-manager&MACHINE_CLASS=backend&RAKE_TASK=assets:delete[]
[rake-delete-and-remove-from-s3]: https://deploy.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=asset-manager&MACHINE_CLASS=backend&RAKE_TASK=assets:delete_and_remove_from_s3[]
[clear-cache]: https://docs.publishing.service.gov.uk/manual/cache-flush.html#assets
