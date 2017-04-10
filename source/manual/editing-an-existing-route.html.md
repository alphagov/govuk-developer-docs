---
title: Editing an existing route in the Router
section: howto
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/2nd-line/editing-an-existing-route.md"
---



> **This page was imported from [the opsmanual on github.gds](https://github.gds/gds/opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.gds/gds/opsmanual/tree/master/2nd-line/editing-an-existing-route.md)


# Editing an existing route in the Router

If there's a need to edit a Route in the database, follow these
instructions:

    $ ssh router-backend-1.router.production
    $ cd /var/apps/router-api
    $ sudo -u deploy govuk_setenv router-api bundle exec rails c
    > r = Route.where(incoming_path: '/path-to-item').first

manipulate the `r` object directly (see the
[documentation](https://github.com/alphagov/router#data-structure) for
available options), eg:

    > r.route_type = 'exact'
    > r.save!

once you've edited the Route appropriately and saved it, you need to
reload the router:

    > RouterReloader.reload

