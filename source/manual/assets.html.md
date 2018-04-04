---
owner_slack: "#asset-management"
title: 'Assets: how they work'
section: Assets
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-04-04
review_in: 1 week
related_applications: [asset-manager, whitehall]
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
Publisher, Manuals Publisher, Travel Advice Publisher and Whitehall to manage their
uploads. It serves the uploaded assets on assets.publishing.service.gov.uk/media

Whitehall is a standalone publishing app that manages a type of asset called "attachments". It serves attachments, via both
`assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data` and
`www.gov.uk/government/uploads/government/uploads/system/uploads/attachment_data`, even for content that has been migrated to the
publishing platform.

Note: Other types of assets that are managed through the Whitehall admin application, such as organisation logos, are sent to and served from Asset Manager.

### How uploaded assets are stored and served

Asset Manager stores its asset files in an S3 bucket (i.e.
`govuk-assets-production` in production) and instructs nginx to proxy requests
to them.

Whitehall stores attachment files on an NFS share. This NFS share is mounted on
the backend and whitehall-backend machines, and requests for attachments therefore go via
the cache, frontend-lb, (whitehall-)frontend, backend-lb and backend machines.

It should be noted that both applications do actually serve the asset
requests, rather than letting nginx serve directly from the share. This is to
enable the following features:

* Assets are not served until they have been virus scanned; a placeholder image
  or page is shown for assets that are not finished scanning.
* Assets can be access-limited so that only authorised users can see them.
* Asset files can be replaced, and a request to the original path redirects to
  the replacement. Currently only Whitehall and Specialist Publisher support
  this.
