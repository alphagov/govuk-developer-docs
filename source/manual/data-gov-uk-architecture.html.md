---
owner_slack: "#datagovuk-tech"
title: Architectural overview of data.gov.uk
section: data.gov.uk
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-04-30
review_in: 3 months
---
![](/manual/images/data-gov-uk-architecture.jpg)
[paas]: https://docs.cloud.service.gov.uk/#technical-documentation-for-gov-uk-paas
[publish]: apps/datagovuk_publish
[find]: apps/datagovuk_find
[infrastructure]: https://github.com/alphagov/datagovuk_infrastructure
[signon]: manual/manage-sign-on-accounts

## Environments

We have three environments: integration, staging ("test") and production. See the [CI docs](manual/data-gov-uk-continuous-integration-and-deployment) for more information about each environment.

## Applications

Most of the service is hosted on [GOV.UK PaaS][paas], which divides components into applications (eg Rails apps) and services (databases, messaging services, etc). All applications and services are controlled through cloudfoundry, as used by [GOV.UK PaaS][paas]. Some familiarity with that documentation will be useful to read this manual.

### Legacy DGU

The old platform which Publish and Find are going to replace. It has an API that is accessed to import data on the new platform.

### Find Data

The new public-facing service that end-users access to find data. It’s a Rails app, hosted on [GOV.UK PaaS][paas]. You can find out more about this app [here][find].

### Publish Data

The new publisher-facing services that publishers access to add or edit datasets. It's a Rails app, hosted on [GOV.UK PaaS][paas]. You can find out more about this app [here][publish].

### Publish Data Worker

This is a rails worker used to fetch data from legacy. It uses Redis to queue import tasks. It will be removed once legacy is no longer used. The source code is in the [Publish Data app][publish].

The way data is normally imported from legacy is:

* Every hour, pingdom GETs https://publish-data-beta.cloudapps.digital/api/sync-beta
* This runs the `sync:beta` Rails task that queries the Legacy API for new and updated datasets
* Changes are reflected in the Publish database and pushed to elasticsearch

To run the task manually you can do the following on [staging](#staging-environment) (or replace the app name with the live app):

    cf run-task publish-data-beta-staging-worker "bin/rake sync:beta" --name sync
    cf logs publish-data-beta-staging-worker

## Services

### GOV.UK Signon

We use [GOV.UK Signon][signon] for user authentication in [Publish Data][publish], with the app in each environment linked to the corresponding instance of [GOV.UK Signon][signon].

The organisations in the [Publish Data][publish] database have a `govuk_content_id` field to map them to [GOV.UK Signon][signon] organisations.

If no organisation can be found for a user (e.g. if no mapping exists), the app will fail.

### Postgres

The database that [Publish Data][publish] uses. Publish Data gets the details and credentials through the `VCAP_SERVICES` environment variable.

### Elasticsearch

The search index that [Find Data][find] uses to search datasets. It is populated through the `search:reindex` rake task on [Publish Data][publish] (see below) and when publishers make changes when using Publish Data.
The `VCAP_SERVICES` environment variable contains the credentials to connect to it.

### beta.data.gov.uk proxy (aka beta-dgu-route)

This is a “cdn-route” [PaaS](paas) service that proxies the `beta.data.gov.uk host` name to the [Find Data][find] application.

### Secrets

There are two “user-provided” services (`find-production-secrets` and `publish-production-secrets`) that are used by [Publish Data][publish] and [Find Data][find] to get access to environment variables, some of which contain secrets such as API keys. Those variables are found in the `VCAP_SERVICES` environment variable for [Publish Data][publish] and [Find Data][find]. The value of those variables is set and encrypted in the [datagovuk_infrastructure][infrastructure] repository, and cloudfoundry is used to deploy the service when they’re modified.

The environment variables for each app can be accessed using the command `cf env <app-name>` via the cloudfoundry CLI.

### Redis

Redis is not currently available on [PaaS][paas] for production services, so we run two redis instances on AWS that we set up by hand. Details can be found on data.gov.uk's AWS console.

To navigate to the console:

* Login to AWS.
* Select ‘Ireland’ from the nav bar drop down menu - top right of page.
* Select EC2 from the services menu, to reach the EC2 Dashboard

Look for instances called `redis-staging` and `redis-production`.

## Monitoring

The [Publish Data][publish] and [Find Data][find] applications are monitored by Pingdom.

You can monitor Sidekiq jobs for [Publish Data][publish] by going to `/sidekiq` on the website.

We use Sentry to monitor errors, the URLs for which can be found on the app pages in this documentation. Both [Publish Data][publish] and [Find Data][find] look for an environment variable called `SENTRY_DSN` (provided by the [Secrets services](#secrets-services)) which contains the URL which messages should be sent on sentry.io. Members of the data.gov.uk group on Sentry will receive an email in case of errors.

## Analytics

We use Google Analytics, with standard settings and some specific events on datafile download.

## Logging

We use Logit and take advantage of [PaaS’s][paas] support for it. We have a [`logit-ssl-drain`](#services) cloudfoundry service that is bound to all apps.

The logit URL is `syslog-tls://225374f1-0bbc-4aa9-8ba0-b87c33995884-ls.logit.io:19753` and maps to the “DGU Beta” stack on the GDS Logit account.
