---
owner_slack: "#govuk-developers"
title: Copy PostgreSQL dump from one machine to another
section: Databases
layout: manual_layout
parent: "/manual.html"
---

This document explains how to back up a PostgreSQL database from one machine
and import it to another machine (or even another environment).

## Back up your PostgreSQL database

Firstly, SSH into the machine running the PostgreSQL instance you want to copy.
Then become the PostgreSQL user (it shouldn't need a password):

```sh
sudo su - postgres
```

This will change your directory to `/var/lib/postgresql`.

Find the name of the database you want to back up. Start the PostgreSQL console
(`psql`), then list the databases (`\l`) if you're not sure.

Then create a dump:

```sh
pg_dump name_of_database > /tmp/name_of_database.bak
```

Return to being a normal user on the instance:

```sh
exit
```

Now fix the permissions so that you own it:

```sh
sudo chown $(whoami):$(whoami) /tmp/name_of_database.bak
```

Now `exit` the instance and move on to the next step.

## Download the backup to your local machine

Use `govuk-connect` to download the file. For example:

```sh
gds govuk connect scp-pull -e <environment> <ip> /tmp/name_of_database.bak
```

## Upload your backup to the desired machine

Use `govuk-connect` to upload the file. For example:

```sh
gds govuk connect scp-push -e <environment> <ip> name_of_database.bak /tmp
```

## Import the backup to overwrite your PostgreSQL database

SSH into the machine, and then move the backup away from `/tmp`:

```sh
sudo mv /tmp/name_of_database.bak /var/lib/postgresql/
```

Pass ownership over to the PostgreSQL user:

```sh
sudo chown postgres:postgres /var/lib/postgresql/name_of_database.bak
```

Stop any services that are relying on the database, e.g.:

```sh
sudo service mapit stop
```

Assume the PostgreSQL user role:

```sh
sudo su - postgres
```

Remove active connections on the database:

```sh
$ psql
postgres=# REVOKE CONNECT ON DATABASE name_of_database FROM public;
postgres=# SELECT pg_terminate_backend(pg_stat_activity.pid)
           FROM pg_stat_activity
           WHERE pg_stat_activity.datname = 'name_of_database';
```

Drop the database and create a new one in its place:

```sh
postgres=# DROP DATABASE name_of_database; CREATE DATABASE name_of_database;
```

Import new database:

```sh
$ psql -d name_of_database -f name_of_database.bak
```

Return to being a normal user on the instance:

```sh
exit
```

Restart database (to re-allow public connections):

```sh
sudo service postgresql restart
```

Restart whatever services you stopped, e.g.:

```sh
sudo service mapit start
```

Tidy up after yourself:

```sh
sudo rm /var/lib/postgresql/name_of_database.bak
```
