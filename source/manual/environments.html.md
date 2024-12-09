---
owner_slack: "#govuk-platform-engineering"
title: GOV.UK's environments (integration, staging, production)
section: Infrastructure
type: learn
layout: manual_layout
parent: "/manual.html"
---

GOV.UK has several environments with different purposes. By _environment_, we
mean:

- a self-contained, running instance of all the software components of GOV.UK
- the AWS account and VPC network which hosts that instance of GOV.UK
- the configuration (settings) for that instance of GOV.UK

This document describes each GOV.UK environment and its uses.

There are three GOV.UK environments hosted in AWS: integration, staging and
production. Individual developers also run GOV.UK locally on laptops or
workstations.

The [Release dashboard](https://release.publishing.service.gov.uk/) shows which
application versions have been rolled out in each environment.

## Local development environments

Software developers working on GOV.UK generally either use [govuk-docker] or
run the applications directly on their machines alongside copies of the
necessary databases.

In future, we hope to improve [govuk-helm-charts] to be able to run the whole
GOV.UK stack locally. This should make it easier for new contributors to get
started on GOV.UK, encourage open-source engagement and reduce friction for
developers.

## Integration

GOV.UK product teams use the _integration test_ environment for:

- manual software testing, where automated test coverage is not yet sufficient
  and/or the [govuk-docker] local development environment is insufficient
- automated end-to-end/system tests ([e2e-test]) which determine whether a
  software release is automatically promoted to the staging environment

Currently, the integration environment is also used by content editors at GDS
and in other departments as a workaround to preview certain types of content
changes. This usage needs to be replaced by proper preview functionality in the
Publisher applications so that all end-user usage happens in production.

There are no guarantees about availability of the integration environment and
support is on a best-effort basis only.

## Staging

GOV.UK Platform Engineering team uses the staging environment for:

- verifying changes to cluster configuration or cloud infrastructure, such as
  Kubernetes cluster upgrades

GOV.UK product teams occasionally use the staging environment for:

- testing of major changes which need to run on a full copy of production data
- testing that involves measuring system performance or resource usage, for
  example load testing and stress testing

The staging environment is currently also a gate for automatic deployment of
new releases to production.

Front ends in the staging environment are reachable from GDS network addresses
only. This is to prevent content in staging being mistakenly linked to. If you
are working outside a GDS office, you will need to connect via the [VPN] in
order to view the website on the staging environment. Apps that require you to
log in via GOV.UK Signon do not require the VPN.

## Production

The production environment runs the versions of the applications which serve content to the general public.

[govuk-docker]: https://github.com/alphagov/govuk-docker/
[govuk-helm-charts]: https://github.com/alphagov/govuk-helm-charts/
[e2e-test]: /repos/govuk-e2e-tests
[VPN]: https://docs.google.com/document/d/1O1LmLByDLlKU4F1-3chwS8qddd2WjYQgMaaEgTfK5To/preview
