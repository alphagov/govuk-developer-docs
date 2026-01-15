---
owner_slack: "#govuk-developers"
title: 'Assets: how they work'
section: Assets
type: learn
layout: manual_layout
parent: "/manual.html"
related_repos: [asset-manager]
---

There are two types of asset files.

**Static assets** are stylesheets (CSS), JavaScript (JS) and image files which
make GOV.UK look the way it does.

**Uploaded assets** - also called attachments - are files like PDFs, CSVs and
images which are uploaded via the publishing apps and attached to documents.

## Static assets

These assets are served from `https://www.gov.uk/assets` with a path associated
with the application that is serving them. For example files within
`https://www.gov.uk/assets/government-frontend` are assets for the
[Government Frontend](/repos/government-frontend.html) application. These files
are cached by [the GOV.UK content delivery network](cdn.html).

These assets are served by the cache machines, these will proxy requests to
the application based on the path. For example `/assets/government-frontend/`
will proxy asset requests to Government Frontend

## Uploaded assets

[Asset Manager](/repos/asset-manager.html) is an API that is called internally
by [GOV.UK publishing applications](/#publishing-apps) to manage
their uploads. It serves the uploaded assets on
`assets.publishing.service.gov.uk`.

### How uploaded assets are stored and served

Asset files are stored in an S3 bucket (e.g. `govuk-assets-production` in
production) and Asset Manager instructs nginx to proxy requests to them.
Proxying was chosen, rather than linking directly to S3, to support the
following features:

- Assets are not served until they have been virus scanned; a placeholder image
  or page is shown for assets that are not finished scanning.
- Assets can be access-limited so that only authorised users can see them.
- Asset files can be replaced, and a request to the original path redirects to
  the replacement. Currently only Whitehall and Specialist Publisher support
  this.

### File size limit

There is a [hard limit of 500 MB](https://github.com/alphagov/govuk-helm-charts/blob/2e565071865d5e7b64bd1b961c2cdc69cbc04927/charts/asset-manager/templates/nginx-configmap.yaml#L145) for assets.

Publishers may see timeouts if they attempt to upload very large attachments.
In the past, we've worked around this by uploading a small file (in Whitehall) and
then [replacing the file in Asset Manager](https://docs.publishing.service.gov.uk/manual/manage-assets.html#replacing-an-asset).
