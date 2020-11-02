---
owner_slack: "#re-govuk"
title: Fix Mapit database not available
layout: manual_layout
parent: "/manual.html"
section: Databases
last_reviewed_on: 2020-11-02
review_in: 6 months
---

Each Mapit machine has its own PostgreSQL database which powers the Mapit
application. When the machine is first created by AWS, the latest data is
[supposed to be imported into the database][autoimport].

[autoimport]: https://github.com/alphagov/govuk-puppet/pull/9657

This feature is currently not working which means that new Mapit machines are
not added to the load balancer until the data has been imported manually. There
will also be numerous errors in Icinga related to 5xx errors and events in
Sentry:

```
OperationalError: could not connect to server: Connection refused
        Is the server running on host "127.0.0.1" and accepting
        TCP/IP connections on port 5432?
```

> RE are aware that the automatic import process doesn't work.

## Manual process

SSH onto the machine which is experiencing the problem and run the following
comments:

1. Stop any running PostgreSQL instance

   ```sh
   $ ps aux | grep postgresql
   $ sudo kill -9 <pid>
   ```

1. Recreate the PostgreSQL cluster

   ```sh
   $ sudo pg_dropcluster --stop 9.3 main; sudo pg_createcluster 9.3 main
   ```

1. Run Puppet

   ```sh
   $ govuk_puppet --test
   ```

1. Check that PostgreSQL is up and running correctly

   ```sh
   $ sudo service postgresql status
   ```

1. Make the import script available

   ```sh
   $ wget https://raw.githubusercontent.com/alphagov/govuk-puppet/master/modules/govuk/files/etc/govuk/import_mapit_data.sh
   $ chmod +x import_mapit_data.sh
   ```

1. Run the import script

   ```sh
   $ sudo ./import_mapit_data.sh
   ```

   The import script will take about 10 minutes to run. Sometimes your SSH
   connection might time out while the script runs, it's worth checking on the
   terminal every few minutes to check that hasn't happened. Once Mapit is
   healthy, the AWS load balancer will automatically detect this and add the
   machine into the rotation.
