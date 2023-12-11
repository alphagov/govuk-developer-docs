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

If you have not accessed the EKS before you will need to follow [the set up guide](/kubernetes/get-started/set-up-tools/) first.

To run a Rake task you need to:

- set your region and context as below, specifying the appropriate environment name (integration, staging, production)
- use an AWS role that has the necessary permissions (poweruser or administrator)

```bash
export AWS_REGION=eu-west-1
eval $(gds aws govuk-integration-poweruser -e --art 8h)
kubectl config use-context <your-context-name>
```

To change slug and create redirect for a `Person` use:

```bash
kubectl exec -n apps deploy/whitehall-admin -- rake 'reslug:person[OLD_SLUG,NEW_SLUG]'
```

To change slug and create redirect for a `Role` use:

```bash
 kubectl exec -n apps deploy/whitehall-admin -- rake 'reslug:role[OLD_SLUG,NEW_SLUG]'
 ```

To change slug and create redirect for a `Document`:

Visit the following URL, replacing `<edition_id>` with the ID of any of a documents editions:

```
https://whitehall-admin.publishing.service.gov.uk/government/admin/editions/<edition_id>/edit_slug
```

To change slug and create redirect for a `PolicyGroup` use:

```bash
kubectl exec -n apps deploy/whitehall-admin -- rake 'reslug:policy_group[OLD_SLUG,NEW_SLUG]'
```

To change slug and create redirect for a `WorldLocation` use:

```bash
kubectl exec -n apps deploy/whitehall-admin -- rake 'reslug:world_location[OLD_SLUG,NEW_SLUG]'
```

To change slug and create redirect for a `Organisation` use:

```bash
kubectl exec -n apps deploy/whitehall-admin -- rake 'reslug:organisation[OLD_SLUG,NEW_SLUG]'
```

To change slug and create redirect for a `WorldwideOrganisation` use:

```bash
kubectl exec -n apps deploy/whitehall-admin -- rake 'reslug:worldwide_organisation[OLD_SLUG,NEW_SLUG]'
```

To change slug and create redirect for a `StatisticsAnnoucement` use:

```bash
kubectl exec -n apps deploy/whitehall-admin -- rake 'reslug:statistics_annoucement[OLD_SLUG,NEW_SLUG]'
```

### Issues

If you run a task and find the redirect has worked but the new location returns
a 404, it's likely because the republish command is languishing in the
low-priority queue ([check queue volumes in Grafana][grafana-queue-volumes]).
Whitehall appears to put the redirect in the low-priority queue, so there can
be a delay between the redirect being applied and the content being republished.

This should resolve itself over time, but if you need to process the content
change more quickly, run `represent_downstream:high_priority:content_id[CONTENT_ID]`
to put it in the high priority queue,

[grafana-queue-volumes]: https://grafana.eks.production.govuk.digital/d/sidekiq-queues/sidekiq3a-queue-length-max-delay?orgId=1
