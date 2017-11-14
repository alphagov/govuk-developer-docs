---
owner_slack: "#2ndline"
title: Edit an existing route in the Router
section: Routing
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2017-08-15
review_in: 6 months
---

If there's a need to edit a Route in the database, follow these
instructions:

    $ ssh router-backend-1.router.production
    $ govuk_app_console router-api
    > r = Route.where(incoming_path: '/path-to-item').first

manipulate the `r` object directly (see the
[documentation](https://github.com/alphagov/router#data-structure) for
available options), eg:

    > r.route_type = 'exact'
    > r.save!

once you've edited the Route appropriately and saved it, you need to
reload the router:

    > RouterReloader.reload
