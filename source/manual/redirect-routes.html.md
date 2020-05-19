---
owner_slack: "#govuk-developers"
title: Redirect a route
section: Routing
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-09-02
review_in: 6 months
related_applications: [short-url-manager]
---

Sometimes, there is a need to manually redirect existing URLs to another
internal location, usually due to content being archived or because the
slug has been changed.

There is also a regular requirement for creating short URLs on behalf of
departments, usually for use with for campaign materials.

## Getting information on current redirects

To find if there is already a redirect for a particular path, open a router-api
console:

```console
$ gds govuk connect app-console -e production router_backend/router-api
```

Then search for the incoming path you are interested in:

```console
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

## Redirects for HMRC manuals

There are rake tasks for redirecting HMRC manuals and HMRC manual sections, which can be [found in the hmrc-manuals-api repo](https://github.com/alphagov/hmrc-manuals-api/tree/master/lib/tasks). These can be run via the `Run rake task` jenkins job.

[See example of redirecting a HMRC manual section to another section](https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=hmrc-manuals-api&MACHINE_CLASS=backend&RAKE_TASK=redirect_hmrc_section[original-parent-manual-slug,original-section-slug,new-parent-manual-slug,new-section-slug])

## Redirects from campaign sites

The campaigns platform is a WordPress site managed by dxw. Redirects from a
`*.campaign.gov.uk` site require a support ticket. Currently, James Whitmarsh or
Kelvin Gan can raise a ticket.
