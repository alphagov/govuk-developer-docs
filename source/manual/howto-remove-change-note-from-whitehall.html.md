---
owner_slack: "#2ndline"
title: Remove a change note in Whitehall
section: Whitehall
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-02-09
review_in: 6 months
---

Change notes are called `editorial_remarks` in Whitehall. An Edition can 
have multiple editorial remarks, but in the Publishing API an Edition can 
only have one single change note. Not all editorial remarks are propagated 
to the Publishing API, only ones marking major changes. The Publishing API 
then creates a list of all the change notes from all versions of the edition
and presents them to the Content Store. You can read more about this in the 
Publishing API [docs](https://docs.publishing.service.gov.uk/apis/publishing-api/model.html#changenote).

### Remove a Change Note

Steps to undertake when someone has requested that you remove a change note 
from Whitehall: 

1. Obtain the ID of the edition on which the change note was created. 
1. Create a migration in Whitehall where you search for the edition by ID 
and extract the `editorial_remarks` from it. Find the editorial remark 
containing the text of the change note and destroy it. An example PR can 
be found [here](https://github.com/alphagov/whitehall/pull/3762/files#diff-4beba2c08746b9f02186f396b3cc1df0R17). 
This will also remove it from the editorial_remark_trail stored on the Edition 
in Whitehall.
1. Check in the UI that the change note is no longer displayed. 
1. If the change note was indicating a major change, then it will be propagated 
to an Edition in publishing-api. You can search for that edition using the content 
item id (Edition IDs will not coincide between whitehall and
publishing-api). You can also do a freetext search for the change note text in
publishing-api. If it was a minor change, you will not find the change note in 
publishing-api. 
1. If you do find a change note, you will have to delete it and re-send 
the edition to the content store to be updated. 
