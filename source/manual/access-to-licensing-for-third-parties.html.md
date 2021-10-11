---
owner_slack: "#govuk-2ndline"
title: Access to Licensify for Third Parties
parent: "/manual.html"
layout: manual_layout
section: 2nd line
type: learn
---

[Licensify](/manual/licensing.html) is a GOV.UK application which is usually supported by third parties.

This document explains how to access the Licensify infrastructure as a third party, to perform various maintenance tasks.

## Accessing the logs

Licensify uses an Elasticsearch / Logstash / Kibana system hosted by Logit.io for its logs.

If you haven't already got access to GDS' Logit account, you'll need to [follow the instructions in the Reliability Engineering documentation to create an account in Logit](https://reliability-engineering.cloudapps.digital/logging.html#get-started-with-logit).

## Accessing the VPN

This is a prerequisite for accessing Jenkins (which is used for deployments), and for SSH-ing onto instances.

Follow [the VPN guidance for non-GDS devices ("BYOD")](https://docs.google.com/document/d/150JX1xiWdXY29ahcYUMb05Si-hEAZvtkGAKojT9Rjis/edit)
to set up the VPN. You will need to sign into your `@digital.cabinet-office.gov.uk` Google account to access this document.

## Deploying code with Jenkins

Licensify is built and deployed using Jenkins.

The process for building a new release and promoting it through the three
environments is as follows:

1. When a PR/branch is merged into master, this starts a new build of master on
   [the CI Jenkins](https://ci.integration.publishing.service.gov.uk/job/licensify/). This
   produces the necessary artefacts to deploy Licensify. Each build is given a build number.
1. The new master build will be automatically be deployed to integration using
   the [integration Jenkins job](https://ci.integration.publishing.service.gov.uk/job/Deploy_App_Downstream/)
1. To deploy to staging, you must manually trigger the `deploy_app` Jenkins job
   3 times, once for each of the Licensify components. These can be found through the [Release](https://release.publishing.service.gov.uk/applications) app ([licensify](https://release.publishing.service.gov.uk/applications/licensify),
   [licensify-admin](https://release.publishing.service.gov.uk/applications/licensify-admin), [licensify-feed](https://release.publishing.service.gov.uk/applications/licensify-feed))
1. Follow the same procedure as for staging to deploy to production using the production links in the Release app

## Accessing machines using SSH

Follow the [instructions for connecting to a machine via SSH](/manual/howto-ssh-to-machines.html#connecting-with-plain-ssh). The machine classes you will need are `licensing_frontend` and `licensing_backend`. You will need to be on the VPN.

The files most relevant to the Licensify applications can be found in:

* Application: `/data/vhost/licensify`
* Logs: `/var/log/licensify`
* Config: `/etc/licensify`

## Accessing the source code

The source code is hosted on GitHub at [alphagov/licensify](https://github.com/alphagov/licensify).
