---
title: Archive and redirect mainstream content to other pages on GOV.UK
section: Routing
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/2nd-line/archiving-and-redirecting-content.md"
---



> **This page was imported from [the opsmanual on github.gds](https://github.gds/gds/opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.gds/gds/opsmanual/tree/master/2nd-line/archiving-and-redirecting-content.md)


# Archive and redirect mainstream content to other pages on GOV.UK

Sometimes there is a need to remove existing content and redirect the
slug to another internal location. This can happen when content is
out-of-date or when it has been superseded as a result of new content
being transitioned.

This process is also known as *unpublishing* or *withdrawing*.

This is done by locating the Artefact in Publisher and clicking the
Withdraw tab, which offers the option to add a path to redirect to.

There is a different procedure in Whitehall, see whitehall-unpublishing.

> **note**
>
> This is now self-service for redirects that target GOV.UK paths, it

> was previously a 2nd Line task. Redirects outside of GOV.UK are rare
> and so should be created by 2nd Line using the following process.

# HOWTO: Archive and redirect mainstream content to non-GOV.UK URLs

## Prerequisites

-   Ensure you have Signon permissions for Publisher
-   Check out the [router-data](https://github.gds/gds/router-data)
    repository

## Workflow

1)  Follow the [Router-data
    README](https://github.gds/gds/router-data#router-data) to add new
    redirects
2)  Commit your changes to a feature branch
3)  Send a pull request with your changes
4)  Archive the content in Publisher

    > 1)  Access Publisher
    > 2)  Search for the slug being archived
    > 3)  Click the 'Withdraw' tab
    > 4)  Press the red 'Withdraw' button

5)  Deploy router-data (it's important that this is the last step!)

> **danger**
>
> The router-data deployment must come **after** archiving the content,
> otherwise the archiving step replaces the redirect with a gone
> directive in router-api and the redirect breaks. To recover from this,
> you can redeploy router-data.

## Deploying new redirects

Instructions for deploying redirects can be found in:

> -   /infrastructure/howto/redirecting-content-in-the-router

## Archiving Depts and Policy content

Instructions for archiving Departments and Policy content can be found
in the ['How to publish on GOV.UK'
manual](https://www.gov.uk/guidance/how-to-publish-on-gov-uk/unpublishing-and-archiving).
