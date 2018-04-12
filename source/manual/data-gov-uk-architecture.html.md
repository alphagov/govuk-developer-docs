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

Most of the service is hosted on [GOV.UK PaaS][paas], which divides components in applications (eg Rails apps) and services (databases, messaging services, etc). All applications and services are controlled through cloudfoundry, as used by [GOV.UK PaaS][paas]. Some familiarity with that documentation will be useful to read this manual.

## Applications

> These are Cloudfoundry applications, show in blue above.

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

> These are Cloudfoundry services, shown in red above.

| Name | Description | Apps bound |
| ---- | ----------- | ---------- |
| beta-production-elasticsearch | The elasticsearch server | publish-data-beta-worker, publish-data-beta, find-data-beta |
| publish-beta-production-pg | The pg database for Publish | publish-data-beta-worker, publish-data-beta |
| publish-production-secrets | User-provided service. Provides env variables to Publish | publish-data-beta-worker, publish-data-beta |
| find-production-secrets | User-provided service. Provides secrets as env variables to Find | find-data-beta |
| beta-dgu-route | cdn-route. Routes beta.data.gov.uk to find-data-beta | |
| logit-ssl-drain | TBC | All apps |

### Postgres

The database that [Publish Data][publish] uses. Publish Data gets the details and credentials through the `VCAP_SERVICES` environment variable.

### Elasticsearch

The search index that [Find Data][find] uses to search datasets. It is populated through the `search:reindex` rake task on [Publish Data][publish] (see below) and when publishers make changes when using Publish Data.
Similarly the `VCAP_SERVICES` environment variable, made available to applications that connect to it, contains the credentials to connect to it.

### beta.data.gov.uk proxy (aka beta-dgu-route)

This is a “cdn-route” [PaaS](paas) service that proxies the `beta.data.gov.uk host` name to the [Find Data][find] application.

### “Secrets” services

There are two “user-provided” services (`find-production-secrets` and `publish-production-secrets`) that are used by [Publish Data][publish] and [Find Data][find] to get access to environment variables, some of which contain secrets such as API keys. Those variables are found in the `VCAP_SERVICES` environment variable for [Publish Data][publish] and [Find Data][find]. The value of those variables is set and encrypted in the [datagovuk_infrastructure][infrastructure] repository, and cloudfoundry is used to deploy the service when they’re modified.

The main environment variables are:

| Variable | Apps | Description |
| -------- | ---- | ----------- |
| rails_env | Publish and Find | Rails environment (production or staging) |
| devise_secret_key | Publish and Find | Rails standard var |
| secret_key_base | Publish and Find | Rails standard var |
| es_host | Publish and Find | If using a non-PaaS elasticsearch server, use this URL |
| es_index | Publish and Find | To override the default index name: `datasets-[rails env]` |
| sentry_dsn | Publish and Find | Key for sentry monitoring |
| ga_test_tracking_id | Find | Google analytics id used when accessing Find via private testing URL (...cloudapps...) |
| ga_tracking_id | Find | Google analytics id used when accessing find via private beta URL (beta.data.gov.uk) |
| private_beta_user_salt | Find | Arbitrary value to generate the preset http passwords for Find |
| redis_ip | Publish | The IP of the Redis server |
| redis_password | Publish | The password for the Redis server |
| redis_port | Publish | The port of the Redis server |

### Redis

Redis is not currently available on [PaaS][paas] for production services, so we run two redis instances on AWS that we set up by hand. Details can be found on data.gov.uk's AWS console.

To navigate to the console:

* Login to AWS.
* Select ‘Ireland’ from the nav bar drop down menu - top right of page.
* Select EC2 from the services menu, to reach the EC2 Dashboard

Look for instances called `redis-staging` and `redis-production`.

## Staging environment

All applications and services above (with the exception of `beta-dgu-route`) have both staging and production environments. For instance, [Find Data][find] is `find-data-beta` and `find-data-beta-staging`.

## Monitoring

The [Publish Data][publish] and [Find Data][find] applications are monitored by Pingdom.

We use Sentry to monitor errors, the URLs for which can be found on the app pages in this documentation. Both [Publish Data][publish] and [Find Data][find] look for an environment variable called `SENTRY_DSN` (provided by the [Secrets services](#secrets-services)) which contains the URL which messages should be sent on sentry.io. Members of the data.gov.uk group on Sentry will receive an email in case of errors.

## Analytics

We use Google Analytics, with standard settings and some specific events on datafile download.

## Logging

We use Logit and take advantage of [PaaS’s][paas] support for it. We have a [`logit-ssl-drain`](#services) cloudfoundry service that is bound to all apps.

The logit URL is `syslog-tls://225374f1-0bbc-4aa9-8ba0-b87c33995884-ls.logit.io:19753` and maps to the “DGU Beta” stack on the GDS Logit account.
