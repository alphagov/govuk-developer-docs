---
owner_slack: "#govuk-2ndline"
title: Remove an asset
section: Assets
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-08-09
review_in: 6 months
---

If you need to remove an asset manually from `assets.publishing.service.gov.uk`,
follow these steps:

1. `ssh backend-1.production`
2. `govuk_app_console asset-manager`
3. `asset = Asset.find("asset-id-from-url")` (e.g. `57a9c52b40f0b608a700000a`) or for a Whitehall asset `asset = WhitehallAsset.find_by(legacy_url_path: '/government/uploads/system/uploads/attachment_data/file/id/path.extension')`
4. Make a note of the UUID for the asset: `asset.uuid` - this will be used to delete the file from Amazon S3
5. Make a note of the path of the asset: `asset.file.path` - this will be used to delete the file from the file system
6. Check the asset is what you think it is and mark it as deleted: `asset.destroy`
7. Remove the asset from AWS S3
    1. Log into AWS console and [assume a role][assume-role] for govuk-infrastructure-production
    2. In the [govuk-assets-production S3 bucket][govuk-assets-production-bucket] search for a file named with the UUID identified in step 4
    3. Delete this file
8. Remove the asset from asset-manager file system (it may not be here as these are automatically removed after S3 upload)
    1. `ssh asset-master-1.production`
    2. `cd /mnt/uploads/asset-manager/assets`
    3. Use the path identified in step 5 to check for the file by removing the `/var/apps/asset-manager/uploads/assets` prefix
    4. `sudo rm path/to/file`
9. Navigate to your local fabric-scripts directory
10. `fab production class:cache cdn.purge_all:'/media/.../some-asset.pdf`
11. Check that the asset responds with a 404
12. Request removal of the asset using the [Google Search Console](https://www.google.com/webmasters/tools/removals)

\* Note: You might need to look at the timestamps or other information to figure
out which records to delete if two assets share the same filename.

[assume-role]: /manual/user-management-in-aws.html#switching-roles-to-govuk-accounts
[govuk-assets-production-bucket]: https://s3.console.aws.amazon.com/s3/buckets/govuk-assets-production/?region=eu-west-1&tab=overview
