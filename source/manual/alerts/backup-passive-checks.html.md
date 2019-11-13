---
owner_slack: "#govuk-2ndline"
title: Backup passive checks
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2019-05-17
review_in: 6 months
---

These checks ensure that the backups have run within the last day (specifically
within the last 28 hours).

It's common to see 'freshness threshold exceeded' alerts in integration on a
Monday morning because integration is switched off over the weekend so the
backups do not run.

The backups are triggered at 10AM UTC, so the alerts should resolve themselves
around that time.

## MongoDB

If the backup has failed, you can try re-running it on the associated machine.

```shell
sudo su govuk-backup -c '/usr/bin/setlock /etc/unattended-reboot/no-reboot/mongodb-s3backup /usr/local/bin/mongodb-backup-s3 daily'
```

> **NOTE**: You might want to run this in a `screen` session, as it can take a while.
