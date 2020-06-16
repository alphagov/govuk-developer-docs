---
owner_slack: "#govuk-2ndline"
title: Modify a change note in Publishing API
section: Publishing
layout: manual_layout
parent: "/manual.html"
---

Spelling mistakes can creep into change notes, and we are often asked
to correct them.

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
