---
owner_slack: "#2ndline"
title: Edit an existing route in the Router
section: Routing
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-04-12
review_in: 6 months
---

The Router API database is populated from the Publishing API, and also
the deprecated router-data tool. Changes to routes should be made in
the Publishing API as this is the authoritative source of the data,
however, it can be helpful to make short term changes to routes
manually, when going through the Publishing API would take too long,
for example during an incident.

If there's a need to edit a route in the database, follow these
instructions:

    $ ssh router-backend-1.router.production
    $ govuk_app_console router-api
    > r = Route.where(incoming_path: '/path-to-item').first

Manipulate the `r` object directly (see the
[documentation](https://github.com/alphagov/router#data-structure) for
available options), eg:

    > r.route_type = 'exact'
    > r.save!

Once you've edited the Route appropriately and saved it, you need to
reload the router:

    > RouterReloader.reload
