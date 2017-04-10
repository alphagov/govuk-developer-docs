---
title: Recovering from the loss of Elasticsearch machines
section: disaster-recovery
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/infrastructure/disaster-recovery/elasticsearch.md"
---



> **This page was imported from [the opsmanual on github.gds](https://github.gds/gds/opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.gds/gds/opsmanual/tree/master/infrastructure/disaster-recovery/elasticsearch.md)


# Recovering from the loss of Elasticsearch machines

Applications that depend on Elasticsearch will no longer be able to use the database.

## Elasticsearch Cluster

Each Elasticsearch cluster is comprised of three machines. There is no concept of a
"primary" and "secondary", and to interact Elasticsearch you use an API.

