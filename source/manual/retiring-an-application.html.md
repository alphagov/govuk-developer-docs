---
title: Retire an app from the GOV.UK Infrastructure
section: Packaging
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/infrastructure/howto/retiring-an-application.md"
---



> **This page was imported from [the opsmanual on github.gds](https://github.gds/gds/opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.gds/gds/opsmanual/tree/master/infrastructure/howto/retiring-an-application.md)


# Retire an app from the GOV.UK Infrastructure

To remove an application from our infrastructure take the following
steps:

1. Put a database backup in the archive:

Grab a copy of the latest production backup of the database and put a copy in
the `/data/backups/archived` directory on the `backup-1.management` machine.
This will then be included in the sync to the offsite backup machines

2. Configure puppet to remove the app from all servers:

Change the app resource, and any database resources to `ensure => absent`,
remove any host and load-balancer entries, but leave the hieradata entries.
See [this pull request for an example][example-puppet].

[example-puppet]: https://github.com/alphagov/govuk-puppet/pull/5496

3. Remove any [smokey tests][smokey] specific to the application.

[smokey]: https://github.com/alphagov/smokey

4. Remove deploy scripts from the [alphagov-deployment][alphagov-deployment] and
[govuk-app-deployment][govuk-app-deployment] repos.

[alphagov-deployment]: https://github.gds/gds/alphagov-deployment
[govuk-app-deployment]: https://github.com/alphagov/govuk-app-deployment

5. Mark the application as archived in the Release app:

Edit the application in the release app (you'll need the `deploy`
permission to do this), and check the `archived` checkbox. This will
hide it from the UI.

6. Remove entry from the deploy Jenkinses:

This is managed [through GOV.UK Puppet][common] in the `common.yml`.

[common]: https://github.com/alphagov/govuk-puppet/blob/master/hieradata/common.yaml

7. Move the repository to the attic:

Go into the repository settings in Github, and change the owner to
[gds-attic][gds-attic]. Once moved, delete any webooks and services that exist
for it.

[gds-attic]: https://github.com/gds-attic

9. Delete the application from Errbit:

On all 3 errbit instances, delete the application (you'll need the `admin`
permission to do this). The delete button can be found in the application
edit screen.

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

10. Mark the application as "retired" in signon, if it used it:

Click on the Applications tab. Find the application that is being
retired and click the "edit" button. Tick the box that says "This
application is being retired", then save your changes.

11. Remove from the [development repo][development] `Procfile` and `Pinfile`:

Leave a comment in the `Procfile` indicating that the port used to be
used by this app (eg <https://github.gds/gds/development/pull/149>)

[development]: https://github.gds/gds/development

12. Check the data replication scripts for anything specific to this application:

Some applications have special case details in
<https://github.gds/gds/env-sync-and-backup/>. Any relating to the
application should be removed.

13. Request any public DNS entries be removed:

If the app had an admin UI, it will have had public DNS entries in the
`publishing.service.gov.uk` domain. Request that the infrastructure
team remove these, or, if appropriate, transition them.

14. Document the retirement in the developer docs:

Mark the application as `retired` in [govuk-developer-docs][dev-docs].

[dev-docs]: https://github.com/alphagov/govuk-developer-docs

15. Remove any references in other applications:

Do a [code search on GitHub][search] to find any references to the application
and update or remove them.

[search]: https://github.com/search?q=org%3Aalphagov+panopticon&type=Code

Once puppet has removed the app from production, cleanup the remaining
bits:

1. Remove all remaining puppet code relating to the app:

For example: https://github.com/alphagov/govuk-puppet/pull/5507

2. Remove any hieradata credential entries for the app:

For example: https://github.gds/gds/deployment/pull/408

3. Drop the database for the app if puppet hasn't done it (eg for Mongo databases).
