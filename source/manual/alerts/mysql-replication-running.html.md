---
owner_slack: "#govuk-2ndline"
title: 'MySQL: replication running'
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

Checks whether `Slave_IO_Running` and `Slave_SQL_Running` both return
`Yes` to indicate that replication is currently active. As described in
the MySQL documentation:

> `Slave_IO_Running`: Whether the I/O thread for reading the master's
> binary log is running. Normally, you want this to be Yes unless you
> have not yet started replication or have explicitly stopped it with
> STOP SLAVE.
>
> `Slave_SQL_Running`: Whether the SQL thread for executing events in
> the relay log is running. As with the I/O thread, this should normally
> be Yes.

To check the status of the slave,

1. Log onto the server (e.g. `mysql-backup-1.backend.integration`)
2. Open a MySQL shell:

    ```
    sudo -i mysql
    ```

3. Run:

    ```sql
    mysql> SHOW SLAVE STATUS \G
    ```
