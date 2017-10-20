---
owner_slack: "#2ndline"
title: Upload an asset to whitehall
section: Assets
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2017-10-20
review_in: 6 months
---

Sometimes publishers ask us to help them upload very large attachments to
documents in whitehall because they see timeouts when they try to upload the
document themselves.

The simplest way to do this is to upload a small file and replace it on the
server manually, making sure that it passes the usual virus scanning.

For apps other than whitehall, follow the [asset manager upload
guide](howto-upload-an-asset-to-asset-manager.html) instead.

0. In whitehall, attach a small file to the document being edited. Ensure the
  file name matches the name of the real file.

0. ssh to `whitehall-backend-0.backend.production` and
   `cd /data/uploads/whitehall/incoming/system/uploads/attachment_data/file/`.
   This is the directory which attachments are placed in before they are scanned
   for viruses and moved to the main assets directory.

0. Check that there is a folder in this directory which matches the ID of the
  small uploaded file. You can find this in the URL of the attachment in
  whitehall e.g. the "123456" in `https://whitehall-admin.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/123456/filename.zip`

0. Copy the real file from your computer to the server:

    ```
    scp filename.zip whitehall-backend-0.backend.production:/data/uploads/whitehall/incoming/system/uploads/attachment_data/file/123456/filename.zip
    ```

0. Wait for it to be processed. After a minute or so it should disappear from
  the directory you uploaded it to. You should now be able to download the full
  size file from whitehall publisher.

0. Run `govuk_app_console whitehall` on `whitehall-backend-1` and fix the file
  metadata:

    ```
    a = AttachmentData.find(123456) # This should match the attachment ID used earlier
    a.file_size = 987654321 # The size in bytes of the full file
    a.save!
    ```
