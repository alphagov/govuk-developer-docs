---
owner_slack: "#govuk-platform-health"
title: Troubleshooting data.gov.uk
section: data.gov.uk
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-10-11
review_in: 6 weeks
---
[find]: apps/datagovuk_find
[publish]: apps/datagovuk_publish
[ckan]: apps/ckanext-datagovuk

## Different number of datasets in [CKAN] to [Find]

Determine the number of datasets in CKAN using the API.

```
https://data.gov.uk/api/3/search/dataset
```

Determine the number of datsets in the Publish Postgres database using the Rails console.

```
cf ssh publish-data-beta-production
/tmp/lifecycle/launcher /home/vcap/app 'rails console' ''
>>> Dataset.count
```

If these numbers match, but the number of datasets served on Find is still different, identify the number of published in the Publish Postgres database.

```
cf ssh publish-data-beta-production
/tmp/lifecycle/launcher /home/vcap/app 'rails console' ''
>>> Dataset.published.count
```

With the current set up, all datasets that are available through the CKAN API will be marked as public in the Publish Postgres database.  Therefore, if you get a different number of datasets, you should mark them all as published in the Publish Postgres database.

```
cf ssh publish-data-beta-production
/tmp/lifecycle/launcher /home/vcap/app 'rails console' ''
>>> Dataset.update(status: 'published')
```

A [reindex](/manual/data-gov-uk-operations.html#reindexing-find) must then be done to update the status with the Elastic instance that serves Find.

## Datasets published in CKAN are not appearing on Find

Check the Sidekiq queue (see [monitoring section](/manual/data-gov-uk-monitoring.html#sidekiq-publish)) length to ensure the queue length is not too long.  You should not be seeing more jobs than the number of datasets in CKAN.

If the queue is too long, you should clear the queue.  The next sync process will repopulate the queue with any relevant datasets that require updating.

