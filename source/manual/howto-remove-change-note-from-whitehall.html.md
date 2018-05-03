---
owner_slack: "#govuk-2ndline"
title: Remove a change note in Whitehall
section: Whitehall
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-02-09
review_in: 6 months
---

Change notes are called `editorial_remarks` in Whitehall. An Edition can
have multiple editorial remarks and they are visible only in the Whitehall
Admin. On the hand, an Edition in the Publishing API can only have one
single `change_note`. The change note is public facing as it is displayed on
the frontend. The Publishing API creates a list of all the change notes
from all versions of the edition and presents them to the Content Store.
You can read more about this in the Publishing API [docs](https://docs.publishing.service.gov.uk/apis/publishing-api/model.html#changenote).

### Remove a Change Note

First of all determine whether the person requesting that you remove a change note
is referring to an `editorial_remark` in the Whitehall Admin, or to a public facing
`change_note` which is collected from Publishing API.

#### Editorial Remark
1. Obtain the content item ID of the document on which the change note was created.
This can be done by visiting the `/api/content/` version of the edition's url.
This document will contain multiple editions. You will have to extract the
`editorial_remark` from these editions.
1. Create a data migration in Whitehall [docs here](https://github.com/alphagov/whitehall/blob/19cd7d72de32454d532c195f35b027fa1b3ba6ac/db/data_migration/README.md)
1. In the data migration, search for the document by the content item ID and
extract the `editorial_remark` that contains the text you are looking to delete.
1. If such an editorial remark is present, then destroy the `editorial_remark`
and check in the UI that it is no longer displayed.

#### Change Note
1. If not then it's probably a `change_note` in Publishing API so you should create
a migration in publishing API instead.
1. Similarly, search for the document by content item ID in publishing API:
`Document.where(content_id: "your-content-id")` and extract the `change_note`.
If the document is associated with multiple editions you should search through all
of them for the text of the change note: `document.editions.map(&:change_note)`.
An example PR can be found here: https://github.com/alphagov/publishing-api/pull/1160
1. Find the change note containing the text you are looking to delete and destroy it.
1. Check in the UI that the change note is no longer displayed.
1. If the change note was indicating a major change, then it will be propagated
to an Edition in publishing-api. You can search for that edition using the content
item id (Edition IDs will not coincide between whitehall and
publishing-api). You can also do a freetext search for the change note text in
1. If you do find a change note, you will have to delete it and re-send 
the edition to the content store to be updated. 
1. You will also have to delete the change history as this does not get regenerated 
automatically. This change also has to represented downstream to the content store
so you should combine it with the previous step. Example PR: https://github.com/alphagov/publishing-api/pull/1167/files

