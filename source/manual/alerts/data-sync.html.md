---
owner_slack: "#govuk-2ndline"
title: Data sync
section: Icinga alerts
layout: manual_layout
parent: "/manual.html"
---

## govuk_env_sync (the new way)

If you get an Icinga alert about a failing task, check `/var/log/syslog` and `/var/log/syslog.1` on the machine which runs the job. If the logs don't help, you can try re-running the sync job.

The data sync operations are executed as cron-jobs attached to the `govuk-backup` user. Run the following commands to get an overview of the jobs being run on a machine.

```bash
$ sudo crontab -lu govuk-backup

# Puppet Name: pull_content_data_admin_production_daily
18 0 * * * /usr/bin/ionice -c 2 -n 6 /usr/local/bin/with_reboot_lock /usr/bin/envdir /etc/govuk_env_sync/env.d /usr/local/bin/govuk_env_sync.sh -f /etc/govuk_env_sync/pull_content_data_admin_production_daily.cfg
...

```

The cron job command does the following:

1. Runs the data sync job at low I/O priority:
   `/usr/bin/ionice -c 2 -n 6`. This only really matters when running on a database server, as opposed to a `db_admin` bastion host, but the command is the same in both cases.
2. Prevents reboot by `unattended-upgrades` while the sync job is running:
   `/usr/local/bin/with_reboot_lock`
3. Runs the data sync job with the appropriate configuration file:
   `/usr/local/bin/govuk_env_sync.sh -f /etc/govuk_env_sync/pull_content_data_admin_production_daily.cfg`

To re-run a given sync job, copy the part of the cron-job corresponding to (3) and examine the output for any errors.

```bash
sudo -u govuk-backup /usr/local/bin/govuk_env_sync.sh -f /etc/govuk_env_sync/pull_content_data_admin_production_daily.cfg
```

For more information, check the general manual for [govuk_env_sync](/manual/govuk-env-sync.html).
