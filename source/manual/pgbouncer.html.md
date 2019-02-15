---
owner_slack: "#govuk-2ndline"
title: PgBouncer
section: Databases
type: learn
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-08-14
review_in: 6 months
---

[PgBouncer](https://pgbouncer.github.io/) sits between our apps and postgresql.  It performs
connection pooling, and can also treat databases on remote hosts as if they were local.  From the
perspective of an app, it is talking to a regular postgresql server.


## Where it lives

* In Carrenza, it lives on `postgresql-primary-1.backend`
* In AWS, it lives on `db-admin`

The [content-performance-manager](/apps/content-performance-manager.html),
[mapit](/apps/mapit.html), and [transition](/apps/transition.html) apps use their own database
servers, and do not connect through pgbouncer.
