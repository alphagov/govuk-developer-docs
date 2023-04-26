---
owner_slack: "#govuk-developers"
title: Retire an application
section: Applications
layout: manual_layout
parent: "/manual.html"
---

## 1. Remove app from puppet

Configure Puppet to remove the app from all servers. Change the app resource,
and any database resources to `ensure => absent`, remove any host and
load-balancer entries, but leave the hieradata entries.

See this pull request for an example:

- <https://github.com/alphagov/govuk-puppet/pull/5496>

After this has been deployed, remove it entirely. For example:

- <https://github.com/alphagov/govuk-puppet/pull/5507>

## 2. Remove smoke tests

Remove any [smokey tests][smokey] specific to the application.

[smokey]: https://github.com/alphagov/smokey

## 3. Remove deploy scripts

Remove necessary scripts from [govuk-app-deployment][govuk-app-deployment].

[govuk-app-deployment]: https://github.com/alphagov/govuk-app-deployment

## 4. Update Release app

Mark the application as archived in the Release app.

Edit the application in the release app (you'll need the `deploy` permission to
do this), and check the `archived` checkbox. This will hide it from the UI.

## 5. Remove from deploy Jenkins

Remove entry from the deploy Jenkinses. This is managed
[through govuk-puppet][common] in the `common.yml`.

[common]: https://github.com/alphagov/govuk-puppet/blob/master/hieradata_aws/common.yaml

## 6. Update Signon

Mark the application as "retired" in signon, if it used it.

Click on the Applications tab. Find the application that is being retired and
click the "edit" button. Tick the box that says "This application is being
retired", then save your changes.

## 7. Remove from GOV.UK Docker

Remove from the [projects directory][] and any references
in [docker compose][] or throughout the repo.

[projects directory]: https://github.com/alphagov/govuk-docker/tree/master/projects
[docker compose]: https://github.com/alphagov/govuk-docker/blob/master/docker-compose.yml

## 8. Update DNS

Request any public DNS entries be removed. If the app had an admin UI, it will
have had public DNS entries in the `publishing.service.gov.uk` domain.

Follow the [instructions for DNS changes][dns-changes] in order to remove
these, and ask the GOV.UK Platform Engineering team to approve any necessary Pull
Requests.

[dns-changes]: https://docs.publishing.service.gov.uk/manual/dns.html#dns-for-the-publishingservicegovuk-domain

## 9. Remove credentials

Remove any hieradata credential entries for the app in [govuk-secrets][]
(private repo).

[govuk-secrets]: https://github.com/alphagov/govuk-secrets

## 10. Drop database

If Puppet hasn't done it (eg for MongoDB databases), drop the database.

## 11. Remove jobs in CI

If tests were set up, go to [CI][ci] and choose "Delete Repository" for your
project.

[ci]: https://ci.integration.publishing.service.gov.uk/

## 12. Unpublish routes

Some applications are responsible for publishing certain routes. If you're
retiring a publishing application, make sure you check if any of its content
items need to be unpublished and do it via the Publishing API.

## 13. Remove from Sentry

Since the application has been retired, it shouldn't be tracked in Sentry.

## 14. Remove from Heroku

If relevant (e.g. if Heroku was used for previews).

## 15. Archive the repo

Follow the steps at [Retire a repo](/manual/retiring-a-repo.html).
