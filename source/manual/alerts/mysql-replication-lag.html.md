---
owner_slack: "#govuk-2ndline"
title: 'MySQL: replication lag'
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

Checks the value of `Seconds_Behind_Master` to a threshold. As described
in the MySQL documentation:

> Seconds_Behind_Master: The number of seconds that the slave SQL
> thread is behind processing the master binary log. A high number (or
> an increasing one) can indicate that the slave is unable to handle
> events from the master in a timely fashion.

This is unable to reliably detect when replication is completely stopped
or broken. In such an event, it will return a NULL value and raise an
UNKNOWN alert. This should correlate with a CRITICAL alert for 'mysql
replication running'.

If `Seconds_Behind_Master` shows as `NULL`, you may be able to fix
replication by running the `mysql.reset_slave` Fabric task:

```
fab $environment -H <mysql_slave_hostname> mysql.reset_slave
```

An alert for 'MySQL replication lag' on mysql-backup-* machines may be
caused by a database backup or a Jenkins data synchronisation job. You can
verify this by checking for a running mysqldump process on the
affected host, e.g.:

```
ps auxwww | grep mysqldump
```

In such cases, the alert should return to normal once the backup
completes.

If replication is completely broken and the `mysql.reset_slave` Fabric
task didn't help, there is a
[`mysql.replicate_slave_from_master`](https://github.com/alphagov/fabric-scripts/search?q=replicate_slave_from_master)
Fabric task which reinitialises the replica from scratch by running a dump/restore.
