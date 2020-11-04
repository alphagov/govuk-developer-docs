---
owner_slack: "#re-govuk"
title: Restore an Individual Postgres Production Database in AWS RDS
section: Backups
layout: manual_layout
parent: "/manual.html"
---

> If you need to restore an entire RDS instance please see [this manual page](https://docs.publishing.service.gov.uk/manual/howto-backup-and-restore-in-aws-rds.html) instead.

### Restoring From S3 Backups

We take nightly database backups and save them to the `govuk-production-database-backups` S3 bucket inside the `postgresql-backend` folder.

To restore a backup from the most recent copy follow the steps below:

#### Restoring to Production

If you are restoring a database in the production environment, you will need to perform some additional steps first. You will need to ensure the Production db_admin machine has permission to read the Production PostgreSQL backups from S3 before you run the commands on db_admin (this is disabled by default as a safe guard). To do so, attach the govuk-production-s3-sync and blue-db-admin users to the  govuk-production-dbadmin_database_backups-reader-policy. You can do this by following the steps below:

1. Login to AWS Console and select the Production environment
1. Go [here](https://console.aws.amazon.com/iam/home?region=eu-west-1#/policies/arn:aws:iam::172025368201:policy/govuk-production-dbadmin_database_backups-reader-policy$serviceLevelSummary?section=permissions)
1. Select the tab "Policy Usage"
1. Click "Attach" then filter for and select the `govuk-production-s3-sync` and `blue-db-admin users`.
1. Click "Attach Policy"

Now follow the steps below to restore the database using the data sync script.

#### How To Run the DSync Script

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

See the [`govuk-env-sync` manual page](https://docs.publishing.service.gov.uk/manual/govuk-env-sync.html) for more information.
