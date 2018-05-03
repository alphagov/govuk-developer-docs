---
owner_slack: "#govuk-2ndline"
title: Remove an asset
section: Assets
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-03-22
review_in: 6 months
---

If you need to remove an asset manually from `assets.publishing.service.gov.uk`,
follow these steps:

1. `ssh asset-master-1.production`
2. `sudo find / -name some-asset.pdf`
3. `sudo rm /mnt/uploads/asset-manager/assets/.../some-asset.pdf`
4. `ssh backend-1.production`
5. `govuk_app_console asset-manager`
6. `asset = Asset.find("asset-id-from-url")` (e.g. `57a9c52b40f0b608a700000a`)
7. Check the asset is what you think it is and delete: `asset.destroy`
8. Navigate to your local fabric-scripts directory
9. `fab production cdn.purge_all:'/media/.../some-asset.pdf`
10. Check that the asset responds with a 404

\* Note: You might need to look at the timestamps or other information to figure
out which records to delete if two assets share the same filename.
