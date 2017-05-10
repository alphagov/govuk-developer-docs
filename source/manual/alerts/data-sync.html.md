---
owner_slack: "#2ndline"
title: Data sync
section: Icinga alerts
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/2nd-line/alerts/data-sync.md"
last_reviewed_on: 2017-02-17
review_in: 6 months
---

> **This page was imported from [the opsmanual on github.gds](https://github.gds/gds/opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.gds/gds/opsmanual/tree/master/2nd-line/alerts/data-sync.md)


Data is synced from production to staging and integration every night.

Check the output of the production Jenkins job to see which part of
the data sync failed. It may be safe to re-run part of the sync.
