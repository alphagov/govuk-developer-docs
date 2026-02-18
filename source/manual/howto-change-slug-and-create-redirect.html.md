---
owner_slack: "#govuk-developers"
title: Change slug and redirect a route
section: Publishing
layout: manual_layout
parent: "/manual.html"
---

How you change a slug or redirect a route depends on:

- which publishing app owns the route
- whether the content already exists
- whether you are renaming content or simply redirecting it elsewhere

This page covers the common patterns across publishing apps and links to service-specific guidance where required.

## Identify the owning app

Before making any changes, determine which app owns the route.

Visit the [Content Store API endpoint](/repos/content-store/content-store-api.html#reading-content-from-the-content-store) (by appending `/api/content/<path>` to the path or using the govuk-browser-extension) and look for the `publishing_app` property.

Alternatively, open a Content Store console:

```bash
gds govuk connect app-console -e production content_store/content-store
```

Then:

```ruby
ContentItem.find_by(base_path: "/path-to-item").publishing_app
```

That tells you which app is authoritative for the route.

## Choosing the right approach

| Scenario | Action |
|----------|--------|
| Renaming live content | Use the owning publishing app (reslug task or UI) |
| Removing live content and redirecting | Unpublish via app UI |
| Redirect does not exist and no UI support | Use Publishing API `unpublish(type: "redirect")` |
| Short URL (e.g. `gov.uk/dfe`) | Use Short URL Manager |
| HMRC manual or manual section | Use hmrc-manuals-api rake tasks |
| Organisation slug change | Follow the organisation-specific multi-app process |

If in doubt, always prefer:

1. The publishing app that owns the route.
1. A workflow-based change rather than manual Publishing API intervention.

## Renaming content (changing its slug)

If the content still exists and you want to change its slug while keeping it live, always use the publishing app that owns it. This ensures:

- Publishing API is updated correctly
- a redirect is created automatically
- search indexes are updated
- downstream content is republished

### Whitehall

For "editionable" documents, use the admin interface:

`https://whitehall-admin.publishing.service.gov.uk/government/admin/editions/<edition_id>/edit_slug`

Editing the slug:

- changes the slug
- republishes to Publishing API
- creates the redirect automatically

For organisations, follow the [Change an organisation's slug](/manual/changing-organisation-slug.html) instructions, as there are changes required across multiple applications.

For all other non-editionable entities, there are dedicated rake tasks you can run.

First, you must have EKS access configured and use an appropriate AWS role.

```bash
export AWS_REGION=eu-west-1
eval $(gds aws govuk-integration-developer -e --art 8h)
kubectl config use-context <your-context-name>
```

Then run the appropriate task:

```bash
kubectl exec -n apps deploy/whitehall-admin -- rake 'reslug:person[OLD_SLUG,NEW_SLUG]'
kubectl exec -n apps deploy/whitehall-admin -- rake 'reslug:role[OLD_SLUG,NEW_SLUG]'
kubectl exec -n apps deploy/whitehall-admin -- rake 'reslug:policy_group[OLD_SLUG,NEW_SLUG]'
kubectl exec -n apps deploy/whitehall-admin -- rake 'reslug:world_location[OLD_SLUG,NEW_SLUG]'
kubectl exec -n apps deploy/whitehall-admin -- rake 'reslug:statistics_announcement[OLD_SLUG,NEW_SLUG]'
```

If the redirect works but the new location returns a 404, the republish may be waiting in a low-priority queue. You can enqueue it at high priority with:

```bash
kubectl exec -n apps deploy/publishing-api -- rake 'represent_downstream:high_priority:content_id[CONTENT_ID]'
```

Queue volumes can be checked in Grafana.

### Specialist Publisher

In Specialist Publisher, the base path is generated from the title at creation time. Publishers cannot edit the base path via the UI.

To change the base path, use the rake task:

```
base_path:edit[content_id,locale,new_base_path]
```

You can obtain the `content_id` and `locale` using the govuk-browser-extension.

The task updates the latest draft (creating a new draft if one does not exist).

IMPORTANT: to make the change permanent, you'll need to publish the draft, either in the UI or via the Specialist Publisher rails console (`Document.find('content_id-of-the-document').publish`).

## Redirecting content (not renaming it)

### Preferred approach: use the publishing app

If the content still exists in a publishing app, unpublish it via that app’s workflow and choose the redirect option. This:

- keeps history intact
- propagates correctly through Publishing API
- avoids manual intervention

Not all apps support this. If they do not, use the Publishing API directly (see below).

### Manual redirect via Publishing API

If a redirect does not yet exist in Publishing API and cannot be created via the app UI:

1. Retrieve the `content_id` from `/api/content/<path>`.
1. Open a console on the publishing app.
1. Run:

   ```ruby
   GdsApi.publishing_api.unpublish(
     content_id,
     type: "redirect",
     explanation: "manually redirected by YOUR_NAME",
     alternative_path: "/new-path",
     discard_drafts: true
   )
   ```

A successful response returns HTTP 200.

Verify in Content Store that:

- `document_type` is "redirect"
- `redirects` contains the correct `path` and `destination`

Router should update automatically once Content Store processes the change.

### Publishing API and Content Store out of sync

Sometimes a redirect exists in Publishing API but has not propagated.

Use the `represent_downstream` rake tasks in Publishing API to re-present the content item.

### Removing a route entirely

If a route is reserved or blocked (for example by a previous redirect or a 410):

1. Delete the path reservation in Publishing API (via Rails console in the publishing-api app).

   ```ruby
   PathReservation.find_by(base_path: "/example-path").delete
   ```

1. Remove the content item in live Content Store and draft Content Store (via Rails console in content-store and draft-content-store respectively).

   ```ruby
   ContentItem.find_by(base_path: "/example-path").delete
   ```

After removing the reservation, republish the content that should now occupy that path.

Finally, [purge the cache for the route](/manual/purge-cache.html).

## Short URLs (gov.uk/xyz)

If the redirect is for a short URL (for example `gov.uk/dfe`), use Short URL Manager.

Short URL Manager publishes redirects via Publishing API and requires appropriate Signon permissions.

Short URL routes can also be deleted from within the Short URL Manager UI. Deleted routes return HTTP 410.

## HMRC manuals

HMRC manuals and sections have [dedicated rake tasks in the hmrc-manuals-api repository](https://github.com/alphagov/hmrc-manuals-api/tree/main/lib/tasks).

## Campaign sites

The campaigns platform is a WordPress site managed by GDS (Business, Priority Response and Campaigns team) and supported by dxw. Redirects from a `*.campaign.gov.uk` site require a support ticket. You should contact <govuk.campaigns@digital.cabinet-office.gov.uk> to raise a support ticket.
