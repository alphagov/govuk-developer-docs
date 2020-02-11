---
owner_slack: "#govuk-developers"
title: PgBouncer
section: Databases
type: learn
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-10-21
review_in: 3 months
---

[PgBouncer](https://pgbouncer.github.io/) sits between our apps and PostgreSQL.
It performs connection pooling, and can also treat databases on remote hosts as
if they were local. From the perspective of an app, it is talking to a regular
PostgreSQL server.

## Where it lives

* In Carrenza, it lives on `postgresql-primary-1.backend`
* We do not use pgbouncer in AWS

The [content-data-api](/apps/content-data-api.html),
[mapit](/apps/mapit.html), and [transition](/apps/transition.html)
apps use their own database servers, and do not connect through PgBouncer.
