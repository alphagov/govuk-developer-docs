---
owner_slack: "#govuk-developers"
title: How the draft stack works
parent: "/manual.html"
layout: manual_layout
type: learn
section: Publishing
last_reviewed_on: 2019-08-22
review_in: 6 months
---

The "draft stack" on GOV.UK, is intended to be
a full version of GOV.UK that includes content that has not yet been
sent for publication. This allows content editors to preview their
content before making it live, without having to manually copy it into a
separate version of the publishing tool.

Content Preview contains [most frontend applications][preview-puppet].

Content Preview exists in each of integration, staging and production.

[preview-puppet]: https://github.com/alphagov/govuk-puppet/blob/master/hieradata/class/draft_frontend.yaml

## Design

Content Preview consists of separate 'draft' instances of the router,
frontend and content-store machines. These are located at
draft-cache-{1,2}.router, draft-frontend-{1,2}.frontend, and
draft-content-store-{1,2}.api respectively.

Publishing tools send content to the
[publishing-api](https://github.com/alphagov/publishing-api). All
content is initially pushed to the draft content store, and then to the
live content store when it is published.

The draft-frontend and draft-cache machines host draft instances of the
frontend apps and router which serve the content from the draft
content-store. Both router and content-store share MongoDB clusters with
their respective live versions, although they use separate databases on
these clusters.

Because draft involves content-store apps only, there are no instances
of MySQL or PostgreSQL in Content Preview, and no backend apps (except
for router-api).

## Location

Content Preview is available in all three environments.

-   <https://draft-origin.publishing.service.gov.uk>
-   <https://draft-origin.staging.publishing.service.gov.uk>
-   <https://draft-origin.integration.publishing.service.gov.uk>

The machines are available in the same organisations as their live
counterparts, and use a `draft-` prefix, eg:

-   draft-cache-1.router.integration
-   draft-frontend-2.frontend.production
-   draft-content-store.1.api.integration

and so on.

## Authentication

Because Whitehall permits content to be access-limited before
publication, the draft environment enforces Signon authentication for
all routes. This is performed by the
[authenticating-proxy](https://github.com/alphagov/authenticating-proxy)
app, which sits between Varnish and the router.

Draft content items can contain an optional `access_limited` hash in
their metadata, which contains a list of Signon user UIDs corresponding
to the users who are permitted to see that content. All other users will
see a 403 Forbidden page.

(This is achieved by the API adapters passing the UID in the headers of
the request to content-store, in the same way as the govuk-request-id.)

Publishing apps can also add an `auth_bypass_ids` list to the access limited
hash, to allow unauthenticated access for preview or fact checking. The ID is
encoded in a JSON Web Token and appended to the URL provided to the users.
Authenticating-proxy decodes the token and extracts the ID, and again passes
it to the content-store in the request headers, where it is compared with the
ID stored on the requested content item.

Publishing API strips out the `access_limited` hash before sending data to the
live content-store, since all published content is viewable by everyone.
