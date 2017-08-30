---
owner_slack: "#2ndline"
title: Data sync
section: Icinga alerts
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/2nd-line/alerts/data-sync.md"
last_reviewed_on: 2017-08-30
review_in: 6 months
---

> **This page was imported from [the opsmanual on GitHub Enterprise](https://github.com/alphagov/govuk-legacy-opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.com/alphagov/govuk-legacy-opsmanual/tree/master/2nd-line/alerts/data-sync.md)


Data is synced from production to staging and integration every night.

Check the output of the production Jenkins job to see which part of
the data sync failed. It may be safe to re-run part of the sync.

Warning: the mysql backup will cause signon in staging to point to production until the `Data Sync Complete` job runs and renames the hostnames copied from production to back to their staging equivalents.  This means that any deploys to staging that rely on GDS API Adapters are likely to fail due to to authentication failures.

The Jenkins jobs included in the sync are:

* Copy Data to Staging
* Copy Data to integration
* Copy Licensify Data to staging

See the [source code](https://github.com/alphagov/env-sync-and-backup/tree/master/jobs) of the jobs for more information about how they work.
