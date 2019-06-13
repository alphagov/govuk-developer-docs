---
owner_slack: "#govuk-2ndline"
title: Data sync
section: Icinga alerts
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-05-02
review_in: 6 months
---
> **Note on AWS**
>
> For databases migrated to AWS RDS, the env-sync-and-backup was replaced by the [govuk_env_sync](/manual/govuk-env-sync.html).
> The env-sync-and-backup data synchronisation is still in use for synchronisation of non-migrated
> databases into the integration environment.

Data and assets/attachments are synced from production to staging and integration every night.

Check the output of the production Jenkins job to see which part of the sync failed. It may be safe to re-run part of the sync.

> **WARNING**
>
> The mysql backup will cause signon in staging to point to production until the
> `Data Sync Complete` job runs and renames the hostnames copied from production
> to back to their staging equivalents.  This means that any deploys to staging
> that rely on GDS API Adapters are likely to fail due to authentication
> failures, as well as Smokey tests that attempt to use Signon.

The Jenkins jobs included in the sync are:

* [Copy Data to Staging](https://deploy.publishing.service.gov.uk/job/Copy_Data_to_Staging/)
* [Copy Attachments to Staging](https://deploy.publishing.service.gov.uk/job/Copy_Attachments_to_Staging/)
* [Copy Data to Integration](https://deploy.publishing.service.gov.uk/job/Copy_Data_to_Integration/)
* [Copy Attachments to Integration](https://deploy.publishing.service.gov.uk/job/Copy_Attachments_to_Integration/)
* [Copy Licensify Data to Staging](https://deploy.publishing.service.gov.uk/job/Copy_Licensify_Data_to_Staging/)
* [Copy and Sync sanitised whitehall database](https://deploy.publishing.service.gov.uk/job/copy_sanitised_whitehall_database/) (production to integration only)

See the [source code](https://github.com/alphagov/env-sync-and-backup/tree/master/jobs) of the jobs for more information about how they work.
