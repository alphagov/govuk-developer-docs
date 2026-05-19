---
owner_slack: "#govuk-search"
title: "Delete a document from Discovery Engine"
parent: "/manual.html"
layout: manual_layout
section: Search on GOV.UK
related_repos: [search-api-v2]
---
[link-1]: https://github.com/alphagov/search-admin/blob/main/lib/tasks/document.rake#L8

## Delete a document from the datastore

A [rake task][link-1] exists for dire emergencies where a piece of content has not been correctly deleted from the datastore via the normal channels. This can happen when someone deletes a document directly from the Publishing API database without firing the callbacks that trigger a message queue `unpublish` message.

```
$ kubectl -n apps exec -it deploy/search-admin -- bundle exec rake document:delete_document[<content_id>]
```
