---
owner_slack: "#2ndline"
title: 'Assets: how they work'
section: Assets
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/infrastructure/architecture/assets.md"
last_reviewed_on: 2017-03-26
review_in: 6 months
---

> **This page was imported from [the opsmanual on github.gds](https://github.gds/gds/opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.gds/gds/opsmanual/tree/master/infrastructure/architecture/assets.md)


Assets are stylesheets (CSS), JavaScript (JS) and image files which
make GOV.UK look the way it does. When we use the term assets we
don't include PDFs and other files which are attached to government
publications - we call these attachments.

## How users access assets

In production, [the GOV.UK content delivery network](cdn.html)
is in front of our assets hostname.

In other environments there's no CDN and the assets hostname points
directly to our origin servers.

## Assets at origin

Assets are served by the cache machines in all environments.

The cache machines proxy requests to the application hostnames based
on the first segment of the path. For example `/government-frontend/`
is proxied to the hostname for `government-frontend` in that environment.

All other assets that have a path that don't match fall back to the
static application.
