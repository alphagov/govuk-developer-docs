---
owner_slack: "#govuk-2ndline"
title: Whitehall Attachment Stuck in Uploading State
parent: "/manual.html"
layout: manual_layout
section: Assets
---

In rare cases, typically when a user has uploaded a large archive of multiple files, the Whitehall backend can become stuck and not correctly update the uploading status of the file.

This results in the user being unable to publish an edition due to the Whitehall frontend being convinced that the upload is still ongoing, despite any evidence to the contrary.

The following needs access to the [Whitehall's Admin Panels](https://whitehall-admin.publishing.service.gov.uk/).

If you **can not** download the file from the draft edition, or it is corrupted, you will have to ask the user to upload a new version of the file. You may have to [replace the file in Asset Manager](howto-replace-an-assets-file.html) if this new version is also acting as if it is corrupted.

## Steps to fix

If you **can** download the file and open it without issue from the draft edition in [Whitehall's Admin Panels](https://whitehall-admin.publishing.service.gov.uk/) then the best course of action is the following:

1. [SSH into](howto-ssh-into-machines.html) the Whitehall backend machine and open a terminal into the rails app itself using `govuk_app_console whitehall`.

2. Use `attachment = AttachmentData.find(*attachmentid*)` to grab the attachment object into a variable.

3. Check that the attachment is **not** marked as uploaded using `attachment.uploaded_to_asset_manager?` and have it return false.

4. Reset its status using `attachment.uploaded_to_asset_manager!` and repeat step 3 to ensure it is now returning true. **This is potentially dangerous and should only be done if you can download the uncorrupted file. Test it on integration first!**

The list of files should show the attachment as uploaded now, and allow publication.

## Why this works

It is unknown how this can occur, but essentially for large enough files, the backend will not update the upload status correctly, leaving it as `nil`.

As a result, we will mark the uploading [status as still ongoing](https://github.com/alphagov/whitehall/blob/bc5b3daa909b7c7d084ad2c459a1577bb3f3b771/app/helpers/admin/editions_helper.rb#L236-L241), even if it's complete. Running the [aforementioned function](https://github.com/alphagov/whitehall/blob/070ba6d94de0b04d667ad28f55a30cd3a74ba772/app/models/attachment_data.rb#L82-L85) simply sets the uploaded status to complete.

**This does not actually check the file status, so it is important that you check the file is downloadable and not corrupted before you run the function.**
