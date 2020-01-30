---
owner_slack: "#govuk-platform-health"
title: 'Assets: how they work'
section: Assets
type: learn
layout: manual_layout
parent: "/manual.html"
related_applications: [asset-manager]
---

There are two types of asset files.

**Static assets** are stylesheets (CSS), JavaScript (JS) and image files which
make GOV.UK look the way it does.

**Uploaded assets** - also called attachments - are files like PDFs, CSVs and
images which are uploaded via the publishing apps and attached to documents.

## Static assets

### How users access assets

[The GOV.UK content delivery network](cdn.html) is in front of our assets
hostname (`assets.publishing.service.gov.uk` and equivalents in other
environments). The CDN fetches anything not in its cache from `assets-origin`.

### Assets at origin

Assets are served by the cache machines in all environments.

The cache machines proxy requests to the application hostnames based on the
first segment of the path. For example `/government-frontend/` is proxied to
the hostname for `government-frontend` in that environment.

All other assets that have a path that don't match fall back to the static
application.

## Uploaded assets

Asset Manager is an API that is called internally by Publisher, Specialist
Publisher, Manuals Publisher, Travel Advice Publisher and Whitehall to manage
their uploads. It serves the uploaded assets on
`assets.publishing.service.gov.uk`.

### How uploaded assets are stored and served

Asset files are stored in an S3 bucket (e.g. `govuk-assets-production` in
production) and Asset Manager instructs nginx to proxy requests to them.

It should be noted that Asset Manager does actually serve the asset requests,
rather than letting nginx serve directly from the share. This is to enable the
following features:

- Assets are not served until they have been virus scanned; a placeholder image
  or page is shown for assets that are not finished scanning.
- Assets can be access-limited so that only authorised users can see them.
- Asset files can be replaced, and a request to the original path redirects to
  the replacement. Currently only Whitehall and Specialist Publisher support
  this.
