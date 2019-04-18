---
owner_slack: "#govuk-2ndline"
title: Resync a PostgreSQL standby
section: Databases
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-04-18
review_in: 6 months
---
If you see those types of errors in the postgresql logs on the standby :

```
2019-04-08 05:56:43 UTC FATAL:  could not receive data from WAL stream: ERROR:  requested WAL segment 000000010000218
C000000FA has already been removed
```

Then the replication between primary and standby is broken, if standby is not too far behind it is possible to catch up with primary and repair the replication by using the WAL that are archived on S3.

Put the following line in /var/lib/postgresql/9.3/main/recovery.conf :

```
restore_command = 'envdir /etc/wal-e.d/env.d /usr/loca/bin/wal-e wal-fetch %f %p'
```

[Remove the password](https://docs.publishing.service.gov.uk/manual/postgresql.html) that protect the gpg key with which the WAL are encrypted.
Restart the standby postgresql server.
You should see the WAL being processed in the postgresql logs, at the end of the process the server should be back in sync.
Restore the password on the gpg key.

If this method fails, standby is probably now too far behind and you will need to restore a base backup using pg_resync_slave 
Note that you might run out of disk space on the standby while doing this, if this happen you will need to temporarily [add more disks](https://docs.publishing.service.gov.uk/manual/adding-disks-in-vcloud.html) to the standby vm 
To resync a standby from a primary run this on the affected standby:

```
sudo pg_resync_slave
```

It will ask you for a password. You can find this in the password store under `govuk::node::s_postgresql_primary::standby_password`.

You will see something like this:

```
vagrant@postgresql-standby-1:~$ sudo pg_resync_slave
36237/36237 kB (100%), 1/1 tablespace
pg_basebackup: base backup completed
 * Stopping PostgreSQL 9.3 database server                                 [ OK ]
 * Starting PostgreSQL 9.3 database server                                 [ OK ]
```

You can get a quick view of postgresql's [wal](https://www.postgresql.org/docs/9.1/wal-intro.html) by doing the following:

on a `postgresql-primary`: `ps -ef | grep sender`

on a `postgresql-standby`: `ps -ef | grep receiver`

## Restarting collectd

If you are resyncing because the standby has fallen too far behind primary,
you might need to restart `collectd` on the standby machine to resolve the
incinga alerts:

```
sudo service collectd restart
```
