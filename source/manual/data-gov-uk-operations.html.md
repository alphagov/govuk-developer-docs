---
owner_slack: "#govuk-platform-health"
title: Operation of data.gov.uk
section: data.gov.uk
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-10-11
review_in: 6 weeks
---
[find]: apps/datagovuk_find
[publish]: apps/datagovuk_publish
[ckan]: apps/ckanext-datagovuk

## Accessing data.gov.uk

### PaaS

1. Download and install [Cloud Foundry CLI](https://github.com/cloudfoundry/cli#downloads)

2. Sign into the PaaS. You will be prompted for your username and password. If your account is not recognised, ask 2nd line for access. After authenticating, a list of your accessible spaces will be shown, select `data-gov-uk`.

```
cf login -a api.cloud.service.gov.uk
```

3. SSH into the relevant machine, e.g. `publish-data-beta-production-worker`.

```
cf ssh publish-data-beta-production-worker
```

There are [detailed instructions](https://docs.cloud.service.gov.uk/get_started.html#set-up-command-line) in the PaaS documentation.

#### Accessing a Rails Console

The following can be used on any PaaS machine to access a Rails console.  The example is for the Find production instance.

```
cf ssh find-data-beta
/tmp/lifecycle/launcher /home/vcap/app 'rails console' ''
```

#### Reindexing [Find]

This is done using the `search:reindex` rake task in [Publish] and will not cause any app downtime.

```
cf ssh publish-data-beta-staging
/tmp/lifecycle/launcher /home/vcap/app 'rails search:reindex[500]' ''
```

This will populate a new index and rotate the `dataset-staging` alias to point to it when it's ready.

#### Perform a full re-sync from [CKAN]

The sync is normally done automatically using Sidekiq Scheduler. There may be times when you need to throw away the existing Postgres database, sync all datasets from CKAN and reindex.

This will not make any changes to the content on Find until the reindex has completed and the Elastic index is updated.  This will affect data served on Publish, however this service is not currently used for publishing or editing datasets.  In most cases, you should never need to do this as the sync performs incremental updates.

```
### connect to staging
cf ssh publish-data-beta-staging
### connect to production
cf ssh publish-data-beta-production

## make sure the database is empty
/tmp/lifecycle/launcher /home/vcap/app 'rails db:drop db:setup' ''

## make sure the index is setup
/tmp/lifecycle/launcher /home/vcap/app 'rails search:reindex' ''

## sync datasets or update orgs
/tmp/lifecycle/launcher /home/vcap/app 'rails runner CKAN::V26::PackageSyncWorker.new.perform' ''
/tmp/lifecycle/launcher /home/vcap/app 'rails runner CKAN::V26::CKANOrgSyncWorker.new.perform' ''
```

Now run `bundle exec sidekiq` and `rails s` and monitor the resulting jobs in the [Sidekiq Web UI](/manual/data-gov-uk-monitoring.html#sidekiq-publish).

### Bytemark

You will need to arrange with 2nd line for your public SSH key to be added to the Bytemark production server.  Once this is done, you can connect by SSH with the username `co`.

```
ssh co@co-prod3.dh.bytemark.co.uk
```

**When working on co-prod3, you must pair because we don't have a robust development environment for the current CKAN configuration.**
