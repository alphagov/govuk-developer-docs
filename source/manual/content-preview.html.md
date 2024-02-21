---
owner_slack: "#govuk-developers"
title: How the draft stack works
parent: "/manual.html"
layout: manual_layout
type: learn
section: Publishing
---

GOV.UK has a Content Preview feature, also known as the _draft stack_. Content
Preview lets content editors preview new or updated content before making it
available on the public website.

## Design

Content Preview consists of separate "draft" deployments of Router, Content
Store and the frontend rendering apps such as government-frontend.

Publishing tools send content to
[publishing-api](https://github.com/alphagov/publishing-api). Every content
change is pushed to the draft content store as soon as it is saved, whereas a
content change is only pushed to the live content store when it is published.

## Environments

Content Preview runs in each GOV.UK environment:

- <https://draft-origin.publishing.service.gov.uk>
- <https://draft-origin.staging.publishing.service.gov.uk>
- <https://draft-origin.integration.publishing.service.gov.uk>

## Authentication and authorisation

In Whitehall Publisher, content editors can choose to limit access to
pre-publication content to specific users. To support this, the draft stack has
an [authenticating proxy](https://github.com/alphagov/authenticating-proxy)
between the load balancer and Router to control access.

The proxy passes the user's Signon user ID to Content Store via the request
header. Content Store is responsible for authorisation.

A draft content item has an optional metadata field, `access_limited`, which
represents an access control list (ACL). This ACL can contain:

- user IDs for allowing access to individual Signon users
- organisation IDs for allowing access to any user in a Signon organisation,
  such as a particular government department
- bearer tokens (internally called `auth_bypass_ids`) for constructing
  shareable preview URLs

GOV.UK uses the `auth_bypass_ids` bearer token feature to generate URLs for
draft content that can be shared with non-Signon users for preview or fact
checking. The token is encoded as a JSON Web Token (JWT) and appended to the
URL for sharing. When the recipient requests the URL, authenticating-proxy
extracts the `auth_bypass_id` bearer token from the JWT and passes it to
content-store via the request header.

Publishing API removes the `access_limited` field when sending content items to
the live Content Store, since all published content is public by definition.
