---
owner_slack: "#2ndline"
title: Retire an application
section: Packaging
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2017-05-03
review_in: 6 months
---

To remove an application from our infrastructure take the following
steps:

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

Remove necessary scripts from the [alphagov-deployment][alphagov-deployment] and
[govuk-app-deployment][govuk-app-deployment] repos.

[alphagov-deployment]: https://github.digital.cabinet-office.gov.uk/gds/alphagov-deployment
[govuk-app-deployment]: https://github.com/alphagov/govuk-app-deployment

## 5. Update Release app

Mark the application as archived in the Release app.

Edit the application in the release app (you'll need the `deploy`
permission to do this), and check the `archived` checkbox. This will
hide it from the UI.

## 6. Remove from deploy Jenkins

Remove entry from the deploy Jenkinses. This is managed [through govuk-puppet][common] in the `common.yml`.

[common]: https://github.com/alphagov/govuk-puppet/blob/master/hieradata/common.yaml

## 7. Move repo

Move the repository to the attic. Go into the repository settings in Github, and
change the owner to [gds-attic][gds-attic]. Once moved, delete any webooks and
services that exist for it.

[gds-attic]: https://github.com/gds-attic

## 8. Remove from Errbit

Delete the application from Errbit. On all 3 errbit instances, delete the
application (you'll need the `admin` permission to do this). The delete button
can be found in the application edit screen.

**Handling timeouts from the UI:**

If the app has received lots of errors, the request to delete it can
timeout. If this happens, it will need to be deleted manually from the
rails console as follows:

- ssh to `exception-handler-1.backend.{integration,staging,production}`
- start a rails console `govuk_app_console errbit`

- Find and destroy the application:

```ruby
a = App.where(:name => "Foo API").first
a.destroy # This could take a long time to return
```

## 9. Update Signon

Mark the application as "retired" in signon, if it used it.

Click on the Applications tab. Find the application that is being
retired and click the "edit" button. Tick the box that says "This
application is being retired", then save your changes.

## 10. Update development scripts

Remove from the [development-vm directory][development] `Procfile` and `Pinfile`:

Leave a comment in the `Procfile` indicating that the port used to be
used by this app (eg <https://github.digital.cabinet-office.gov.uk/gds/development/pull/149>)

[development]: https://github.com/alphagov/govuk-puppet/tree/master/development-vm

## 11. Check replication script

Check the data replication scripts for anything specific to this application.

Some applications have special case details in
<https://github.digital.cabinet-office.gov.uk/gds/env-sync-and-backup/>. Any relating to the
application should be removed.

## 12. Update DNS

Request any public DNS entries be removed. If the app had an admin UI, it will
have had public DNS entries in the `publishing.service.gov.uk` domain. Request
that the infrastructure team remove these, or, if appropriate, transition them.

## 13. Update docs

Mark the application as `retired` in [govuk-developer-docs][dev-docs].

[dev-docs]: https://github.com/alphagov/govuk-developer-docs

## 14. Remove credentials

Remove any hieradata credential entries for the app:

For example: <https://github.digital.cabinet-office.gov.uk/gds/deployment/pull/408>

## 15. Drop database

If Puppet hasn't done it (eg for Mongo databases), drop the database.

## 16. Remove jobs in CI

If tests were set up, go to [CI][ci] and choose "Delete Repository" for your project.

[ci]: https://ci.integration.publishing.service.gov.uk/

## 17. Remove other references

Do a [code search on GitHub][search] to find any references to the application
and update or remove them.

[search]: https://github.com/search?q=org%3Aalphagov+panopticon&type=Code
