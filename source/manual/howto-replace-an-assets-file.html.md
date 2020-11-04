---
owner_slack: "#govuk-2ndline"
title: Replace an asset's file
section: Assets
layout: manual_layout
parent: "/manual.html"
---

*Note: This will not apply to any file that has not already been uploaded. If you're trying to upload a large file for a client, [upload a small one first](upload-asset-to-whitehall.html) then replace with the below steps. If you're trying to fix a file that is stuck uploading in Whitehall, [look here](whitehall-file-stuck-uploading.html).*

If you need to replace the file of an existing attachment without
changing the URL, follow these steps:

0. Copy the new file from your computer to a `backend` server:

    ```
    gds govuk connect scp-push -e <environment> aws/backend:1 filename.ext /tmp
    ```

0. Get an app console on that same server:

    ```
    gds govuk connect ssh -e <environment> aws/backend:1
    govuk_app_console asset-manager
    ```

0. Find the asset:

    ```
    asset = Asset.find("asset-id-from-url")` # e.g. `57a9c52b40f0b608a700000a`
    # or for a Whitehall asset:
    asset = WhitehallAsset.find_by(legacy_url_path: '/government/uploads/system/uploads/attachment_data/file/id/path.ext')`
    ````

0. Check the asset is what you think it is.

0. Replace the file:

    ```
    asset.file = Pathname.new("/tmp/filename.ext").open
    asset.save!
    ```
