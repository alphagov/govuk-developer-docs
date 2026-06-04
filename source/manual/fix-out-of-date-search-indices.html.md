---
owner_slack: "#govuk-search"
title: Fix out-of-date search indices
parent: "/manual.html"
layout: manual_layout
section: Search on GOV.UK
related_repos: [search-api]
---

## `govuk` index

GOV.UK content in [Search API](/repos/search-api.html) is stored in the `govuk` index in Elasticsearch.
This is populated from the [Publishing API message queue][queue]. This can get out of sync with publishing API,
which affects any part of the site using it, including navigation pages and related links.
This can happen after [restoring a backup][restore-backups] or [reindexing search][reindex-search].
When it does, any `publish` and `unpublish` messages that have not been processed need to be resent.

To resend the content to the message queue, use the `represent_downstream:published_between` rake task.
This will recover recently published documents that are missing or not up-to-date, and will remove recently unpublished documents.

Run the `represent_downstream:published_between['2018-12-17T01:02:30,%202018-12-18T10:20:30']` rake task in Publishing API, but changing the two timestamps to cover the period of downtime.

[Other replay options are available](https://github.com/alphagov/publishing-api/blob/main/lib/tasks/represent_downstream.rake), for example replaying all traffic for a single publishing app or doctype.
Be aware that these options will replay the entire Publisher API history for that app or doctype, and may take some time.

## `metasearch` index

The `metasearch` index contains best bets, which used to be published by Search Admin until that functionality was removed in https://github.com/alphagov/search-admin/pull/1174.
There is currently no support for reindexing this index. This is known tech debt.

## `page-traffic` index

The `page-traffic` index contains traffic data from GA4, which is used to update popularity scores on content in the `govuk` index.
(See docs on [updating popularity][popularity-docs] for more information.) There is a [nightly cron job][popularity-job], which
updates this index. To update it manually, you can run the [associated rake task][popularity-rake-task].

## Environment syncs

There are nightly cron jobs that [synchronise elasticsearch][sync-job] in integration and staging with the production environment.
These jobs work in sequence to take a snapshot of a higher level environment (e.g. production) and then restore the snapshot in the lower
level environment (e.g. staging). If documents that are published or unpublished in production are not reflected in integration and staging after 1 day, that
could be because of issues with the synchronisation jobs. If any part of the workflow needs to be rerun, this can be done manually in Argo:

1. Login to [Argo][argo] for the relevant environment
1. Navigate to the search-index-env-sync app
1. Find the relevant cron job:
   - `search-index-env-sync-green-es6-snapshot` takes a snapshot
   - `search-index-env-sync-green-es6-cp-prod` restores the production snapshot in staging
   - `search-index-env-sync-green-es6-cp-stag` restores the staging snapshot in integration
1. Click on the kebab menu next to the job name and click “Create Job”

[Taking a snapshot][snapshot-docs] does not cause any downtime. However, please be aware that restoring a snapshop in staging or integration
may wipe out changes that other developers are testing.

For more information on environment syncs across GOV.UK see https://docs.publishing.service.gov.uk/manual/govuk-env-sync.html

[restore-backups]: /manual/elasticsearch-dumps.html
[reindex-search]: /manual/reindex-elasticsearch.html
[queue]: https://github.com/alphagov/search-api/blob/main/docs/new-indexing-process.md
[popularity-docs]: https://docs.publishing.service.gov.uk/repos/search-api/updating_popularity.html
[popularity-job]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/app-config/values-production.yaml#L2972
[popularity-rake-task]: https://github.com/alphagov/search-api/blob/main/lib/tasks/page_traffic.rake
[sync-job]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/search-index-env-sync/values.yaml
[argo]: https://argo.eks.production.govuk.digital/
[snapshot-docs]: https://www.elastic.co/docs/deploy-manage/tools/snapshot-and-restore
