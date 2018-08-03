---
owner_slack: "#govuk-datagovuk"
title: Operation of data.gov.uk
section: data.gov.uk
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-06-22
review_in: 6 months
---
[find]: apps/datagovuk_find
[publish]: apps/datagovuk_publish
[ckan]: apps/ckanext-datagovuk

## Reindexing [Find]

This is done using the `search:reindex` rake task in [Publish] and will not cause any app downtime.

```
cf ssh publish-data-beta-staging
/tmp/lifecycle/launcher /home/vcap/app 'rails search:reindex[500]' ''
```

This will populate a new index and rotate the `dataset-staging` alias to point to it when it's ready.

## Sync from [CKAN]

This is done automatically using Sidekiq Scheduler. You can run manually to populate your local DB.

```
## make sure your local DB is empty
rails db:drop db:setup

## make sure your local index is setup
rails search:reindex

## sync datasets or update orgs
rails runner CKAN::V26::PackageSyncWorker.new.perform
rails runner CKAN::V26::CKANOrgSyncWorker.new.perform
```

Now run `bundle exec sidekiq` and `rails s` and monitor the resulting jobs in the [Sidekiq Web UI](/manual/data-gov-uk-monitoring.html#sidekiq-publish).
