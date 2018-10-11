---
owner_slack: "#govuk-2ndline"
title: PostgreSQL backups
section: Backups
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-07-31
review_in: 3 months
---

## WAL-E Backups to S3

We use [WAL-E](https://github.com/wal-e/wal-e) to do continuous archiving to an Amazon S3 bucket. PostgreSQL uses a method of [archiving](https://www.postgresql.org/docs/9.3/static/continuous-archiving.html)
transaction logs: this means that transaction logs are copied to a place on disk, and are rotated by a set amount of time or disk usage.

WAL-E uses this function and makes it easy to upload the archived logs to a different location, using environmental variables to specify
where the logs should go. It also specifies encryption details.

The archived transactions logs are based upon a "base" backup, which is taken every night. By default we rotate a new transaction log every 5 minutes, so in theory
we can recover point in time backups to specific time and dates in this timeframe.

To restore we can use the commands specified in the WAL-E documentation: `backup-fetch` and `wal-fetch`. To make this easier, a script has been written to automate the
restore of the very latest backup available (`/usr/local/bin/wal-e_restore`). The environmental variables which define the AWS credentials will need to be present.

### WAL-E failing with errors about GPG

WAL-E does not work with password-protected GPG secret keys, but ours
are.  If backup restoration is failing with errors about GPG or things
not being the expected format (eg, complaining that a file doesn't
have a valid lzo or tar header), the key may be password-protected.

You can edit the key in-place to remove the password:

```
$ sudo cat /etc/wal-e/env.d/WALE_GPG_KEY_ID
$ sudo -iu postgres gpg --edit-key <key ID>
gpg> passwd
Key is protected.

You need a passphrase to unlock the secret key for
user: <REDACTED>

Enter passphrase: <password from secrets>

Enter the new passphrase for this secret key.

Enter passphrase: <enter>
Repeat passphrase: <enter>

You don't want a passphrase - this is probably a *bad* idea!

Do you really want to do this? (y/N) y

gpg> save
```

## autopostgresqlbackup

This is how PostgreSQL backups have traditionally been taken on the GOV.UK Infrastructure. It is now deprecated. We are continuing to use it as well alongside WAL-E until we are certain that the restores from WAL-E are working ok.

A third-party script called [autopostgresqlbackup](http://manpages.ubuntu.com/manpages/wily/man8/autopostgresqlbackup.8.html)
takes a `pg_dump` every night and stores them on disk on a dedicated mount point on the PostgreSQL primary machines.

The onsite backup machine (backup-1.management) pulls the latest backup and stores it on disk. [Duplicity](http://duplicity.nongnu.org/)
runs each night to send encrypted backups to an S3 bucket.

To restore from this method:

 - Fetch a backup from either the dedicated mount point, the onsite machine or the S3 bucket [using duplicity](restore-from-offsite-backups.html) (to decrypt you may need a password kept in encrypted hieradata).
   - Unzip the file
   - Import into a PostgreSQL primary using `psql <dbname> < <file>`
