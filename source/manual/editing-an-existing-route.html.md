---
owner_slack: "#govuk-developers"
title: Edit an existing route in the Router
section: Routing
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2020-05-18
review_in: 6 months
---

The Router API database is populated from the Publishing API, and also
the deprecated router-data tool. Changes to routes should be made in
the Publishing API as this is the authoritative source of the data,
however, it can be helpful to make short term changes to routes
manually, when going through the Publishing API would take too long,
for example during an incident.

If there's a need to edit a route in the database:

1. Connect to a router-backend machine

```console
gds govuk connect -e production ssh aws/router_backend
```

2. Connect to router-api and get the route

```console
govuk_app_console router-api
> r = Route.where(incoming_path: '/path-to-item').first
```

3. Manipulate the `r` object directly (see the
[documentation](https://github.com/alphagov/router#data-structure) for
available options), for example:

```console
> r.route_type = 'exact'
> r.save!
```

4. Once you've edited the route appropriately and saved it, reload the router

```console
> RouterReloader.reload
```
