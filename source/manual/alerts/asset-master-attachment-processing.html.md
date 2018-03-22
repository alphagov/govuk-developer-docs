---
owner_slack: "#2ndline"
title: Asset master attachment processing
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2018-03-22
review_in: 3 months
---

When new assets get uploaded to asset-master-1, the assets user runs a script
(`/usr/local/bin/process-uploaded-attachment.sh`) every minute in a cronjob.

This kicks off a script (`virus-scan-file.sh`) that scans files and then moves
them into either a "clean" or "infected" directory.

This alert means that the job has not run for over half an hour and is probably
locked, or processing a large amount of files.
