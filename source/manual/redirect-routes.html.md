---
title: Redirect Routes
section: Routing
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/2nd-line/redirect-routes.md"
---



> **This page was imported from [the opsmanual on github.gds](https://github.gds/gds/opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.gds/gds/opsmanual/tree/master/2nd-line/redirect-routes.md)


# Redirect Routes

To find if there is a redirect route for a particular path:

    $ ssh router-backend-1.router.production
    $ govuk_app_console router-api
    > Route.where(incoming_path: '/path-to-item')

Redirect routes have handler: 'redirect'

## Corporate Info Pages

There have been a few occasions where Corporate Information pages have
started redirecting the English version to a translation. Should this
happen the redirects can be identified with:

    $ ssh router-backend-1.router.production
    $ govuk_app_console router-api
    > Route.where(incoming_path: /\/about/).each do |route|
    >   puts "#{route.id} #{route.incoming_path} -> #{route.redirect_to}" if route.handler == "redirect"
    > end

That will list the id and paths for each redirect. Redirects from the
English version to a translation e.g.

    579a109cd068b406250014e4 /government/organisations/companies-house/about/access-and-opening -> /government/organisations/companies-house/about/access-and-opening.cy

...can be deleted with

    Route.find('579a109cd068b406250014e4').destroy

For the deleted routes to take effect, reload the router.

    > RouterReloader.reload
