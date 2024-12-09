---
owner_slack: "#govuk-developers"
title: Retire an application
section: Applications
layout: manual_layout
parent: "/manual.html"
---

## 1. Remove end-to-end tests

Remove any [end-to-end tests][end-to-end] specific to the application.

[end-to-end]: https://github.com/alphagov/govuk-e2e-tests

## 2. Update Release app

Mark the application as archived in the Release app.

Edit the application in the release app (you'll need the `deploy` permission to
do this), and check the `archived` checkbox. This will hide it from the UI.

## 3. Update Signon

Mark the application as "retired" in signon, if it used it.

Click on the Applications tab. Find the application that is being retired and
click the "edit" button. Tick the box that says "This application is being
retired", then save your changes.

## 4. Remove from GOV.UK Docker

Remove from the [projects directory] and any references
in [docker compose] or throughout the repo.

[projects directory]: https://github.com/alphagov/govuk-docker/tree/master/projects
[docker compose]: https://github.com/alphagov/govuk-docker/blob/master/docker-compose.yml

## 5. Update DNS

Request any public DNS entries be removed. If the app had an admin UI, it will
have had public DNS entries in the `publishing.service.gov.uk` domain.

Follow the [instructions for DNS changes][dns-changes] in order to remove
these.

[dns-changes]: /manual/dns.html#dns-for-the-publishingservicegovuk-domain

## 6. Remove from the GOV.UK architecture diagram

- Remove the application from the [GOV.UK architecture diagram](/manual/architecture.html)

## 7. Drop database

Drop the database, if present - note that this might be in RDS, but it might also exist
as a MongoDB or DocumentDB database.

## 8. Unpublish routes

Some applications are responsible for publishing certain routes. If you're
retiring a publishing application, make sure you check if any of its content
items need to be unpublished and do it via the Publishing API.

## 9. Remove from Sentry

Since the application has been retired, it shouldn't be tracked in Sentry.

## 10. Remove from Heroku

If relevant (e.g. if Heroku was used for previews).

## 11. Remove from govuk-helm-charts

Remove the app's entry in [govuk-helm-charts] from:

- /charts/app-config/values-integration.yaml
- /charts/app-config/values-staging.yaml
- /charts/app-config/values-production.yaml
- (if present) /charts/app-config/templates/signon-secrets-sync-configmap.yaml
- (if present) /charts/external-secrets/templates/<app name>

It's also wise to search that repo for other references to the app being retired.
Once the PR is merged ([Example PR][]), the app pods will automatically be removed by Argo.

[govuk-helm-charts] (https://github.com/alphagov/govuk-helm-charts/)
[Example PR] (https://github.com/alphagov/govuk-helm-charts/pull/1236)

## 12. Archive the repo

Follow the steps at [Retire a repo](/manual/retiring-a-repo.html).
