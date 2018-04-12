---
owner_slack: "#2ndline"
title: Offsite backups
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2018-04-12
review_in: 6 months
---

All of our offsite backups use duplicity. Most, but not all, are
encrypted using GPG.

If a backup fails then start by looking at any output captured by
cron and sent to the "machine email" list. This is linked from the
Nagios alert under "extra actions".

If the backup hasn't failed but is flagged with a freshness warning, it may still be in progress. The asset stores are large and backups can take a long time, check whether the duplicity process is still running (e.g. using `htop` or `ps aux | grep duplicity`).

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

You can look for output of the backup jobs in the
"machine email carrenza" google group. If the log contains the line
`"Warning, found the following orphaned backup files` then try running
the command
`sudo -iugovuk-backup duplicity cleanup <destination>  --no-encryption --force`

If a backup fails part way through (eg. if the disk runs out of space),
then subsequent backups will also fail since duplicity will attempt
to ask for a GPG passphrase interactively and fail. The output of jobs
that have failed for this reason will end with an `EOFError` message.
In these cases, you will need to run the backup again manually, and
provide the passphrase when asked. The passphrase is contained in the
`backup::assets::backup_private_gpg_key_passphrase` key in
[govuk-secrets](https://github.com/alphagov/govuk-secrets/blob/master/puppet/hieradata/production_credentials.yaml).
