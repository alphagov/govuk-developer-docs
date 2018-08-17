---
owner_slack: "#govuk-2ndline"
title: Remove a change note in Whitehall
section: Whitehall
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-08-17
review_in: 6 months
---

Change notes are called editorial remarks in Whitehall. An Edition can
have multiple editorial remarks and they are visible only in Whitehall
Admin. However, an Edition in the Publishing API can only have one `change_note`, which is public-facing. The Publishing API creates a list of all the change notes
from all versions of the edition and presents them to the Content Store.
You can read more about this in the Publishing API [docs](https://docs.publishing.service.gov.uk/apis/publishing-api/model.html#changenote).

### Remove a change note

You need to determine whether the request is referring to an `editorial_remark` in Whitehall Admin, or to a public-facing `change_note` in Publishing API.

#### Editorial Remark
1. Obtain the content ID of the document on which the change note was created.
This document will contain multiple editions. You need to extract the
`editorial_remark` from these editions.
1. Create a data migration in Whitehall [docs here](https://github.com/alphagov/whitehall/blob/19cd7d72de32454d532c195f35b027fa1b3ba6ac/db/data_migration/README.md)
1. In the data migration, search for the document by the content ID and
extract the `editorial_remark` that contains the text you are looking to delete.
1. If such an editorial remark is present, then destroy the `editorial_remark`
and check that it is no longer displayed.

#### Change Note
1. Search for the document by content ID in the Publishing API:
`Document.where(content_id: "your-content-id")` and extract the `change_note`.
If the document is associated with multiple editions, you should search through all
of them for the text of the change note: `document.editions.map(&:change_note)`.
An example PR can be [found here](https://github.com/alphagov/publishing-api/pull/1160)
1. Find the change note containing the text you are looking to delete and destroy it.
1. Check hat the change note is no longer displayed.
1. If the change note was indicating a major change, then it will be propagated
to an Edition in Publishing API. You can search for that edition using the content ID (Edition IDs will not coincide between whitehall and
Publishing API). You can also do a free-text search for the change note.
1. Delete the change note and re-send the edition to the Content Store to be updated.
1. You will also have to delete the change history as this does not get regenerated
automatically. This change also has to represented downstream to the Content Store
so you should combine it with the previous step. An example PR can be [found here](https://github.com/alphagov/publishing-api/pull/1167/files)
