---
owner_slack: "#govuk-2ndline-tech"
title: Modify a change note in Publishing API or Whitehall
section: Publishing
layout: manual_layout
parent: "/manual.html"
---

Spelling mistakes can creep into [change notes](https://www.gov.uk/guidance/content-design/writing-for-gov-uk#change-notes), and we are often asked to correct them. The instructions below cover doing this task in the Publishing API and in Whitehall - if your change note lives in Whitehall and is updated in the Publishing API it could be overwritten later.

## Whitehall

The following commands show you how to find the document, get the correct edition within it, and update it. To complete this you will need the document ID, a string to search for to identify the right change log entry (search is fuzzy, be precise to get the right one), and the string you want to replace the current change note text.

Connect to the Whitehall console (test your change on Integration first):

```
govuk-connect app-console -e integration whitehall_backend/whitehall
```

Find the document:

```
document=Document.find_by_content_id("YOUR_CONTENT_ID_HERE")
```

Output will be a summary of your document. Next, select the editions:

```
editions=document.editions
```

Output is a potentially long list of the editions. Next set up the parameters for fuzzy matching:

```
fuzzy_match = FuzzyMatch.new(editions, read: :change_note)
```

Output should show the change notes. Select the relevant one:

```
edition = fuzzy_match.find("A_STRING_FROM_YOUR_CHANGE_NOTE", must_match_at_least_one_word: true)
```

Check the returned edition and change note to ensure it's the correct one:

```
edition.change_note
edition.major_change_published_at
```

Update it (without validation checks):

```
edition.update_attribute(:change_note, "YOUR_DESIRED_CHANGE_NOTE_STRING")
```

Republish the document using a [Whitehall Rake task](https://docs.publishing.service.gov.uk/manual/republishing-content.html)

## Publishing API

Publishing API handles change notes in two different ways. To update the change history of a document, you'll either need to update an individual [ChangeNote] or update the `change_history` in the [details JSON] of the published edition.

**Note**
> Updating change notes in Publishing API should only be done when unable to from the publishing app (to avoid Publishing API being overwritten).

First step is to connect to the Publishing API console:

```
govuk-connect app-console -e production publishing_api/publishing-api
```

Find the document:

```
document = Document.find_by_content_id("YOUR_CONTENT_ID_HERE")
```

Find the documents live edition:

```
live_edition = document.editions.live.last
```

Check edition's details hash for `change_history`. If this is empty then follow method 1, if not, follow method 2:

```
live_edition.details[:change_history]
```

### Method 1 (empty change_history)

Fetch the change notes for the document:

```
change_notes = ChangeNote.joins(:edition).where(editions: { document: document }).order(:public_timestamp)
```

Select the relevant change note manually, or by searching for the note text:

```
change_note = change_notes.find_by("note LIKE ?", "%SUBSTRING OR FULL CHANGE NOTE TEXT%")
```

Update change note:

```
change_note.update(note, "NEW NOTE")
```

Finally, [send the document downstream] using the content id.

### Method 2 (present change_history)

Fetch details for edition:

```
details = live_edition.details
```

Ouput change history:

```
details[:change_history]
```

Select relevant change note manually, or by seaching for the node text:

```
change_note_index = details[:change_history].find_index { |change_note| change_note[:note] =~ /SUBSTRING OR FULL CHANGE NOTE TEXT/ }
```

Check the returned change not is correct:

```
details[:change_history][change_note_index]
```

Update change note:

```
details[:change_history][change_note_index][:note] = "New note"
```

Update edition:

```
edition.update(details: details)
```

Finally, [send the document downstream] using the content id.

## Troublshooting

The steps below helped us in a situation where the change note was present in the content item
in both Whitehall and publishing-api, but was not being reflected on the page itself. We
found this was due to the content-store not being in sync with the publishing-api. This can
happen in `staging` due to an issue with the overnight data sync.

Things we tried:

- [purge the page from cache]
- check the [Sidekiq monitoring queue] to see if the document is stuck somewhere in a queue
- look in [Kibana] - there might be some with the status `409` which might be due to the content-store thinking it's got more up to date data than the publishing-api
- compare the `payload_version` in publishing-api and content-store in the console, if the request from publishing-api is lower it will be ignored (also see this [doc on publishing-api messages])

[ChangeNote]: https://github.com/alphagov/publishing-api/blob/main/app/models/change_note.rb
[details JSON]: https://github.com/alphagov/publishing-api/blob/d6707237ee31090b2bb04015ba71d476f462448a/db/schema.rb#L85
[send the document downstream]: https://docs.publishing.service.gov.uk/repos/publishing-api/admin-tasks.html#representing-data-downstream
[sidekiq monitoring queue]: https://docs.publishing.service.gov.uk/manual/sidekiq.html#monitoring
[Kibana]: https://docs.publishing.service.gov.uk/manual/tools.html#kibana
[doc on publishing-api messages]: https://docs.publishing.service.gov.uk/repos/content-data-api/processing_publishing_api_messages.html#discarding-messages
[purge the page from cache]: https://docs.publishing.service.gov.uk/manual/purge-cache.html
