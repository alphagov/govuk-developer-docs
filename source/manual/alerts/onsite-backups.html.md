---
owner_slack: "#govuk-2ndline"
title: Onsite backups failed
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2018-03-26
review_in: 6 months
---

The backup machine (e.g. `backup-1.management.integration`) collects
backups from the various data stores.

The location of the backups is defined in
[govuk-puppet](https://github.com/alphagov/govuk-puppet/blob/master/modules/govuk/manifests/node/s_backup.pp)

To rerun an individual backup:

```
ssh backup-1.management.production
sudo su - govuk-backup
cd /etc/backup/
./001_directory_backup_postgresql_backups_postgresql_primary_1 # Or whatever script is relevant
```
