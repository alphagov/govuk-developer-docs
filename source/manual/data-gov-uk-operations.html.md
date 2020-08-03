---
owner_slack: "#govuk-datagovuk"
title: Operation of data.gov.uk
section: data.gov.uk
layout: manual_layout
parent: "/manual.html"
---

[find]: apps/datagovuk_find
[publish]: apps/datagovuk_publish
[ckan]: apps/ckanext-datagovuk

## Accessing data.gov.uk

### PaaS

1. Download and install [Cloud Foundry CLI](https://github.com/cloudfoundry/cli#downloads)

2. Sign into the PaaS. You can either do this via username and password, or single sign-on. After authenticating, a list of your accessible spaces will be shown, select `data-gov-uk`.

```
# To sign in using username and password
cf login -a api.cloud.service.gov.uk

# To sign in using SSO
cf login -a api.cloud.service.gov.uk --sso
```

> **Don't have an account?**
> If you don't have an account or if your account isn't recognised ask on #govuk-2ndline for an account.
>
> **Forgot your password?**
> If you forgot your password, visit [https://login.cloud.service.gov.uk/forgot_password](https://login.cloud.service.gov.uk/forgot_password)
>
> For more details, see the [PaaS documentation on signing in](https://docs.cloud.service.gov.uk/get_started.html#sign-in-to-cloud-foundry).

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

#### Updating Zendesk password for Find

The contact form on Find uses the Zendesk API to create new tickets.  If the account password expires, it will need updating in secrets on the PaaS.

The following example is for staging.

Get the existing credentials (username and password):

```
cf ssh find-data-beta-staging
echo $VCAP_SERVICES
```

Log into the Zendesk using the username and password obtained from the previous step.  Reset the password through the UI.

Update the password in secrets using [uups](http://cli.cloudfoundry.org/en-US/cf/update-user-provided-service.html):

```
cf uups find-staging-secrets -p '{"key1": "value1", "key2": "value2"}'
```

> Updating the credentials will overwrite any existing credentials, not just the one you are updating.  Therefore you must copy the entirety of the credentials from `echo $VCAP_SERVICES`, update the password then paste this into the `uups` command.  Otherwise other credentials will be lost.

Restage the application to update the environment variables:

```
cf restage find-data-beta-staging
```

Verify the new password is being used:

```
cf ssh find-data-beta-staging
echo $VCAP_SERVICES
```
