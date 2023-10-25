---
owner_slack: "#govuk-2ndline-tech"
title: Mirror GOV.UK content to S3
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

> Note that this page refers to the old mirror job in Puppet. The new mirror job runs in EKS and is documented in [GOV.UK content mirrors](/manual/fall-back-to-mirror.html). This page will be removed or updated once the monitoring mechanism for the new mirror job has been implemented.

## What this alert means

The govuk_sync_mirror cronjob has not succeeded for 24h. govuk_sync_mirror is [a script that runs hourly](https://github.com/alphagov/govuk-puppet/blob/1364bfbb023cd475fac37b99ca812a2ff985ce77/modules/govuk_crawler/manifests/init.pp#L223-L230) to upload new or changed GOV.UK content to the static mirror in S3. Fastly automatically serves content from the S3 mirror when a request to the origin fails.

## Impact

Provided www-origin and assets-origin are working perfectly, there should be no user-visible impact. If the origin has a problem however, we will fail to serve content which was published after the govuk_sync_mirror job stopped working.

Fastly falls back to the S3 mirror on a per-request basis, so even intermittent unavailability or partial outages limited to specific GOV.UK features can result in user traffic being served from mirrors. In practice, even on a good day there is still a tiny proportion of user traffic which is served from the mirrors.

The static mirrors are a key part of GOV.UK's business continuity plan. It's very important that they are up-to-date in case of an outage. This [overview of how the mirrors are created and used](/manual/fall-back-to-mirror.html) gives more context.

## Troubleshooting

You can see [stats in Graphite](https://graphite.production.govuk.digital/dashboard/mirror_sync) of how long recent runs of govuk_sync_mirror have been taking.

Check the syslog logs on the `mirrorer` machine for any errors.

```
grep govuk_sync_mirror /var/log/syslog
```

Check that the `govuk_sync_mirror` cron job exists.

```
sudo crontab -lu govuk-crawler
```

Check whether there is a job currently running. The `ps` output shows the start time (`12:00` in this example).

```
$ ps auxww |grep govuk_sync_mirror
govuk-c+  5220  0.0  0.0   4452   684 ?        Ss   12:00   0:00 /bin/sh -c /usr/bin/setlock -n /var/run/govuk_sync_mirror.lock /usr/local/bin/govuk_sync_mirror
govuk-c+  5221  0.0  0.0  11168  2984 ?        S    12:00   0:00 bash /usr/local/bin/govuk_sync_mirror
```

The job typically takes between 1 and 12 hours to run, depending on how much new/changed content there is. It's very slow because it uses `s3cmd sync`, which (unlike `aws s3 sync`) does not parallelise uploading the files to S3.

If need be, try running the script manually. Unfortunately it doesn't normally produce any output; you will need to check `/var/log/syslog` for this. You may want to run the following in a `screen` or `tmux` session as the sync job can take several hours.

```
# Switch to the right user
sudo -iu govuk-crawler

# Look at the govuk-crawler user's crontab to find the command to run.
crontab -l

# Run the command. For example:
/usr/bin/setlock -n /var/run/govuk_sync_mirror.lock /usr/local/bin/govuk_sync_mirror
```

If it aborts straight away, double-check whether there is already a job running.

```
$ sudo lsof /var/run/govuk_sync_mirror.lock
COMMAND  PID          USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
bash    5221 govuk-crawler    3wW  REG   0,19        0  348 /run/govuk_sync_mirror.lock
s3cmd   5233 govuk-crawler    3w   REG   0,19        0  348 /run/govuk_sync_mirror.lock
```

## The static mirror has not been updated in n seconds

This alert means that the S3 static mirror has not been updated for over 24h. The govuk_sync_mirror script [writes a file](https://github.com/alphagov/govuk-puppet/blob/fffb8bbde66a0af7f18a75b837ae3090f95488e0/modules/govuk_crawler/templates/govuk_sync_mirror.erb#L44) to the S3 mirror bucket every time it runs, this alert checks when that file was last modified.
