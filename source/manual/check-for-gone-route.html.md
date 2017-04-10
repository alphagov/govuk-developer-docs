---
title: Checking for a `gone` route
section: Routing
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/2nd-line/check-for-gone-route.md"
---



> **This page was imported from [the opsmanual on github.gds](https://github.gds/gds/opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.gds/gds/opsmanual/tree/master/2nd-line/check-for-gone-route.md)


# Checking for a `gone` route

When a Whitehall document fails to appear on the frontend, and the user
is shown a 'Gone' page, follow these instructions:

## Check the router API for a `gone` route

    $ ssh router-backend-1.router.production
    $ cd /var/apps/router-api
    $ sudo -u deploy govuk_setenv router-api bundle exec rails c
    > r = Route.where(incoming_path: '/path-to-item').first
    > puts r.handler

if the result is `gone` and you want to unblock the URL then you need to
remove the route (this works because `/government` is a `prefix` route
to Whitehall):

    > r.destroy
    > RouterReloader.reload
