---
owner_slack: "#2ndline"
title: Fix stuck virus scanning
section: Icinga alerts
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/2nd-line/alerts/virus-scanning.md"
last_reviewed_on: 2016-12-27
review_in: 6 months
---

> **This page was imported from [the opsmanual on GitHub Enterprise](https://github.digital.cabinet-office.gov.uk/gds/opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.digital.cabinet-office.gov.uk/gds/opsmanual/tree/master/2nd-line/alerts/virus-scanning.md)


Documents uploaded to asset-master are scanned asynchronously through
a virus scanner, as explained in <https://github.digital.cabinet-office.gov.uk/pages/gds/opsmanual/2nd-line/applications/whitehall.html?highlight=whitehall#virus-scanning-of-uploaded-files>

If the number of documents is too high, users can experience long waiting times
until they see the documents available. There is a Grafana [dashboard](https://grafana.publishing.service.gov.uk/dashboard/file/asset_master_virus_scan_speed.json) that helps to
visualise the number of documents that have been processed and the waiting time since the file
has been placed on disk until it is scanned.

If the waiting time is too long, you can follow the [instructions](https://github.digital.cabinet-office.gov.uk/pages/gds/opsmanual/2nd-line/applications/whitehall.html?highlight=whitehall#quickly-processing-a-backlog-of-files-awaiting-av-scan) to quickly process a backlog of files
awaiting the scan.
