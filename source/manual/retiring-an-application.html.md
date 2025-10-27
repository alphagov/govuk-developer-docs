---
owner_slack: "#govuk-developers"
title: Retire an application
section: Applications
layout: manual_layout
parent: "/manual.html"
---

## 0. Unpublish routes

Some applications are responsible for publishing certain routes. If you're retiring a publishing application, make sure you check if any of its content items need to be unpublished and do it via the Publishing API.

This step is marked as step 0 as really it is a pre-requisite step you ought to do _before_ retiring the application.

## 1. Raise PRs to remove the app from dependent places

### Remove end-to-end tests

Remove any [end-to-end tests][end-to-end] specific to the application.

[end-to-end]: https://github.com/alphagov/govuk-e2e-tests

### Remove from GOV.UK Docker

Remove from the [projects directory] and any references
in [docker compose] or throughout the repo.

[projects directory]: https://github.com/alphagov/govuk-docker/tree/master/projects
[docker compose]: https://github.com/alphagov/govuk-docker/blob/master/docker-compose.yml

### Remove public DNS entries

Request any public DNS entries be removed. If the app had an admin UI, it will
have had public DNS entries in the `publishing.service.gov.uk` domain (likely one per
environment, all of which need removing).

Follow the [instructions for DNS changes][dns-changes] in order to remove
these.

[dns-changes]: /manual/dns.html#dns-for-the-publishingservicegovuk-domain

### Remove from govuk-helm-charts

Remove the app's entry in [govuk-helm-charts](https://github.com/alphagov/govuk-helm-charts/) from:

- /charts/app-config/values-integration.yaml
- /charts/app-config/values-staging.yaml
- /charts/app-config/values-production.yaml
- (if present) /charts/app-config/templates/signon-secrets-sync-configmap.yaml
- (if present) /charts/external-secrets/templates/<app name>

It's also wise to search that repo for other references to the app being retired.
Once the PR is merged ([Example PR](https://github.com/alphagov/govuk-helm-charts/pull/1236)), the app pods will automatically be removed by Argo.

### Remove from govuk-dependabot-merger (if applicable)

[Example](https://github.com/alphagov/govuk-dependabot-merger/pull/105).

### Remove from Publishing API content schema tests (if applicable)

[Example](https://github.com/alphagov/publishing-api/pull/3387)

### Remove from govuk-infrastructure

Remove govuk-infrastructure's references to the app.

This includes Terraform-managed resources as well as the Sentry integration. See [example](https://github.com/alphagov/govuk-infrastructure/pull/2264).

Note that this will automatically destroy the corresponding resources in AWS (e.g. database) on merge.

This needs to be done in several stages. You can raise all of the PRs in advance, but shouldn't merge / apply them until [step 2](#2-soft-mark-the-application-as-retired).

1. Archive the repo by following the steps at [Retire a repo](/manual/retiring-a-repo.html).
   It will result in two PRs to govuk-infrastructure ([example 1](https://github.com/alphagov/govuk-infrastructure/pull/3064), [example 2](https://github.com/alphagov/govuk-infrastructure/pull/3065)), which have to be merged and applied in Terraform in turn.
1. Retire any RDS instances for the app, which again will result in two PRs to govuk-infrastructure.
   The first PR should be to add `deletion_protection = false` to the relevant declarations in `tfc-configuration/variables-{env}.tf` for every environment - see [example](https://github.com/alphagov/govuk-infrastructure/pull/3066).
   This PR will need merging and applying first, before doing the same for the next PR.
   The second PR will be to remove all remaining references to your app - see [example](https://github.com/alphagov/govuk-infrastructure/pull/3062).
   This time, the act of removing the Terraform variables that define the Databases, and running the apply again, should cause the Databases to produce a final snapshot and then be destroyed.

## 2. Soft-mark the application as retired

### Remove from Heroku

If relevant (e.g. if Heroku was used for previews).

### Update Signon

Mark the application as "retired" in signon, if it used it:

- Click on the Applications tab.
- Find the application that is being retired and click the "edit" button.
- Tick the box that says "This application is retired", then save your changes.

Do this in both Integration and Production, since Signon is one of the few places where Production doesn't automatically overwrite Integration.
(Production does overwrite Staging, however, so that will have the same changes applied automatically.)

### Remove from the GOV.UK architecture diagram

Remove the application from the [GOV.UK architecture diagram](/manual/architecture.html).

## 3. Apply the destructive actions

### Merge the PRs raised earlier

See step 1.

### Delete the app in the Release app

- Edit the application in the release app (you'll need the `deploy` permission to do this)
- Press the 'Delete application' button.

### Retire a Document DB from the Shared DocumentDB Instance

See the [DocumentDB and MongoDB](/manual/documentdb-mongodb.html) Documentation for instructions on how to do this.

### Manually delete any AWS resources not managed by Terraform

If your app is particularly unique/legacy and uses any resources that are not managed by Terraform, those resources will need manually deleting in AWS.
