---
owner_slack: "#govuk-publishing-tech"
title: 'Assets: how they work'
section: Assets
type: learn
layout: manual_layout
parent: "/manual.html"
related_applications: [asset-manager, static]
---

There are three types of asset files.

**Static assets** are stylesheets (CSS), JavaScript (JS) and image files which
make GOV.UK look the way it does.

**Uploaded assets** - also called attachments - are files like PDFs, CSVs and
images which are uploaded via the publishing apps and attached to documents.

**Static templates** - these are HTML snippets served by the [Static](/apps/static.html)
application. These are used by applications to share common parts of the GOV.UK
page layout (such as header and footer).

## Static assets

These assets are served from `https://www.gov.uk/assets` with a path associated
with the application that is serving them. For example files within
`https://www.gov.uk/assets/government-frontend` are assets for the
[Government Frontend](/apps/government-frontend.html) application. These files
are cached by [the GOV.UK content delivery network](cdn.html).

These assets are served by the cache machines, these will proxy requests to
the application based on the path. For example `/assets/government-frontend/`
will proxy asset requests to Government Frontend

## Uploaded assets

[Asset Manager](apps/asset-manager.html) is an API that is called internally
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

## Static templates

The templates that Static hosts are used by
[GOV.UK frontend applications](/#frontend-apps) to render consistent aspects
of GOV.UK pages. Production instances of GOV.UK applications access these by
internal communication with Static.

These assets are also available publicly for development and preview versions
of GOV.UK applications. They allow apps to utilise these production resources
without needing to run an instance of Static manaul. Public access to Static
is provided by the `assets.publishing.service.gov.uk` hostname, which will
proxy any requests not served by Asset Manager to Static.
