---
owner_slack: "#govuk-datagovuk"
title: Operation of data.gov.uk
section: data.gov.uk
layout: manual_layout
parent: "/manual.html"
---

[find]: repos/datagovuk_find
[publish]: repos/datagovuk_publish
[ckan]: repos/ckanext-datagovuk

## Accessing data.gov.uk

### Datagovuk kubernetes cluster

Publish and Find are hosted on the same AWS cluster as GOV.UK but in its own namespace - `datagovuk`

So to manage data.gov.uk apps you will need to add `-n datagovuk` to any `kubectl` command or run `kubectl config set-context --current --namespace=datagovuk` to make it the default.

You will be able to exec onto any datagovuk pod in a similar way to other GOV.UK apps.

#### Reindexing [Find]

This is done using the `search:reindex` rake task in [Publish] and will not cause any app downtime.

```
kubectl exec deploy/datagovuk-publish -n datagovuk -- rails 'search:reindex[500]'
```

This will populate a new index and rotate the index alias to point to it when it's ready.

#### Perform a full re-sync from [CKAN]

The sync is normally done automatically using Sidekiq Scheduler. There may be times when you need to throw away the existing Postgres database, sync all datasets from CKAN and reindex.

This will not make any changes to the content on Find until the reindex has completed and the Elastic index is updated.  This will affect data served on Publish, however this service is not currently used for publishing or editing datasets.  In most cases, you should never need to do this as the sync performs incremental updates.

```
## drop tables in publish database so that the db setup can run
kubectl exec deploy/datagovuk-publish -n datagovuk -- bash -c 'psql $DATABASE_URL -c "DROP OWNED BY ckan;"'

# NOTE - ignore the server restart warnings after setting up the database
kubectl exec deploy/datagovuk-publish -n datagovuk -- bin/setup

## make sure the index is setup

kubectl exec deploy/datagovuk-publish -n datagovuk -- rails search:reindex

## update orgs or datasets

kubectl exec deploy/datagovuk-publish -n datagovuk -- rails runner CKAN::V26::CKANOrgSyncWorker.new.perform
kubectl exec deploy/datagovuk-publish -n datagovuk -- rails runner CKAN::V26::PackageSyncWorker.new.perform
```

Now run `kubectl exec deploy/datagovuk-publish -n datagovuk -- bundle exec sidekiq` and see the logs.

#### Updating Zendesk password for Find

The contact form on Find uses the Zendesk API to create new tickets.  If the account password expires, it will need updating in secrets on the AWS secrets manager.

The following example is for staging.

Get the existing credentials (username and password) from AWS secrets manager under `govuk/dgu/datagovuk`:

Log into Zendesk using the username and password obtained from the previous step.  Reset the password through the UI and copy the password to the clipboard.

Update the password in AWS secrets manager.
