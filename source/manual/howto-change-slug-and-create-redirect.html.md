---
owner_slack: "#govuk-developers"
title: Change a slug and create redirect in Whitehall
section: Publishing
layout: manual_layout
parent: "/manual.html"
---

## Change a slug and create a redirect in Whitehall

In Whitehall, we have Rake Tasks to change slugs and create redirects for
various entities: `Person`, `Role`, `Document`, `PolicyGroup`, `WorldLocation`,
`Organisation`, `WorldwideOrganisation` and `StatisticsAnnoucement`.

### Rake Tasks

These Rake Tasks also reindex the entity with its new slug and republish it to
Publishing API, which automatically handles the redirect. They all take the old
slug and the new slug as arguments.

To change slug and create redirect for a `Person` use `reslug:person[OLD_SLUG,NEW_SLUG]`.

To change slug and create redirect for a `Role` use `reslug:role[OLD_SLUG,NEW_SLUG]`.

To change slug and create redirect for a `Document`:

Visit the following URL, replacing `<edition_id>` with the ID of any of a documents editions:

```
https://whitehall-admin.publishing.service.gov.uk/government/admin/editions/<edition_id>/edit_slug
```

To change slug and create redirect for a `PolicyGroup` use `reslug:policy_group[OLD_SLUG,NEW_SLUG]`.

To change slug and create redirect for a `WorldLocation` use `reslug:world_location[OLD_SLUG,NEW_SLUG]`.

To change slug and create redirect for a `Organisation` use `reslug:organisation[OLD_SLUG,NEW_SLUG]`.

To change slug and create redirect for a `WorldwideOrganisation` use `reslug:worldwide_organisation[OLD_SLUG,NEW_SLUG]`.

To change slug and create redirect for a `StatisticsAnnoucement` use `reslug:statistics_annoucement[OLD_SLUG,NEW_SLUG]`.

### Issues

If you run a task and find the redirect has worked but the new location returns
a 404, it's likely because the republish command is languishing in the
low-priority queue ([check queue volumes in Grafana][grafana-queue-volumes]).
Whitehall appears to put the redirect in the low-priority queue, so there can
be a delay between the redirect being applied and the content being republished.

This should resolve itself over time, but if you need to process the content
change more quickly, run `represent_downstream:high_priority:content_id[CONTENT_ID]`
to put it in the high priority queue,

[grafana-queue-volumes]: https://grafana.production.govuk.digital/dashboard/file/sidekiq.json?refresh=1m&orgId=1&var-Application=publishing-api&var-Queues=All&from=now-30m&to=now
