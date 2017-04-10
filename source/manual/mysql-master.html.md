---
title: Recovering from the loss of a MySQL master
section: disaster-recovery
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/infrastructure/disaster-recovery/mysql-master.md"
---



> **This page was imported from [the opsmanual on github.gds](https://github.gds/gds/opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.gds/gds/opsmanual/tree/master/infrastructure/disaster-recovery/mysql-master.md)


# Recovering from the loss of a MySQL master

If a MySQL master machine becomes unavailable, applications will no longer be able to write data.
This will result in publishers being unable to update content on GOV.UK

## MySQL clusters

Each group of MySQL machines has a master (to receive writes), at least one slave (for applications
to read from) and a backup machine (where backups are taken from).

Applications are configured to write to a host of the form `master.mysql` or `whitehall-master.mysql`
which is configured in Puppet's hieradata.

## MySQL master outage

If a MySQL master machine becomes unavailable there are 2 approaches that will restore service:

- Create a new MySQL master and restore data onto it from the slave or backup machine
- Promote the slave to be a master and change DNS to ensure that applications write to the
  promoted machine

