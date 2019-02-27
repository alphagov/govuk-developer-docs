---
owner_slack: "#govuk-data-informed"
title: Upgrade PostgreSQL to 9.6 in the Development VM
section: Development VM
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-02-22
review_in: 3 months
---

Currently, a mixture of PostgreSQL versions are in use on GOV.UK. In
November, the default for the development VM changed from 9.3 to 9.6.

You may see the following output from govuk-puppet:

```
Error: /Stage[main]/Postgresql::Server::Service/Service[postgresqld]: Failed to call refresh: Could not start Service[postgresqld]: Execution of '/etc/init.d/postgresql start' returned 1: * Starting PostgreSQL 9.3 database server
   ...done.
 * Starting PostgreSQL 9.6 database server
 * Error: Port conflict: another instance is already running on /var/run/postgresql with port 5432
   ...fail!
Error: /Stage[main]/Postgresql::Server::Service/Service[postgresqld]: Could not start Service[postgresqld]: Execution of '/etc/init.d/postgresql start' returned 1: * Starting PostgreSQL 9.3 database server
   ...done.
 * Starting PostgreSQL 9.6 database server
 * Error: Port conflict: another instance is already running on /var/run/postgresql with port 5432
   ...fail!
```

This means that PostgreSQL 9.6 is now installed, but not running
yet. You can still continue to use 9.3, but upgrading to 9.6 is
recommended. It's possible to do this without reloading any data.

## Upgrading to 9.6

To upgrade to Postgresql 9.6, follow the steps below.

 - Stop bowl, any rails consoles and anything else using PostgreSQL.
 - In the development VM, run the following commands:
   - `sudo pg_dropcluster 9.6 main --stop`
   - `sudo pg_upgradecluster --method=upgrade --link 9.3 main`
   - `sudo pg_dropcluster 9.3 main`
