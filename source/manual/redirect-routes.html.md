---
owner_slack: "#govuk-2ndline"
title: Redirect a route
section: Routing
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-09-06
review_in: 6 months
related_applications: [short-url-manager]
---

Sometimes, there is a need to manually redirect existing URLs to another
internal location, usually due to content being archived or because the
slug has been changed.

There is also a regular requirement for creating short URLs on behalf of
departments, usually for use with for campaign materials.

## Getting information on current redirects

To find if there is already a redirect for a particular path:

```console
ssh router-backend-1.router.production
```

in Carrenza, and

```console
govukcli set-context integration
govukcli ssh router_backend
```

in AWS.

Then:

```console
govuk_app_console router-api
> Route.where(incoming_path: '/path-to-item')
```

Redirect routes have the handler `redirect`.

## Redirecting from the original publishing app

The preferred method of creating redirects is to use the publishing app that
originally published the content to unpublish it and redirect it to another
page using the Publishing API.

This ensures that the workflow and publishing history stays within the app
wherever possible.

## Using the Short URL Manager

If the redirect is from a URL that is not a currently-published content item,
you should first look to use the [Short URL Manager][short-url-manager] to
create a redirect request. Requests are checked and approved by content
designers, after which they are made live.

Redirects created in Short URL Manager are published via the Publishing API.

Specific Signon [permissions][short-url-manager-permissions] are required to
make and approve redirect requests through the Short URL Manager. Additionally,
there is a `advanced_options` permission which enables creating redirects for
pages that are already owned by other apps, creating `prefix` type redirects,
and using non-default values for the `segments_mode`.

[short-url-manager]: https://short-url-manager.publishing.service.gov.uk
[short-url-manager-permissions]: https://github.com/alphagov/short-url-manager/#permissions

## Fixing incorrect Corporate Information page redirects

There have been a few occasions where Corporate Information pages have
started redirecting the English version to a translation. Should this
happen, the redirects can be identified with:

    > Route.where(incoming_path: /\/about/).each do |route|
    >   puts "#{route.id} #{route.incoming_path} -> #{route.redirect_to}" if route.handler == "redirect"
    > end

That will list the id and paths for each redirect. Redirects from the
English version to a translation, for example:

    579a109cd068b406250014e4 /government/organisations/companies-house/about/access-and-opening -> /government/organisations/companies-house/about/access-and-opening.cy

...can be deleted with

    > Route.find('579a109cd068b406250014e4').destroy

For the deleted routes to take effect, you need to reload the router.

    > RouterReloader.reload

## Redirects from campaign sites

The campaigns platform is a WordPress site managed by dxw. Redirects from a
`*.campaign.gov.uk` site require a support ticket. Currently, Mark McLeod or
Kelvin Gan can raise a ticket.
