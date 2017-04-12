---
title: 'MySQL replication checks'
parent: /manual.html
layout: manual_layout
section: Icinga alerts
---

# MySQL replication checks

There are two checks for MySQL replication:

### 'mysql replication lag'

Checks the value of `Seconds_Behind_Master` to a threshold. As described
in the MySQL documentation:

> Seconds\_Behind\_Master: The number of seconds that the slave SQL
> thread is behind processing the master binary log. A high number (or
> an increasing one) can indicate that the slave is unable to handle
> events from the master in a timely fashion.

This is unable to reliably detect when replication is completely stopped
or broken. In such an event, it will return a NULL value and raise an
UNKNOWN alert. This should correlate with a CRITICAL alert for 'mysql
replication running'.

If `Seconds_Behind_Master` shows as `NULL`, you may be able to fix
replication by running the `mysql.reset_slave` Fabric task:

    fab $environment -H <mysql_slave_hostname> mysql.reset_slave

<div class="admonition note">

An alert for 'MySQL replication lag' on mysql-backup-\* machines may be
caused by a database backup or a Jenkins data synchronisation job, such
as:

> <https://deploy.publishing.service.gov.uk/job/Copy_Data_to_Staging/>

You can verify this by checking for a running mysqldump process on the
affected host, e.g.:

    ps auxwww | grep mysqldump

In such cases, the alert should return to normal once the backup
completes.

</div>

### 'mysql replication running'

Checks whether `Slave_IO_Running` and `Slave_SQL_Running` both return
`Yes` to indicate that replication is currently active. As described in
the MySQL documentation:

> Slave\_IO\_Running: Whether the I/O thread for reading the master's
> binary log is running. Normally, you want this to be Yes unless you
> have not yet started replication or have explicitly stopped it with
> STOP SLAVE.
>
> Slave\_SQL\_Running: Whether the SQL thread for executing events in
> the relay log is running. As with the I/O thread, this should normally
> be Yes.

To check the status of the slave,

1.  Log onto the server (e.g. mysql-backup-1.backend.integration).
2.  Open a mysql shell:

> `sudo -i mysql`

3.  Run:

> `mysql> SHOW SLAVE STATUS \G`

### 'Relay log read failure: Could not parse relay log event entry'

This can happen if the relay log file is corrupted. To check this, run
`SHOW SLAVE STATUS` and find the value for `Relay_Log_File` - it will be
something like `mysql-backup-1-relay-bin.000XXX` where `mysql-backup-1`
is replaced by the name of the server on which replication is broken.
Run `mysqlbinlog <relay-log-file> > /dev/null`

if this results in error messages being displayed, the log file is
corrupted and you should try

Find the current relay log position - the value for `Relay_Log_Pos:` in
the `SHOW SLAVE STATUS` output

From a mysql command prompt -

`SLAVE STOP;`

`change master to master_log_file='<relay_log_file>',master_log_pos=<relay_log_pos>;`

`SLAVE START;`

You should then see `SHOW SLAVE STATUS` output return to normal.

More details in -
[<http://alexzeng.wordpress.com/2013/10/17/how-to-fix-mysql-slave-after-relay-log-corrupted/>](http://alexzeng.wordpress.com/2013/10/17/how-to-fix-mysql-slave-after-relay-log-corrupted/)

