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

- Change slug and create redirect for a `Person`:
  - in [integration][person-integration]
  - in [staging][person-staging]
  - in [⚠️ production ⚠️][person-production]

[person-integration]: https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/parambuild/?delay=0sec&TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=reslug:person[OLD_SLUG,NEW_SLUG]
[person-staging]: https://deploy.blue.staging.govuk.digital/job/run-rake-task/parambuild/?delay=0sec&TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=reslug:person[OLD_SLUG,NEW_SLUG]
[person-production]: https://deploy.blue.production.govuk.digital/job/run-rake-task/parambuild/?delay=0sec&TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=reslug:person[OLD_SLUG,NEW_SLUG]

- Change slug and create redirect for a `Role`:
  - in [integration][role-integration]
  - in [staging][role-staging]
  - in [⚠️ production ⚠️][role-production]

  [role-integration]: https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/parambuild/?delay=0sec&TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=reslug:role[OLD_SLUG,NEW_SLUG]
  [role-staging]: https://deploy.blue.staging.govuk.digital/job/run-rake-task/parambuild/?delay=0sec&TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=reslug:role[OLD_SLUG,NEW_SLUG]
  [role-production]: https://deploy.blue.production.govuk.digital/job/run-rake-task/parambuild/?delay=0sec&TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=reslug:role[OLD_SLUG,NEW_SLUG]

- Change slug and create redirect for a `Document`:
  - in [integration][document-integration]
  - in [staging][document-staging]
  - in [⚠️ production ⚠️][document-production]

[document-integration]: https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/parambuild/?delay=0sec&TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=reslug:document[OLD_SLUG,NEW_SLUG]
[document-staging]: https://deploy.blue.staging.govuk.digital/job/run-rake-task/parambuild/?delay=0sec&TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=reslug:document[OLD_SLUG,NEW_SLUG]
[document-production]: https://deploy.blue.production.govuk.digital/job/run-rake-task/parambuild/?delay=0sec&TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=reslug:document[OLD_SLUG,NEW_SLUG]

- Change slug and create redirect for a `PolicyGroup`:
  - in [integration][policy_group-integration]
  - in [staging][policy_group-staging]
  - in [⚠️ production ⚠️][policy_group-production]

  [policy_group-integration]: https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/parambuild/?delay=0sec&TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=reslug:policy_group[OLD_SLUG,NEW_SLUG]
  [policy_group-staging]: https://deploy.blue.staging.govuk.digital/job/run-rake-task/parambuild/?delay=0sec&TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=reslug:policy_group[OLD_SLUG,NEW_SLUG]
  [policy_group-production]: https://deploy.blue.production.govuk.digital/job/run-rake-task/parambuild/?delay=0sec&TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=reslug:policy_group[OLD_SLUG,NEW_SLUG]

- Change slug and create redirect for a `WorldLocation`:
  - in [integration][world_location-integration]
  - in [staging][world_location-staging]
  - in [⚠️ production ⚠️][world_location-production]

  [world_location-integration]: https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/parambuild/?delay=0sec&TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=reslug:world_location[OLD_SLUG,NEW_SLUG]
  [world_location-staging]: https://deploy.blue.staging.govuk.digital/job/run-rake-task/parambuild/?delay=0sec&TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=reslug:world_location[OLD_SLUG,NEW_SLUG]
  [world_location-production]: https://deploy.blue.production.govuk.digital/job/run-rake-task/parambuild/?delay=0sec&TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=reslug:world_location[OLD_SLUG,NEW_SLUG]

- Change slug and create redirect for a `Organisation`:
  - in [integration][organisation-integration]
  - in [staging][organisation-staging]
  - in [⚠️ production ⚠️][organisation-production]

  [organisation-integration]: https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/parambuild/?delay=0sec&TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=reslug:organisation[OLD_SLUG,NEW_SLUG]
  [organisation-staging]: https://deploy.blue.staging.govuk.digital/job/run-rake-task/parambuild/?delay=0sec&TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=reslug:organisation[OLD_SLUG,NEW_SLUG]
  [organisation-production]: https://deploy.blue.production.govuk.digital/job/run-rake-task/parambuild/?delay=0sec&TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=reslug:organisation[OLD_SLUG,NEW_SLUG]

- Change slug and create redirect for a `WorldwideOrganisation`:
  - in [integration][worldwide_organisation-integration]
  - in [staging][worldwide_organisation-staging]
  - in [⚠️ production ⚠️][worldwide_organisation-production]

  [worldwide_organisation-integration]: https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/parambuild/?delay=0sec&TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=reslug:worldwide_organisation[OLD_SLUG,NEW_SLUG]
  [worldwide_organisation-staging]: https://deploy.blue.staging.govuk.digital/job/run-rake-task/parambuild/?delay=0sec&TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=reslug:worldwide_organisation[OLD_SLUG,NEW_SLUG]
  [worldwide_organisation-production]: https://deploy.blue.production.govuk.digital/job/run-rake-task/parambuild/?delay=0sec&TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=reslug:worldwide_organisation[OLD_SLUG,NEW_SLUG]

- Change slug and create redirect for a `StatisticsAnnoucement`:
  - in [integration][statistics_annoucement-integration]
  - in [staging][statistics_annoucement-staging]
  - in [⚠️ production ⚠️][statistics_annoucement-production]

  [statistics_annoucement-integration]: https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/parambuild/?delay=0sec&TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=reslug:statistics_annoucement[OLD_SLUG,NEW_SLUG]
  [statistics_annoucement-staging]: https://deploy.blue.staging.govuk.digital/job/run-rake-task/parambuild/?delay=0sec&TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=reslug:statistics_annoucement[OLD_SLUG,NEW_SLUG]
  [statistics_annoucement-production]: https://deploy.blue.production.govuk.digital/job/run-rake-task/parambuild/?delay=0sec&TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=reslug:statistics_annoucement[OLD_SLUG,NEW_SLUG]

### Issues

If you run a task and find the redirect has worked but the new location returns
a 404, it's likely because the republish command is languishing in the
low-priority queue ([check queue volumes in Grafana][grafana-queue-volumes]).
Whitehall appears to put the redirect in the high priority queue, so there can
be a delay between the redirect being applied and the content being republished.

This should resolve itself over time, but if you need to process the content
change more quickly, run `represent_downstream:high_priority:content_id[CONTENT_ID]`
to put it in the high priority queue:

- in [integration][high-priority-queue-integration]
- in [staging][high-priority-queue-staging]
- in [⚠️ production ⚠️][high-priority-queue-production]

[grafana-queue-volumes]: https://grafana.production.govuk.digital/dashboard/file/sidekiq.json?refresh=1m&orgId=1&var-Application=publishing-api&var-Queues=All&from=now-30m&to=now
[high-priority-queue-integration]: https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/parambuild/?delay=0sec&TARGET_APPLICATION=publishing-api&MACHINE_CLASS=publishing_api&RAKE_TASK=represent_downstream:high_priority:content_id[CONTENT_ID]
[high-priority-queue-staging]: https://deploy.blue.staging.govuk.digital/job/run-rake-task/parambuild/?delay=0sec&TARGET_APPLICATION=publishing-api&MACHINE_CLASS=publishing_api&RAKE_TASK=represent_downstream:high_priority:content_id[CONTENT_ID]
[high-priority-queue-production]: https://deploy.blue.production.govuk.digital/job/run-rake-task/parambuild/?delay=0sec&TARGET_APPLICATION=publishing-api&MACHINE_CLASS=publishing_api&RAKE_TASK=represent_downstream:high_priority:content_id[CONTENT_ID]
