---
title: Recovering from the loss of a PostgreSQL primary
section: disaster-recovery
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/infrastructure/disaster-recovery/postgresql-primary.md"
---



> **This page was imported from [the opsmanual on github.gds](https://github.gds/gds/opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.gds/gds/opsmanual/tree/master/infrastructure/disaster-recovery/postgresql-primary.md)


# Recovering from the loss of a PostgreSQL primary

If a PostgreSQL primary machine becomes unavailable, applications will no
longer be able to read or write data on most applications that require
PostgreSQL.

## PostgreSQL clusters

PostgreSQL clusters tend to consist of a primary machine, with two standby
machines. As a general rule, most applications that use PostgreSQL read and
write from the primary, with the standby being used primarily for data backup
and retention.

The exception to this is the Bouncer application. If Origin is unavailable,
then the CDN failsover to a replica Bouncer application within the DR
environment which is able to handle reads only.

The applications are set up to read from the hostname of the primary machine,
`postgresql-primary-1.backend` as an example.

## PostgreSQL primary outage

If a PostgreSQL primary machine becomes unavailable there are 2 approaches that
will restore service:

   - Create a new PostgreSQL primary and restore data onto it from a standby
     machine
   - Promote the standby to be a primary and change DNS to ensure that
     applications write to the promoted machine. Be aware that if we update DNS
     using Puppet then we would need to ensure that another primary does not come
     up unexpectedly. Some machines may still be trying to write to the original
     which could cause inconsistent data.

