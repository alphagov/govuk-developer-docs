---
owner_slack: "#govuk-2ndline"
title: Data sync
section: Icinga alerts
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-08-31
review_in: 6 months
---

Data and assets/attachments are synced from production to staging and integration every night.

Check the output of the production Jenkins job to see which part of the sync failed. It may be safe to re-run part of the sync.

Warning: the mysql backup will cause signon in staging to point to production until the `Data Sync Complete` job runs and renames the hostnames copied from production to back to their staging equivalents.  This means that any deploys to staging that rely on GDS API Adapters are likely to fail due to authentication failures, as well as Smokey tests that attempt to use Signon.

The Jenkins jobs included in the sync are:

* Copy Data to Staging
* Copy Attachments to Staging
* Copy Data to Integration
* Copy Attachments to Integration
* Copy Licensify Data to Staging
* Copy and Sync sanitised whitehall database (production to integration only)

See the [source code](https://github.com/alphagov/env-sync-and-backup/tree/master/jobs) of the jobs for more information about how they work.
