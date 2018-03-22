---
owner_slack: "#2ndline"
title: Offsite backups
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2017-03-22
review_in: 6 months
---

All of our offsite backups use duplicity. Most, but not all, are
encrypted using GPG.

If a backup fails then start by looking at any output captured by
cron and sent to the "machine email" list. This is linked from the
Nagios alert under "extra actions".

If the backup hasn't failed but is flagged with a freshness warning it may still be in progress. The asset stores are large and backups can take a long time, check whether the duplicity process is still running (e.g. using `htop` or `ps aux | grep duplicity`).

To proceed further you will need to know a few things which you can
determine either from the job configuration in Puppet or by listing
crontabs for users, eg. `sudo crontab -lu govuk-backup`:

1. the user that the backup normally runs as, eg. `govuk-backup` or
    `root`.
2. the script that is run, eg. `/var/spool/duplicity/<job>.sh`.
3. the destination for the backup, eg. `rsync://<user>@<host>:/<path>`
4. the archive directory used as a local cache, eg.
    `/data/backups/.cache/duplicity`

> The `sudo -i` in these commands is important because it prevents GPG
from using keyrings in your own user's home directory.

Start by checking the status of the destination to see what backups
succeeded recently:

    sudo -iu <user> duplicity collection-status --archive-dir <archive_directory> <destination>

You can try running the backup again manually. This may take some time
so it's recommended to use `tmux` or `screen`:

    sudo -iu <user> /var/spool/duplicity/<script>

You can look for output of the backup jobs in the "machine email plat1"
google group. If the log contains the line
`"Warning, found the following orphaned backup files` then try running
the command
`sudo -iugovuk-backup duplicity cleanup <destination>  --no-encryption --force`
