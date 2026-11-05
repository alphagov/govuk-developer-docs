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
`https://www.gov.uk/assets/frontend` are assets for the
[Frontend](/repos/frontend.html) application. These files
are cached by [the GOV.UK content delivery network](cdn.html).

These assets are served by the cache machines, these will proxy requests to
the application based on the path. For example `/assets/frontend/`
will proxy asset requests to Frontend

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

### Network flow for live assets

Retrieving an uploaded asset involves requests between asset-manager's [nginx proxy](https://github.com/alphagov/govuk-helm-charts/blob/c3efe0ccd91a06ce1a0f0a96d8c5c36cb3939046/charts/asset-manager/templates/nginx-configmap.yaml), asset-manager's Rails app and S3.

1. User makes a request for `https://assets.publishing.service.gov.uk/media/6ae90b0e5b14ba0182a272a4/example.pdf` which hits Fastly
2. Fastly on a cache miss makes a request to Router for `example.pdf`
3. Router makes a request to asset manager's nginx for `example.pdf`
4. nginx performs an internal redirect to `location @app` which proxies a request to asset-manager for `example.pdf`
5. asset-manager on successful lookup returns `X-Accel-Redirect: cloud-storage-proxy/...` which contains the presigned S3 URL (e.g. `govuk-assets-production.s3.us-east-1.amazonaws.com/example.pdf?X-Amz-Algorithm=AWS4-HMAC-SHA256...`)
6. nginx performs an internal redirect to `location ~ /cloud-storage-proxy/(.*)` which proxies a request to S3 for `https://govuk-assets-production.s3.us-east-1.amazonaws.com/example.pdf?X-Amz-Algorithm=AWS4-HMAC-SHA256...`
7. The `govuk-assets-production` S3 bucket retrieves `example.pdf` and returns it back to nginx
8. nginx returns the response containing the `example.pdf` asset back to Router
9. Router returns the `example.pdf` asset back to Fastly which caches it
10. Fastly returns the `example.pdf` asset back to the user

<pre lang="mermaid">

<code>
sequenceDiagram
    actor User
    participant Fastly
    participant Router
    participant nginx
    participant asset-manager
    participant S3

    User->>Fastly:
    activate Fastly
    Fastly->>Router:
    activate Router
    Router->>nginx:
    activate nginx
    nginx->>nginx: location @app
    nginx->>asset-manager:
    asset-manager-->>nginx:
    Note over nginx, asset-manager: Response Headers:<br/>X-Accel-Redirect:...
    nginx->>nginx: location ~ /cloud-storage-proxy/(.*)
    nginx->>S3:
    S3-->>nginx:
    nginx-->>Router:
    deactivate nginx
    Router-->>Fastly:
    deactivate Router
    Fastly-->>User:
    deactivate Fastly

</code>
</pre>

The network flow for the [draft stack](/manual/content-preview.html). is identical except the request goes to [authenticating proxy](https://github.com/alphagov/authenticating-proxy/) then to [draft router](https://github.com/alphagov/router#draft-stack).

### File size limit

There is a [hard limit of 500 MB](https://github.com/alphagov/govuk-helm-charts/blob/2e565071865d5e7b64bd1b961c2cdc69cbc04927/charts/asset-manager/templates/nginx-configmap.yaml#L145) for assets.

Publishers may see timeouts if they attempt to upload very large attachments.
In the past, we've worked around this by uploading a small file (in Whitehall) and
then [replacing the file in Asset Manager](https://docs.publishing.service.gov.uk/manual/manage-assets.html#replacing-an-asset).
