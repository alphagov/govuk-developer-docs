---
owner_slack: "#2ndline"
title: Redirect a route
section: Routing
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2017-06-19
review_in: 6 months
---

Sometimes, there is a need to manually redirect existing URLs to another
internal location, usually due to content being archived or because the
slug has been changed.

There is also a regular requirement for creating short URLs on behalf of
departments, usually for use with for campaign materials.

## Getting information on current redirects

To find if there is already a redirect for a particular path:

    $ ssh router-backend-1.router.production
    $ govuk_app_console router-api
    > Route.where(incoming_path: '/path-to-item')

Redirect routes have the handler 'redirect'.

## Redirecting from the original publishing app

The preferred method of creating redirects is to use the publishing app that originally published the content to unpublish it and redirect it to another page using the publishing-api.

This ensures that the workflow and publishing history stays within the app wherever possible.

## Using the short URL manager

If the redirect is from a URL that is not a currently-published content item, you should first look to use the [short URL manager](https://short-url-manager.publishing.service.gov.uk) to create a redirect request. Requests are checked and approved by content designers, after which they are made live.

Redirects created in short-url-manager are published via the publishing-api.

## Using router-data

If the short URL manager does not support the redirect you are trying to create (for example, a prefix redirect), then you should use [router-data](https://github.digital.cabinet-office.gov.uk/gds/router-data). Follow the [README](https://github.digital.cabinet-office.gov.uk/gds/router-data#router-data) to create your redirects in a new branch and open a pull request.

Once your pull request has been approved and merged, use the [router data job](https://deploy.staging.publishing.service.gov.uk/job/deploy_router_data/) to deploy your changes to staging.

Use this opportunity on staging to also run any database migration scripts you need to run to update slugs on your data.

Once you're happy with the changes, use the [router data job](https://deploy.staging.publishing.service.gov.uk/job/deploy_router_data/) to deploy your changes to production.

Note that Jenkins runs validation checks on all redirects, both when creating a pull request and when merging the branch into master. Before deploying, check that a [release tag](https://github.digital.cabinet-office.gov.uk/gds/router-data/releases) has been created, otherwise your changes will not be deployed. If there is no release tag, then the checks did not complete successfully and you should look in [Jenkins](https://ci.integration.publishing.service.gov.uk) to see what failed.

## Fixing incorrect Corporate Information page redirects

There have been a few occasions where Corporate Information pages have
started redirecting the English version to a translation. Should this
happen, the redirects can be identified with:

    $ ssh router-backend-1.router.production
    $ govuk_app_console router-api
    > Route.where(incoming_path: /\/about/).each do |route|
    >   puts "#{route.id} #{route.incoming_path} -> #{route.redirect_to}" if route.handler == "redirect"
    > end

That will list the id and paths for each redirect. Redirects from the
English version to a translation, for example:

    579a109cd068b406250014e4 /government/organisations/companies-house/about/access-and-opening -> /government/organisations/companies-house/about/access-and-opening.cy

...can be deleted with

    Route.find('579a109cd068b406250014e4').destroy

For the deleted routes to take effect, you need to reload the router.

    > RouterReloader.reload
