---
owner_slack: "#govuk-2ndline"
title: Offsite backups
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

All of our offsite backups use duplicity. Most, but not all, are encrypted using GPG.

If a backup fails then start by looking at any output captured by cron and sent to the "machine email" list. This is linked from the Nagios alert under "extra actions".

If the backup hasn't failed but is flagged with a freshness warning, it may still be in progress. The asset stores are large and backups can take a long time. Check whether the duplicity process is still running using `htop` or `ps aux | grep duplicity`.

To proceed further you will need to know a few things which you can determine either from the job configuration in Puppet or by listing crontabs for users (`sudo crontab -lu govuk-backup`).

You'll need to know:

1. The user that the backup normally runs as - for example `govuk-backup` or `root`
1. The script that is run - for example `/var/spool/duplicity/<job>.sh`
1. The destination for the backup - for example `rsync://<user>@<host>:/<path>`
1. The archive directory used as a local cache - for example `/data/backups/.cache/duplicity`

> **Important!** The `sudo -i` in the following commands is important because it prevents GPG from using keyrings in your user's home directory.

Start by checking the status of the destination to see what backups succeeded recently:

```bash
sudo -iu <user> duplicity collection-status --archive-dir <archive_directory> <destination>
```

You can try running the backup again manually. This may take some time - so it's recommended to use `tmux` or `screen`:

```bash
sudo -iu <user> /var/spool/duplicity/<script>
```

You can look for output of the backup jobs in the "machine email carrenza" google group. If the log contains the line
`Warning, found the following orphaned backup files` then try running the command

```bash
sudo -iugovuk-backup duplicity cleanup <destination>  --no-encryption --force
```

If a backup fails part way through - for example, this will happen when the disk runs out of space - then subsequent backups will also fail since duplicity will attempt to ask for a GPG passphrase interactively and fail.

The output of jobs that have failed for this reason will end with an `EOFError` message. In these cases, you will need to run the backup again manually, and provide the passphrase when asked.

The passphrase is contained in the `backup::assets::backup_private_gpg_key_passphrase` key in [govuk-secrets](https://github.com/alphagov/govuk-secrets/blob/master/puppet/hieradata/production_credentials.yaml).
