---
owner_slack: "#govuk-developers"
title: Remove a change note in Whitehall
section: Publishing
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-09-12
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

Rake Tasks exist in both Publishing API and Whitehall to quickly remove change notes for a document. The tasks take a content id, content locale and the text of the change note.
There are two interfaces for dry and real runs, to ensure the correct change note is being targetted before removing it.

**Note**
> It performs a fuzzy-search of the change note text, and will return the first best match. So searching for
> generic words such as "Update" may not return the exact ChangeNote you desire. It is advised to use the
> dry run first to ensure the correct ChangeNote will be deleted.

##### Publishing API

**Note**
> Individual publishing apps may have their own equivalent of this task. If possible, remove change notes in the
> specific publishing application: use this Publishing API task as a last resort!

###### Dry run

```bash
$ bundle exec 'data_hygiene:remove_change_note:dry[content_id,locale,change note text]'
```

[Jenkins - integration](https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/parambuild/?delay=0sec&TARGET_APPLICATION=publishing-api&MACHINE_CLASS=publishing_api&RAKE_TASK=%27data_hygiene:remove_change_note:dry[CONTENT_ID,en,CHOSEN%20CHANGE%20NOTE%20TEXT]%27)

This attempts to locate the selected change note for the content, and if found, report to the user the change note object that would have been removed.

###### Real run

```bash
$ bundle exec 'data_hygiene:remove_change_note:real[content_id,locale,change note text]'
```

[Jenkins - integration](https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/parambuild/?delay=0sec&TARGET_APPLICATION=publishing-api&MACHINE_CLASS=publishing_api&RAKE_TASK=%27data_hygiene:remove_change_note:real[CONTENT_ID,en,CHOSEN%20CHANGE%20NOTE%20TEXT]%27)

This will actually *delete* the selected change note and re-represent to the content store, also updating the edition history.

##### Whitehall

###### Dry run

```bash
$ bundle exec 'data_hygiene:remove_change_note:dry[content_id,locale,change note text]'
```

[Jenkins - integration](https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/parambuild/?delay=0sec&TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=%27data_hygiene:remove_change_note:dry[CONTENT_ID,en,CHOSEN%20CHANGE%20NOTE%20TEXT]%27)

This attempts to locate the selected change note for the content, and if found, report to the user the change note text that would have been removed.

###### Real run

```bash
$ bundle exec 'data_hygiene:remove_change_note:real[content_id,locale,change note text]'
```

[Jenkins - integration](https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/parambuild/?delay=0sec&TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=%27data_hygiene:remove_change_note:real[CONTENT_ID,en,CHOSEN%20CHANGE%20NOTE%20TEXT]%27)

This will downgrade the edition to a `minor change`, set the change note text to `nil` and the `major_change_published_at` to the previous major change. It then re-represents to the content store with the updated edition history.
