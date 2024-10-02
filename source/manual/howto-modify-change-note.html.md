---
owner_slack: "#govuk-publishing"
title: Modify a change note in Publishing API, Content Publisher or Whitehall
section: Publishing
layout: manual_layout
parent: "/manual.html"
---

We are sometimes asked to amend [change notes](https://www.gov.uk/guidance/content-design/writing-for-gov-uk#change-notes), for example where a user has made a typo. This playbook describes how to amend change notes in Whitehall, Content Publisher and Publishing API.

## Whitehall

Whitehall supports modifying change notes directly from the UI. The feature is hidden from publishers, but available to anyone with `GDS Admin` permissions.

2nd-line Content Support team can modify the change note themselves:

1. Append `/change_notes` to the URL of the admin screen, for example:
  `https://whitehall-admin.publishing.service.gov.uk/government/admin/editions/<edition-id>/change_notes`
1. You may need to replace the portion after `/admin/` with the word `editions`. For example,
  `https://whitehall-admin.publishing.service.gov.uk/government/admin/publications/1389309/change_notes` won't work, but
  `https://whitehall-admin.publishing.service.gov.uk/government/admin/editions/1389309/change_notes` will.

__Adding__ a change note is not yet supported in the UI. You can use the Rails console, for example:

```ruby
ed = Edition.where(id: <relevant id>).first
ed.state = "draft"
ed.save
ed.update(minor_change: false, change_note: "Change note", major_change_published_at: Time.new(2022,12,21))
ed.save
ed.state = "published"
ed.save
```

## Content Publisher

Content Publisher has a [set of rake tasks](https://github.com/alphagov/content-publisher/blob/main/lib/tasks/change_history.rake) for adding, deleting and editing change notes.

## Specialist Publisher

Use the [Publishing API procedure](#publishing-api) below.

## Other Publishing Apps

The other publishing apps do not yet provide a way to update a change note.

Use the app's Rails console to update the change history in the app's own database, then republish the document via the app's web UI.

## Publishing API

> ⚠️ You should use the relevant publishing app to modify a change note where possible. Only use publishing-api where a publishing app lacks support for updating change notes.

1. Obtain kubectl credentials for the EKS cluster. Follow [the set up guide](/kubernetes/get-started/set-up-tools/) if unfamiliar.

1. Open a Rails console on Publishing API:

    ```sh
    k exec -it deploy/publishing-api -- rails c
    ```

1. Find the document:

    ```ruby
    document = Document.find_by_content_id("YOUR_CONTENT_ID_HERE")
    ```

1. Find the document's live edition:

    ```ruby
    live_edition = document.editions.live.last
    ```

1. Fetch the edition's details change history:

    ```ruby
    live_edition.details[:change_history]
    ```

   If this is empty, follow method A. Otherwise, follow method B.

### Method A: update an individual ChangeNote

1. Fetch the change notes for the document:

    ```ruby
    change_notes = ChangeNote.joins(:edition).where(editions: { document: document }).order(:public_timestamp)
    ```

1. Retrieve the change note to amend, for example by searching for the note text:

    ```ruby
    note = change_notes.find_by("note LIKE ?", "%SUBSTRING OR FULL CHANGE NOTE TEXT%")
    ```

1. Update the change note:

    ```ruby
    note.update(note: "NEW NOTE")
    ```

1. [Send the document downstream] using the content ID.

### Method B: update `details.change_history`

1. Fetch the details for the edition:

    ```ruby
    details = live_edition.details
    ```

1. View the change history:

    ```ruby
    details[:change_history]
    ```

1. Retrieve the change note to amend, for example by searching for the note text:

    ```ruby
    change_note_index = details[:change_history].find_index { |change_note| change_note[:note] =~ /SUBSTRING OR FULL CHANGE NOTE TEXT/ }
    ```

1. Check the returned change note is correct:

    ```ruby
    details[:change_history][change_note_index]
    ```

1. Update the change note:

    ```ruby
    details[:change_history][change_note_index][:note] = "New note"
    ```

1. Update the edition:

    ```ruby
    live_edition.update(details: details)
    ```

1. [Send the document downstream] using the content ID.

## Troubleshooting

### Change note is in content item in Whitehall and publishing-api but not showing on page

Content Store may be out of sync with Publishing API.

- If the problem is only in staging/integration and not production, check for failed [environment sync jobs](https://argo.eks.staging.govuk.digital/applications/db-backup) for content-store or publishing-api.
- Check the [Sidekiq monitoring queue](/manual/sidekiq.html#monitoring) to see if the document is stuck somewhere in a queue.
- Look in [Kibana](/manual/tools.html#kibana) for responses with `status:409` (resource conflict). This can indicate that content-store already has a more recent version of the document than publishing-api.
- Compare the `payload_version` in publishing-api and content-store in the Rails console. Content Store will reject the request if the the request's `payload_version` is not newer than the one in the content-store database. See also [content-data-api: Processing publishing-api messages: Discarding messages](https://github.com/alphagov/content-data-api/blob/main/docs/processing_publishing_api_messages.md#discarding-messages).

[Send the document downstream]: /repos/publishing-api/admin-tasks.html#representing-data-downstream
