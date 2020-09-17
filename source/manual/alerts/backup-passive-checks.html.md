---
owner_slack: "#govuk-2ndline"
title: Backup passive checks
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts

---

These checks ensure that the backups have run within the last day (specifically
within the last 28 hours).

## MongoDB

If the backup has failed, you can try re-running it on the associated machine.

```shell
sudo su - govuk-backup -c '/usr/bin/setlock /etc/unattended-reboot/no-reboot/mongodb-s3backup /usr/local/bin/mongodb-backup-s3 daily'
```

> **NOTE**: You might want to run this in a `screen` session, as it can take a while.
