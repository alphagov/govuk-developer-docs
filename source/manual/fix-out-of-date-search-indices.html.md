---
owner_slack: "#govuk-searchandnav"
title: Fix out-of-date search indices
parent: "/manual.html"
layout: manual_layout
section: Backups
---

If the data in the search index is out-of-sync with the Publishing API,
(for example, after [restoring a backup][restore-backups]), then any `publish`
and `unpublish` messages that have not been processed need to be resent.

## `govuk` index

Content in the `govuk` index is populated from the [Publishing API message queue][queue].
Missing documents can be recovered by resending the content to the message queue, using
the `represent_downstream:published_between` rake task.

Run the `represent_downstream:published_between['2018-12-17T01:02:30,%202018-12-18T10:20:30']` rake task in Publishing API, but changing the two timestamps to cover the period of downtime.

[Other replay options are available](https://github.com/alphagov/publishing-api/blob/main/lib/tasks/represent_downstream.rake), for example replaying all traffic for a single publishing app or doctype.
Be aware that these options will replay the entire Publisher API history for that app or doctype, and may take some time.

## `government`/`detailed` indexes

**This will not be necessary after whitehall content has been moved to the
`govuk` index.**

These indexes are populated by whitehall calling an HTTP API in Search API.
Missing documents can be recovered by resending the content to Search API directly.

Run the `search:index:published_between['2018-12-17T01:02:30,%202018-12-18T10:20:30']` rake task in Whitehall, remembering to change the two timestamps.

## `metasearch` index

This index is used for best bets, which are published by Search Admin
communicating with Search API directly (like how whitehall updates the
`government` and `detailed` indices directly).

Run the `reindex_best_bets` rake task in search admin to resend all bets to Search API.

[restore-backups]: /manual/elasticsearch-dumps.html
[queue]: https://github.com/alphagov/search-api/blob/main/docs/new-indexing-process.md
