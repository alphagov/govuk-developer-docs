---
title: Clone a MySQL instance from one slave to another
section: Databases
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/infrastructure/howto/clone-mysql-slave.md"
---



> **This page was imported from [the opsmanual on github.gds](https://github.gds/gds/opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.gds/gds/opsmanual/tree/master/infrastructure/howto/clone-mysql-slave.md)


# Clone a MySQL instance from one slave to another

This tutorial documents the process behind adding a new slave to a MySQL
senvironment where an existing slave may or may not already exist. The
process involves cloning data from an existing replication slave on to a
new slave, thus keeping the replication configuration intact. After the
initial synchronisation from the existing to the new slave, both the new
and existing slaves will replicate directly from the master.

## Conventions

In this how-to, we're using...

`slave$` to denote commands to be run on the existing slave

`slave:mysql>` to denote commands to be run in the original slave's
MySQL CLI

`backup$` to denote commands to be run on the new slave

`backup:mysql>` to denote commands to be run in the new slave's MySQL
CLI

## Overview

1.  Lock the original slave, preventing writes to it
2.  Copy the data from original slave to your folder on the new slave
3.  Unlock the original slave and tidy up
4.  Move the data on the new slave
5.  Start the new slave

## 1. Lock the original slave to prevent writes

First, find out the MySQL root password. This is in hieradata in the
deployment repo.

Open an SSH connection to slave (this connection will remain open for
the duration of the operation so it makes sense to do it in screen or
tmux):

    slave$: mysql -u root -p
    Password:

We need to stop MySQL slaving on the original slave - the master host
need not be touched as we are replicating data from existing to new
slave. Once done, we need to then flush the tables and apply a read lock
to ensure no new data is written during the period we are copying data
from the existing to the new slave. Issue the following commands to
MySQL:

    slave:mysql> SLAVE STOP;
    slave:mysql> FLUSH TABLES WITH READ LOCK;

At this point, the connection \_must\_ remain open and in MySQL, so
switch to a new console and login to the slave again via SSH.

## 2. Copy the data from the original slave to your directory on the new slave

On your second terminal, login to the original MySQL slave again.

You are going to need to temporarily copy your SSH Private Key
.ssh/id\_rsa to your home directory on the original slave server.
There's no easy way around this, as while we can forward the SSH agent
from your personal machine to the original server, we're going to be
running the SSH command as root which will need access to your key. Make
sure the file is chmod 0600 otherwise SSH will fail.

Once you have done that, copy the entire contents of /var/lib/mysql from
the original server to your home directory on the new server:

    sudo rsync --delete --exclude 'relay-log.info' --exclude 'mysql-bin*' --exclude 'mysql-slave*' -Wavze "ssh -i /home/username/.ssh/id_rsa" /var/lib/mysql/ username@mysql-backup-1:mysql

> **note**
>
> -a is archive mode, which is - in essence - a shortcut to using '-r -l -p -t -g -o -D', which are common switches used during backups.
>
> :   -v is versbose -P shows progress during the transfer -h makes the
>     output from rsync human-readable --stats tells rsync to report on
>     the connection speed and such. Progress is already reported
>     using -P.
>
Sometimes, for some unknown reason, rsync will fail to copy across all
of the data. This manifests itself as MySQL complaining when you run
`SHOW SLAVE STATUS\G` in a MySQL prompt that it could not find certain
tables.

Both rsync and tarball/scp methods take some time - possibly a number of
hours.

## 3. Unlock the original slave and tidy up

When it is finished, switch back to your first terminal. You should
still be at the MySQL prompt. Unlock it:

    slave:mysql> UNLOCK TABLES;
    slave:mysql> SLAVE START;

The original slave should then begin to catch up with master. You can
monitor this with:

    slave:mysql> SHOW SLAVE STATUS\G

You should see that seconds\_behind\_master drops to 0.

> **warning**

> DO NOT FORGET TO REMOVE YOUR SSH PRIVATE KEY FROM THE SLAVE!

## 4. Move the data on the new slave

Login to the new slave server via SSH and stop MySQL:

    backup$: govuk_puppet --disable
    backup$: sudo service mysql stop

Delete the original MySQL data:

    backup$: sudo rm -rf /var/lib/mysql

Move the mysql directory from your Home Directory to /var/lib:

    backup$: sudo mv ~/mysql /var/lib/
    backup$: sudo chown -R mysql:mysql /var/lib/mysql

## 5. Start the new slave

Start MySQL and Puppet:

    backup$: sudo service mysql start
    backup$: govuk_puppet --enable

Login to MySQL:

    backup$: mysql -uroot -p
    Password: <the root password from the original slave>
    backup:mysql> SHOW SLAVE STATUS\G

You should see:

    Slave_IO_Running: yes
    Slave_SQL_Running: yes
    Seconds_Behind_Master: <should be decreasing to 0>

## 6. Conclusion

You should now have two replication slaves, both with data, replicating
the master. The process above can be used for any new replication slaves
you wish to add in future. As you are copying the `/var/lib/mysql` dir
from an existing replication slave, there are no configuration
amendments required. The slave will simply use the configuration copied
from the existing slave to replicate from the master.
