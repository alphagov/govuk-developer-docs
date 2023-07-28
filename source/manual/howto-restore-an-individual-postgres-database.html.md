---
owner_slack: "#govuk-2ndline-tech"
title: Restore an Individual Postgres Production Database in AWS RDS
section: Backups
layout: manual_layout
parent: "/manual.html"
---

> If you need to restore an entire RDS instance please see [this manual page](/manual/howto-backup-and-restore-in-aws-rds.html) instead.

### Restoring From S3 Backups

We take nightly database backups and save them to the `govuk-<environment>-database-backups` S3 bucket inside a folder named after the RDS instance (for example `publishing-api-postgres`).

To restore a backup from the most recent copy follow the steps below:

#### How To Run the Sync Script

1. SSH into the db_admin machine. If you are using GDS CLI you can run the following command to ssh into the correct machine:

```
gds govuk connect ssh -e <environment> db_admin
```

2. To find the command you need to run to restore a specific database, list the govuk-backup user's cronjobs, then grep for the database name you need:

  ```
  sudo -iu govuk-backup crontab -l | grep <database_name>
  ```

  E.g.

  ```
  sudo -iu govuk-backup crontab -l | grep publishing_api
  ```

3. Copy the command that starts with "pull". For example, if you were restoring the publishing_api database you'd need this line:

```
/usr/bin/ionice -c 2 -n 6 /usr/local/bin/with_reboot_lock /usr/bin/envdir /etc/govuk_env_sync/env.d /usr/local/bin/govuk_env_sync.sh -f /etc/govuk_env_sync/pull_publishing_api_production_daily.cfg
```

4. Start a tmux session as the govuk-backup user:

```
sudo -iu govuk-backup tmux
```

5. Then run the command you copied previously.

6. The script will inform you when it's complete. To switch between tmux windows, press `Control-B` then `n`. To disconnect from tmux, press `Control-B` then press `d`. To reconnect, run `sudo -iu govuk-backup tmux a`

See the [`govuk-env-sync` manual page](/manual/govuk-env-sync.html) for more information.
