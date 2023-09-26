---
owner_slack: "#govuk-2ndline-tech"
title: Access to Licensify for Third Parties
parent: "/manual.html"
layout: manual_layout
section: 2nd line
type: learn
---

[Licensify](/manual/licensing.html) is a GOV.UK application which is usually supported by third parties.

Once staff at third parties have familiarity with the system and at least BPSS level clearance, a GOV.UK lead developer will request that they're granted [Production Deploy Access](/manual/rules-for-getting-production-access.html#production-deploy-access).

This document explains how to access the Licensify infrastructure as a third party, to perform various maintenance tasks.

## Accessing the source code

The source code is hosted on GitHub at [alphagov/licensify](https://github.com/alphagov/licensify).

## Accessing the logs

Licensify uses an Elasticsearch / Logstash / Kibana system hosted by Logit.io for its logs.

If you haven't already got access to GDS' Logit account, you'll need to [follow the instructions in the Reliability Engineering documentation to create an account in Logit](https://reliability-engineering.cloudapps.digital/logging.html#get-started-with-logit).

## Accessing the VPN

This is a prerequisite for accessing Jenkins (which is used for deployments), and for SSH-ing onto instances.

Follow [the VPN guidance for non-GDS devices ("BYOD")](https://docs.google.com/document/d/150JX1xiWdXY29ahcYUMb05Si-hEAZvtkGAKojT9Rjis/edit)
to set up the VPN. You will need to sign into your `@digital.cabinet-office.gov.uk` Google account to access this document.

## Deploying code with Jenkins

Licensify is built and deployed using Jenkins. There are four relevant Jenkins instances:

1. [CI Jenkins](https://ci.integration.publishing.service.gov.uk/job/licensify/) automatically builds releases from the main branch
2. [Integration Deploy Jenkins](https://deploy.integration.publishing.service.gov.uk/) deploys releases to integration
3. [Staging Deploy Jenkins](https://deploy.blue.staging.govuk.digital/) deploys releases to staging
4. [Production Deploy Jenkins](https://deploy.blue.production.govuk.digital/) deploys releases to production

Access to Jenkins is controlled through GitHub teams. Users in the "GOV.UK" team have full access to the CI and
Integration Jenkins instances, and read only access to the Staging and Production Jenkins instances. Users in the "
GOV.UK Production Admin" team have full access in all environments.

Usually, GOV.UK developers coordinate deployments through these Jenkins instances using
[the Release app](https://release.publishing.service.gov.uk/applications). This shows which releases are deployed to
which environments, and has useful buttons to take you to the correct Jenkins instance.

Access to the Release app is controlled through [GOV.UK Signon](https://github.com/alphagov/signon). If you don't have access, you can request it from the
GOV.UK developers.

The process for building a new release and promoting it through the three
environments is as follows:

1. When a PR/branch is merged into main, this starts a new build of main on the CI Jenkins. This produces the
   necessary artefacts to deploy Licensify. Each build is given a build number.
1. Jenkins will deploy the new build automatically to integration using the
   [integration Jenkins job](https://deploy.integration.publishing.service.gov.uk/job/Deploy_App/)
1. To complete the deployment to integration, you need to ensure that the Deploy App job has run for each of the apps:
   1. [licensify (Integration)](https://deploy.integration.publishing.service.gov.uk/job/Deploy_App/parambuild?TARGET_APPLICATION=licensify)
   1. [licensify-admin (Integration)](https://deploy.integration.publishing.service.gov.uk/job/Deploy_App/parambuild?TARGET_APPLICATION=licensify-admin)
   1. [licensify-feed (Integration)](https://deploy.integration.publishing.service.gov.uk/job/Deploy_App/parambuild?TARGET_APPLICATION=licensify-feed)
1. Manually confirm that the frontend and backend of Licensing are working on Integration before deploying to Staging
1. To deploy to staging, you must manually trigger the Deploy App Jenkins job 3 times, once for each of the Licensify
   components.
   1. [licensify (Staging)](https://deploy.blue.staging.govuk.digital/job/Deploy_App/parambuild?TARGET_APPLICATION=licensify)
   1. [licensify-admin (Staging)](https://deploy.blue.staging.govuk.digital/job/Deploy_App/parambuild?TARGET_APPLICATION=licensify-admin)
   1. [licensify-feed (Staging)](https://deploy.blue.staging.govuk.digital/job/Deploy_App/parambuild?TARGET_APPLICATION=licensify-feed)
1. Manually confirm that the frontend and backend of Licensing are working on Staging before deploying to Production
1. Follow the same procedure as for staging to deploy to production using the production Jenkins:
   1. [licensify (Production)](https://deploy.blue.production.govuk.digital/job/Deploy_App/parambuild?TARGET_APPLICATION=licensify)
   1. [licensify-admin (Production)](https://deploy.blue.production.govuk.digital/job/Deploy_App/parambuild?TARGET_APPLICATION=licensify-admin)
   1. [licensify-feed (Production)](https://deploy.blue.production.govuk.digital/job/Deploy_App/parambuild?TARGET_APPLICATION=licensify-feed)

## Accessing machines using SSH

Accessing machines using SSH in production and staging requires Production Admin Access. Third parties are usually only given Production Deploy Access, which only allows SSH in the integration environment.

The machine classes you will need are `licensing_frontend` and `licensing_backend`. You will need to be on the VPN.

Connect to the instance by running, for example, `gds govuk connect -e production ssh licensing_backend`.

The files most relevant to the Licensify applications can be found in:

* Application: `/data/vhost/licensify`
* Logs: `/var/log/licensify`
* Config: `/etc/licensify`

## Accessing MongoDB

Licensify uses a MongoDB cluster hosted by AWS (DocumentDB). The database hosts in use by a particular Licensify instance can be found in `/etc/licensing/gds-licensing-config.properties` on the `licensing_backend` machines, in the `mongo.database.*` keys.

```sh
$ grep mongo.database /etc/licensing/gds-licensing-config.properties
# …
mongo.database.hosts=licensify-documentdb-0.abcd1234wxyz.eu-west-1.docdb.amazonaws.com,licensify-documentdb-1.abcd1234wxyz.eu-west-1.docdb.amazonaws.com,licensify-documentdb-2.abcd1234wxyz.eu-west-1.docdb.amazonaws.com
mongo.database.reference.name=licensify-refdata
# …
mongo.database.auth.username=master
mongo.database.auth.password=REDACTED
# …
$ mongo licensify-documentdb-0.abcd1234wxyz.eu-west-1.docdb.amazonaws.com/licensify-refdata -u master
MongoDB shell version v3.6.14
Enter password: REDACTED

…
```
