---
owner_slack: "#govuk-2ndline"
title: Modify a change note in Publishing API or Whitehall
section: Publishing
layout: manual_layout
parent: "/manual.html"
---

Spelling mistakes can creep into [change notes](https://www.gov.uk/guidance/content-design/writing-for-gov-uk#change-notes), and we are often asked to correct them. The instructions below cover doing this task in the Publishing API and in Whitehall - if your change note lives in Whitehall and is updated in the Publishing API it could be overwritten later.

## Publishing API

Connect to the Publishing API console:

```
govuk-connect app-console -e production publishing_api/publishing-api
```

Then find your document and update its content. You should see the
`note` and `updated_at` values change.

```
$ d = Document.find_by_content_id("4dc38774-e687-4bff-aa68-6e08c66e98f9")
=> #<ChangeNote id: 397621, note: "Bar", public_timestamp: "2020-06-16 11:02:22", edition_id: 5146461, created_at: "2020-06-16 10:22:34", updated_at: "2020-06-16 11:02:22">

$ d.live.change_note.update(note: "Foo")
=> true

$ d
=> #<ChangeNote id: 397621, note: "Foo", public_timestamp: "2020-06-16 11:02:22", edition_id: 5146461, created_at: "2020-06-16 10:22:34", updated_at: "2020-06-16 15:24:53">
```

## Whitehall

The following commands show you how to find the document, get the correct edition within it, and update it. To complete this you will need the document ID, a string to search for to identify the right change log entry (search is fuzzy, be precise to get the right one), and the string you want to replace the current change log.

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

Output shows the relevant edition that needs the change note update. Update it:

```
edition.update(change_note: "YOUR_DESIRED_CHANGE_NOTE_STRING")
```

The response to this is "false" but the update has taken place. You can confirm this if you want to by typing "edition" to review it. Save the changes:

```
edition.save!(validate: false)
```

Republish the document using a [Whitehall Rake task](https://docs.publishing.service.gov.uk/manual/republishing-content.html)
