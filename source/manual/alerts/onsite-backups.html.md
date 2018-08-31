---
owner_slack: "#govuk-2ndline"
title: Onsite backups failed
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2018-08-31
review_in: 6 months
---

The backup machine (e.g. `backup-1.management.integration`) collects backups from the various data stores at 9am every morning.

The location of the backups is defined in [govuk-puppet](https://github.com/alphagov/govuk-puppet/blob/master/modules/govuk/manifests/node/s_backup.pp).

It's likely that this is failing because one of the backups it's trying to collect is not ready yet when the process runs. We have an example of [running the PostgreSQL backup earlier](https://github.com/alphagov/govuk-puppet/pull/7619) to deal with this situation.

To rerun an individual backup:

```
ssh backup-1.management.production
sudo su - govuk-backup
cd /etc/backup/
./001_directory_backup_postgresql_backups_postgresql_primary_1 # Or whichever script is relevant
```

If after running the script you find that you get some "Permission denied" errors on the files that the script is trying to copy, this probably means that the backup on the machine that the script is trying to copy from hasn't finished yet. Only after that has finished will it change permissions to the `govuk-backup` user.
