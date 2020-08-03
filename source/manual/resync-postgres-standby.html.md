---
owner_slack: "#re-govuk"
title: Resync a PostgreSQL Standby in Carrenza/6DG
section: Databases
layout: manual_layout
parent: "/manual.html"
---

If there is a need to resync the Postgresql standby machine from its primary,
there are 2 methods:

1. restore from the WAL-E backups stored in S3 (recommended new method)

2. use the command pg_resync_slave (older method that may not work)

## Resync methods

### Restore from WAL-E Backups stored in S3

Follow the following steps on the Postgresql standby machine:

1. Disable puppet by running:

   ```
   govuk_puppet --disable "resyncing postgresql from wal-e S3 backups"
   ```

2. Follow the steps in this [doc](/manual/postgresql-backups.html#wal-e-failing-with-errors-about-gpg)
   to remove the password from the GPG key so that the WAL-E restoration process
   can automatically decrypt the backups from S3.

   The passphrase is in the pass store of the GOV.UK secrets under:
   `postgresql-backups/<environment>/postgresql-primary`
   where `<environment>` is the GOV.UK environment where you are doing the restoration.

3. Edit the file `/var/lib/postgresql/9.3/main/recovery.conf` by appending the
   following line:

   ```
   restore_command = 'envdir /etc/wal-e/env.d /usr/local/bin/wal-e wal-fetch %f %p'
   ```

4. Restart Postgresql service by running:

   ```
   sudo /etc/init.d/postgresql restart
   ```

5. Tail the log to see if the process of restoration is working and when
   it has finished. Run:

   ```
   tail -f /var/log/postgresql/postgresql-9.3-main.log
   ```

6. After the restoration has finished, remove the appended line from `/var/lib/postgresql/9.3/main/recovery.conf` and restart Postgresql:

   ```
   sudo /etc/init.d/postgresql restart
   ```

7. **Re-protect the GPG key**. Reset the passphrase from a blank value to use the original GPG passphrase by following the steps in this [doc](/manual/postgresql-backups.html#wal-e-failing-with-errors-about-gpg).

8. You can restart `collectd` by following the steps in the [Restarting collectd section](#restarting-collectd).

9. Re-enable puppet:

   ```
   govuk_puppet --enable
   ```

### Using the command pg_resync_slave

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
