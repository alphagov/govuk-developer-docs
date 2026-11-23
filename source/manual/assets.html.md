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
are cached by [Fastly](https://github.com/alphagov/govuk-fastly/blob/main/www/www.vcl.tftpl).

Asset files are stored in an S3 bucket (e.g. `govuk-app-assets-production` in
production) with object prefixes (e.g. `/assets/frontend`) for each application.

### Network flow for static assets

1. User makes a request for `https://www.gov.uk/assets/frontend/govuk_publishing_components/vendor/example.js` which hits Fastly
2. Fastly on a cache miss makes a request to the `govuk-app-assets-production` S3 bucket for `https://govuk-app-assets-production.s3.eu-west-1.amazonaws.com/assets/frontend/example.js`
3. The `govuk-app-assets-production` S3 bucket retrieves `assets/frontend/example.js` and returns it back to Fastly which caches it
8. Fastly returns the `assets/frontend/example.js` asset back to the user

<pre lang="mermaid">

<code>
sequenceDiagram
    actor User
    participant Fastly
    participant S3

    User->>Fastly:
    activate Fastly
    Fastly->>S3:
    S3-->>Fastly:
    Fastly-->>User:
    deactivate Fastly

</code>
</pre>

### Network flow for static assets on the draft stack

The network flow for the [draft stack](/manual/content-preview.html) bypasses Fastly and goes to [authenticating proxy](https://github.com/alphagov/authenticating-proxy/) then to [draft router](https://github.com/alphagov/router#draft-stack).

1. User makes a request for `https://draft-origin.publishing.service.gov.uk/assets/frontend/example.js` which hits authenticating-proxy
2. authenticating-proxy proxies the request to draft-Router's nginx which hits the location `/assets` directive
3. draft-Router proxies the request to the `govuk-app-assets-production` S3 bucket for `https://govuk-app-assets-production.s3.eu-west-1.amazonaws.com/assets/frontend/example.js`
3. The `govuk-app-assets-production` S3 bucket retrieves `assets/frontend/example.js` and returns it back to draft-Router's nginx
4. draft-Router's nginx returns the `assets/frontend/example.js` asset back to authenticating-proxy
5. authenticating-proxy returns the `assets/frontend/example.js` asset back to the user

<pre lang="mermaid">

<code>
sequenceDiagram
    actor User
    participant proxy as authenticating proxy
    participant Router as draft-Router nginx
    participant S3

    User->>proxy:
    activate proxy
    proxy->>Router:
    activate Router
    Router->>S3:
    S3-->>Router:
    deactivate Router
    Router-->>proxy:
    deactivate proxy
    proxy-->>User:

</code>
</pre>

### Network flow for static assets served by publishing apps

Publishing apps (e.g. whitehall-admin) don't use Router nor Fastly so their static assets are served from their nginx instance proxying to S3 for both the live and draft stacks.

1. User makes a request for `https://whitehall-admin.publishing.service.gov.uk/assets/whitehall/admin/example.js` which hits whitehall-admin's nginx location `/assets` directive
2. whitehall-admin's nginx makes a request to the `govuk-app-assets-production` S3 bucket for `https://govuk-app-assets-production.s3.eu-west-1.amazonaws.com/assets/whitehall/example.js`
3. The `govuk-app-assets-production` S3 bucket retrieves `assets/whitehall/example.js` and returns it back to whitehall-admin's nginx
8. whitehall-admin's nginx returns the `assets/whitehall/example.js` asset back to the user

<pre lang="mermaid">

<code>
sequenceDiagram
    actor User
    participant nginx as whitehall-admin nginx
    participant S3

    User->>nginx:
    activate nginx
    nginx->>S3:
    S3-->>nginx:
    nginx-->>User:
    deactivate nginx

</code>
</pre>

## Uploaded assets

[Asset Manager](/repos/asset-manager.html) is an API that is called internally
by [GOV.UK publishing applications](/#publishing-apps) to manage
their uploads. It serves the uploaded assets on
`assets.publishing.service.gov.uk`. These files
are cached by [Fastly](https://github.com/alphagov/govuk-fastly/blob/main/assets/assets.vcl.tftpl).

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
2. Fastly on a cache miss makes a request to asset manager's nginx for `example.pdf`
3. nginx performs an internal redirect to `location @app` which proxies a request to asset-manager for `example.pdf`
4. asset-manager on successful lookup returns `X-Accel-Redirect: cloud-storage-proxy/...` which contains the presigned S3 URL (e.g. `govuk-assets-production.s3.us-east-1.amazonaws.com/example.pdf?X-Amz-Algorithm=AWS4-HMAC-SHA256...`)
5. nginx performs an internal redirect to `location ~ /cloud-storage-proxy/(.*)` which proxies a request to S3 for `https://govuk-assets-production.s3.us-east-1.amazonaws.com/example.pdf?X-Amz-Algorithm=AWS4-HMAC-SHA256...`
6. The `govuk-assets-production` S3 bucket retrieves `example.pdf` and returns it back to nginx
7. nginx returns the response containing the `example.pdf` asset back to Fastly which caches it
8. Fastly returns the `example.pdf` asset back to the user

<pre lang="mermaid">

<code>
sequenceDiagram
    actor User
    participant Fastly
    participant nginx as asset-manager nginx
    participant asset-manager
    participant S3

    User->>Fastly:
    activate Fastly
    Fastly->>nginx:
    activate nginx
    nginx->>nginx: location @app
    nginx->>asset-manager:
    asset-manager-->>nginx:
    Note over nginx, asset-manager: Response Headers:<br/>X-Accel-Redirect:...
    nginx->>nginx: location ~ /cloud-storage-proxy/(.*)
    nginx->>S3:
    S3-->>nginx:
    nginx-->>Fastly:
    deactivate nginx
    Fastly-->>User:
    deactivate Fastly

</code>
</pre>

### Additional assets

Some uploaded assets have `/government/uploads` in their path (e.g. https://www.gov.uk/government/uploads/uploaded/hmrc/payetools-rti-17.3.17151.465-win.zip).

<pre lang="mermaid">

<code>
sequenceDiagram
    actor User
    participant Fastly
    participant Router
    participant Frontend

    User->>Fastly:
    activate Fastly
    Fastly->>Router:
    activate Router
    Router->>Frontend:
    Frontend-->>Router:
    deactivate Router
    Router-->>Fastly:
    deactivate Fastly
    Fastly-->>User:

</code>
</pre>

1. User makes a request for `https://www.gov.uk/government/uploads/uploaded/example.pdf` which hits Fastly
2. Fastly on a cache miss makes a request to Router for `https://www.gov.uk/government/uploads/uploaded/example.pdf`
3. Router proxies this request to a backend (e.g. frontend)
4. Frontend returns a `301` redirect for `https://assets.publishing.service.gov.uk/government/uploads/uploaded/department/example.pdf`
5. Router returns this back to Fastly
6. Fastly returns this back to the user who is redirected to `https://assets.publishing.service.gov.uk/government/uploads/uploaded/department/example.pdf` to begin the [network flow for live assets](#network-flow-for-live-assets)

### File size limit

There is a [hard limit of 500 MB](https://github.com/alphagov/govuk-helm-charts/blob/2e565071865d5e7b64bd1b961c2cdc69cbc04927/charts/asset-manager/templates/nginx-configmap.yaml#L145) for assets.

Publishers may see timeouts if they attempt to upload very large attachments.
In the past, we've worked around this by uploading a small file (in Whitehall) and
then [replacing the file in Asset Manager](https://docs.publishing.service.gov.uk/manual/manage-assets.html#replacing-an-asset).
