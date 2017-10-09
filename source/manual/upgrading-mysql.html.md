---
owner_slack: "#2ndline"
title: Upgrade MySQL
parent: "/manual.html"
layout: manual_layout
section: Databases
last_reviewed_on: 2017-10-09
review_in: 6 months
---

Upgrading MySQL will cause 500 errors on sites as the master and slave
machines are restarted, so this procedure needs to be done at a suitable
time on production - i.e outside of core business hours (9:00 - 18:00
Monday to Friday)

It is safe to reboot the \_backup and \_slave-2 machines on production
as they are not actively used by sites and will not cause 500 errors

The following Puppet classes will need upgrading

MySQL cluster:

> mysql\_backup
>
> mysql\_slave
>
> mysql\_master

Whitehall cluster:

> whitehall\_mysql\_backup
>
> whitehall\_mysql\_slave
>
> whitehall\_mysql\_master

To do the upgrade, use this Fabric command

`fab $environment -H <hostname> sdo:"apt-get install mysql-server-5.5"`

Its best to do the backup machines first, followed by second slave,
first slave and then the master.

Before upgrading the master it is best to stop the slow query logs on
the slaves. This can be done with the following Fabric command (or a
similar one replacing the classes for Whitehall). Only do this on
staging and integration -slow query logs are not enabled in production

`fab $environment class:mysql_backup class:mysql_slave mysql.stop_slow_query_log`

The upgrade task can then be run on the master. Stopping the slow query
log should allow replication to continue - if alerts occur about
replication not running, then run the following Fabric task

`fab $environment class:mysql_backup class:mysql_slave mysql.fix_replication_from_slow_query_log_after_upgrade`

Once the master has safely upgraded and replication is running, then
turn the slow query log back on - Only do this on staging and
integration -slow query logs are not enabled in production

`fab $environment class:mysql_backup class:mysql_slave mysql.start_slow_query_log`
