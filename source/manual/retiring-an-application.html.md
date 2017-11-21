---
owner_slack: "#2ndline"
title: Retire an application
section: Packaging
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2017-11-16
review_in: 6 months
---

To remove an application from our infrastructure take the following
steps. Note some of the repositories are private repos that not everyone has
access to, you may need to ask your tech lead for access.

## 1. Archive database

This is only relevant if the application has a database. You can skip this
when retiring frontends.

Grab a copy of the latest production backup of the database and put a copy in
the `/data/backups/archived` directory on the `backup-1.management` machine.
This will then be included in the sync to the offsite backup machines

## 2. Remove app from puppet

Configure Puppet to remove the app from all servers. Change the app resource,
and any database resources to `ensure => absent`, remove any host and load-balancer entries, but leave the hieradata entries.

See this pull request for an example:

- <https://github.com/alphagov/govuk-puppet/pull/5496>

After this has been deployed, remove it entirely. For example:

- <https://github.com/alphagov/govuk-puppet/pull/5507>

## 3. Remove smoke tests

Remove any [smokey tests][smokey] specific to the application.

[smokey]: https://github.com/alphagov/smokey

## 4. Remove deploy scripts

Remove necessary scripts from the [alphagov-deployment][alphagov-deployment]
(private repo) and [govuk-app-deployment][govuk-app-deployment] repos.

[alphagov-deployment]: https://github.com/alphagov/alphagov-deployment
[govuk-app-deployment]: https://github.com/alphagov/govuk-app-deployment

## 5. Update Release app

Mark the application as archived in the Release app.

Edit the application in the release app (you'll need the `deploy`
permission to do this), and check the `archived` checkbox. This will
hide it from the UI.

## 6. Remove from deploy Jenkins

Remove entry from the deploy Jenkinses. This is managed [through govuk-puppet][common] in the `common.yml`.

[common]: https://github.com/alphagov/govuk-puppet/blob/master/hieradata/common.yaml

## 7. Update Signon

Mark the application as "retired" in signon, if it used it.

Click on the Applications tab. Find the application that is being
retired and click the "edit" button. Tick the box that says "This
application is being retired", then save your changes.

## 8. Update development scripts

Remove from the [development-vm directory][development] `Procfile` and `Pinfile`:

Leave a comment in the `Procfile` indicating that the port used to be
used by this app, to avoid port conflicts causing a problem running
this app locally in the future.

[development]: https://github.com/alphagov/govuk-puppet/tree/master/development-vm

## 9. Check replication script

Check the data replication scripts for anything specific to this application.

Some applications have special case details in
<https://github.com/alphagov/env-sync-and-backup/> (private repo). Any relating
to the application should be removed.

## 10. Update DNS

Request any public DNS entries be removed. If the app had an admin UI, it will
have had public DNS entries in the `publishing.service.gov.uk` domain.

Follow the [instructions for DNS changes][dns-changes] in order to remove these,
and ask the infrastructure team to approve any necessary Pull Requests.

[dns-changes]:
https://docs.publishing.service.gov.uk/manual/dns.html#making-changes-to-publishingservicegovuk

## 11. Update docs

Mark the application as `retired` in [govuk-developer-docs][dev-docs].

[dev-docs]: https://github.com/alphagov/govuk-developer-docs

## 12. Remove credentials

Remove any hieradata credential entries for the app in [govuk-secrets][]
(private repo).

[govuk-secrets]: https://github.com/alphagov/govuk-secrets

## 13. Drop database

If Puppet hasn't done it (eg for MongoDB databases), drop the database.

## 14. Remove jobs in CI

If tests were set up, go to [CI][ci] and choose "Delete Repository" for your project.

[ci]: https://ci.integration.publishing.service.gov.uk/

## 15. Remove other references

Do a [code search on GitHub][search] to find any references to the application
and update or remove them.

[search]: https://github.com/search?q=org%3Aalphagov+panopticon&type=Code

## 16. Unpublish routes

Some applications are responsible for publishing certain routes. If you're
retiring a publishing application, make sure you check if any of its content
items need to be unpublished and do it via the Publishing API.

## 17. Remove from Sentry

Since the application has been retired, it shouldn't be tracked in Sentry.

## 18. Archive the repo

Go into the repository settings in Github, and [archive the repo](https://github.com/blog/2460-archiving-repositories).
