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
Missing documents can be recovered by resending the content to the message queue. In the
Publishing API, run the following rake task (including the quotes) to replay traffic between
two datestamps:

```
govuk_setenv publishing-api bundle exec \
rake 'represent_downstream:published_between[2018-12-17T01:02:30, 2018-12-18T10:20:30]'
```

You can also run this task from Jenkins.

[Other replay options are available](https://github.com/alphagov/publishing-api/blob/master/lib/tasks/represent_downstream.rake), for example replaying all traffic for a single publishing app or doctype.
Be aware that these options will replay the entire Publisher API history for that app or doctype, and may take some time.

## `government`/`detailed` indexes

**This will not be neccessary after whitehall content has been moved to the
`govuk` index.**

These indexes are populated by whitehall calling an HTTP API in Search API.
Missing documents can be recovered by resending the content to Search API directly. In
Whitehall, run the following rake task (including the quotes) to replay traffic between
two datestamps:

```
govuk_setenv whitehall bundle exec \
rake 'search:index:published_between[2018-12-17T01:02:30, 2018-12-18T10:20:30]'
```

You can also run this task from Jenkins.

## `metasearch` index

This index is used for best bets, which are published by Search Admin
communicating with Search API directly (like how whitehall updates the
`government` and `detailed` indices directly).  In Search Admin, run
the following rake task to resend all bets to Search API:

```
govuk_setenv search-admin bundle exec \
rake reindex_best_bets
```

You can also run this task from Jenkins.

[restore-backups]: https://docs.publishing.service.gov.uk/manual/elasticsearch-dumps.html
[queue]: https://github.com/alphagov/search-api/blob/master/docs/new-indexing-process.md
