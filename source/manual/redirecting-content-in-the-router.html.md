---
owner_slack: "#2ndline"
title: Redirect content in the Router
section: Routing
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/infrastructure/howto/redirecting-content-in-the-router.md"
last_reviewed_on: 2016-12-16
review_in: 6 months
---

> **This page was imported from [the opsmanual on github.gds](https://github.gds/gds/opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.gds/gds/opsmanual/tree/master/infrastructure/howto/redirecting-content-in-the-router.md)


Sometimes there is a need to manually redirect existing URLs to another
internal location, usually due to content being archived or because the
slug has been changed.

There is also a regular requirement for creating short-urls (sometimes
referred to as short links, FURLs or friendly URLs) on behalf of
departments, usually for use with for campaign materials.

## Prerequisites

-   Check out the [router-data](https://github.gds/gds/router-data)
    repository

## Workflow

1)  Follow the [README](https://github.gds/gds/router-data#router-data)
    to add new redirects
2)  Commit your changes to a feature branch
3)  Send a pull request with your changes

## Deploying new redirects

Once your pull request has been accepted, use the [router data
job](https://deploy.staging.publishing.service.gov.uk/job/deploy_router_data/)
to deploy your changes to staging.

Use this opportunity on staging to also run any database migration
scripts you need to run to update slugs on your data.

Once you're happy with the changes, use the [router data
job](https://deploy.staging.publishing.service.gov.uk/job/deploy_router_data/)
to deploy your changes to production.

Note that Jenkins runs validation checks on all redirects, both when
creating a pull request and when merging the branch into master. Before
deploying, check that a [release
tag](https://github.gds/gds/router-data/releases) has been created,
otherwise your changes will not be deployed. If there is no release tag,
then the checks did not complete successfully and you should look in
Jenkins to see what failed.
