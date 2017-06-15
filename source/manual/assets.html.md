---
owner_slack: "#2ndline"
title: 'Assets: how they work'
section: Assets
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/infrastructure/architecture/assets.md"
last_reviewed_on: 2017-06-13
review_in: 6 months
---

There are two types of asset files.

**Static assets** are stylesheets (CSS), JavaScript (JS) and image files which
make GOV.UK look the way it does.

**Uploaded assets** - also called attachments - are files like PDFs, CSVs and
images which are uploaded via the publishing apps and attached to documents.

## Static assets

### How users access assets

In production, [the GOV.UK content delivery network](cdn.html)
is in front of our assets hostname.

In other environments there's no CDN and the assets hostname points
directly to our origin servers.

### Assets at origin

Assets are served by the cache machines in all environments.

The cache machines proxy requests to the application hostnames based
on the first segment of the path. For example `/government-frontend/`
is proxied to the hostname for `government-frontend` in that environment.

All other assets that have a path that don't match fall back to the
static application.

## Uploaded assets

There are currently two systems for uploading, managing and serving
user-supplied assets on GOV.UK.

Asset Manager is an API that is called internally by Publisher, Specialist
Publisher, Manuals Publisher and Travel Advice Publisher to manage their
uploads. It serves the uploaded assets on assets.publishing.service.gov.uk/media

Whitehall is a standalone publishing app that manages its own uploaded assets.
It also serves those assets, via both
assets.publishing.service.gov.uk/government/uploads and
www.gov.uk/government/uploads, even for content that has been migrated to the
publishing platform.

### How uploaded assets are stored and served

Both Whitehall and Asset Manager store the asset files on an NFS share. This is
hosted on the backend and whitehall-backend machines, and asset requests
therefore go via the cache, frontend-lb, (whitehall-)frontend, backend-lb and
backend machines.

It should be noted that both applications do actually serve the asset
requests, rather than letting nginx serve directly from the share. This is to
enable the following features:

* Assets are not served until they have been virus scanned; a placeholder image
  or page is shown for assets that are not finished scanning.
* Assets can be access-limited so that only authorised users can see them. This
  is only done by Whitehall.
* Asset files can be replaced, and a request to the original path redirects to
  the replacement. Currently only Whitehall and Specialist Publisher support
  this.
