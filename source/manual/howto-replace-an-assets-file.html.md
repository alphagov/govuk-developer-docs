---
owner_slack: "#govuk-2ndline"
title: Replace an asset's file
section: Assets
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-06-29
review_in: 6 months
---

If you need to replace the file of an existing attachment without
changing the URL, follow these steps:


0. Copy the new file from your computer to the server:

    ```
    scp filename.zip asset-master-1.production:/tmp/filename.zip
    ```

0. `ssh asset-master-1.production`

0. `govuk_app_console asset-manager`

0. Find the asset:
    ```ruby
    asset = Asset.find("asset-id-from-url")` # e.g. `57a9c52b40f0b608a700000a`
    # or for a Whitehall asset:
    asset = WhitehallAsset.find_by(legacy_url_path: '/government/uploads/system/uploads/attachment_data/file/id/path.extension')`
    ````

0. Check the asset is what you think it is.

0. Replace the file:
    ```ruby
    asset.update_attributes(file: Pathname.new("/tmp/filename.zip").open)
    ```
