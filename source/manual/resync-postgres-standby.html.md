---
owner_slack: "#2ndline"
title: Resync a PostgreSQL standby
section: Databases
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-03-06
review_in: 6 months
---

To resync a standby from a primary run this on the affected standby:

```
sudo pg_resync_slave
```

You will see something like this:

```
vagrant@postgresql-standby-1:~$ sudo pg_resync_slave
Password:
36237/36237 kB (100%), 1/1 tablespace
pg_basebackup: base backup completed
 * Stopping PostgreSQL 9.3 database server                                 [ OK ]
 * Starting PostgreSQL 9.3 database server                                 [ OK ]
```

You can get the password from encrypted hieradata.

You can get a quick view of postgresql's wal by doing the following:

on a `postgresql-primary`: `ps -ef | grep sender`

on a `postgresql-standby`: `ps -ef | grep receiver`

## Restarting collectd

If you are resyncing because the standby has fallen too far behind primary,
you might need to restart `collectd` on the standby machine to resolve the
incinga alerts:

```
sudo service collectd restart
```
