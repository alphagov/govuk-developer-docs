---
title: Recovering from the loss of asset machines
section: disaster-recovery
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/infrastructure/disaster-recovery/asset-master.md"
---



> **This page was imported from [the opsmanual on github.gds](https://github.gds/gds/opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.gds/gds/opsmanual/tree/master/infrastructure/disaster-recovery/asset-master.md)


# Recovering from the loss of asset machines

An asset master machine contains attachments which are used within some
publishing applications (notably the Whitehall application). Assets are both
uploaded and served from this machine. If this machine become unavailable, then
it is imperative the data is not lost and can be made available again in an
acceptable timeframe.

## Asset machine set-up

There is a single asset master machine, and two asset slave machines, with one
being within the DR environment. Whenever an asset is uploaded to the master,
it is virus scanned and copied across to both asset slaves via rsync. There is
a daily sync which also is completed every morning to ensure that the data is
consistent across all machines.

## Asset master machine outage

In the event of losing the asset master, one would need to repoint the DNS at
the slave to allow access to the assets. New uploads would not be correctly
processed unless a new asset master was provisioned.

