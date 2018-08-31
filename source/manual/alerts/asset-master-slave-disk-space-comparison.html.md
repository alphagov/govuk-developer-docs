---
owner_slack: "#govuk-2ndline"
title: Asset master and slave disk space comparison
section: Icinga alerts
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-08-31
review_in: 6 months
---

Documents uploaded to `asset-master-1` by most publishing apps are copied to the
`asset-slave` machines by two cron jobs:

- `sync-asset-manager-from-master`, which runs every 10 minutes on the
  `asset-slave` machines and syncs data uploaded through asset-manager
- `rsync-uploads`, which runs just once a day on the `asset-master` machine and
  copies whitehall assets to the slave machines

This means that if `sync-asset-manager-from-master` is running correctly and
nothing large has been uploaded to whitehall, the master and slave machines
should always have almost identical copies of the assets, and the disk space
usage should be very similar.

A difference in the disk usage triggers the alert: "Asset master and slave are
using about the same amount of disk space".

## Investigation

Check that the asset-manager cron job is syncing new asset data correctly by
checking the [assets Grafana
dashboard](https://grafana.publishing.service.gov.uk/dashboard/db/assets) or
graphing `asset-slave-*_backend*.df-mnt-uploads.df_complex-used` in [Graphite or
Grafana](https://docs.publishing.service.gov.uk/manual/tools.html).

During working hours, disk usage should be slowly increasing as new assets are
synced. A flat graph suggests that syncing is failing. Check the output of the
`sync-asset-manager-from-master` job on the `asset-slave` machines.

If the disk usage is slowly increasing, the most likely cause of the alert is
that a large volume of files has been uploaded to Whitehall. In this case the
alert will only resolve itself when the daily sync job runs so the alert is a
false alarm and can be acknowledged.

It is worth checking on `asset-master-1` the `/mnt/uploads/support-api/csvs` directory as any reports generated against zendesk get created here, if the report is poorly constrained this can be large (>1GB). These files will be synced daily as part of the `rsync-uploads` task. Use `ls -hltr` to check if any of the recent files are particularly large.
