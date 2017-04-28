---
owner_slack: "#2ndline"
title: Remove an asset
section: Assets
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/2nd-line/howto-manually-remove-assets.md"
last_reviewed_at: 2017-02-28
review_in: 6 months
---



> **This page was imported from [the opsmanual on github.gds](https://github.gds/gds/opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.gds/gds/opsmanual/tree/master/2nd-line/howto-manually-remove-assets.md)


# Remove an asset

If you need to remove an asset manually from `assets.publishing.sevice.gov.uk`,
follow these steps:

1. `ssh asset-master-1.production`
2. `sudo find / -name some-asset.pdf`
3. `sudo rm /mnt/uploads/asset-manager/assets/.../some-asset.pdf`
4. `ssh backend-1.production`
5. `cd /var/apps/asset-manager`
6. `sudo su deploy govuk_setenv asset-manager bundle exec rails c`
7. `asset = Asset.find("asset-id-from-url")` (e.g. 57a9c52b40f0b608a700000a)
8. Check the asset is what you think it is and delete: `asset.destroy`
9. Navigate to your local fabric-scripts directory
10. `fab production cdn.purge_all:'/media/.../some-asset.pdf`
11. Check that the asset responds with a 404

\* Note: You might need to look at the timestamps or other information to figure
out which records to delete if two assets share the same filename.
