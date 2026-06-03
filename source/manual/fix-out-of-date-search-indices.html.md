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

## `metasearch` index

This index contains best bets, which used to be published by Search Admin until that functionality was removed in https://github.com/alphagov/search-admin/pull/1174.
There is currently no support for reindexing this index. This is known tech debt.

## `page-traffic` index

The `page-traffic` index contains traffic data from GA4, which is used to update popularity scores on content in the `govuk` index.
(See docs on [updating popularity][popularity-docs] for more information.) There is a [nightly cron job][popularity-job], which
updates this index. To update it manually, you can run the [associated rake task][popularity-rake-task].

[restore-backups]: /manual/elasticsearch-dumps.html
[queue]: https://github.com/alphagov/search-api/blob/main/docs/new-indexing-process.md
[popularity-docs]: https://docs.publishing.service.gov.uk/repos/search-api/updating_popularity.html
[popularity-job]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/app-config/values-production.yaml#L2972
[popularity-rake-task]: https://github.com/alphagov/search-api/blob/main/lib/tasks/page_traffic.rake
