---
owner_slack: "#govuk-developers"
title: PostgreSQL Advisory Locks
section: Databases
layout: manual_layout
type: learn
parent: "/manual.html"
last_reviewed_on: 2019-08-28
review_in: 6 months
---

[Advisory locks][pgdocs] are a feature of PostgreSQL to achieve mutual
exclusion between different processes.  This is a session-level
feature: a lock acquired in a transaction will be held until it is
explicitly released or the session ends, even if the transaction is
rolled back.

[pgdocs]: https://www.postgresql.org/docs/9.3/static/explicit-locking.html#ADVISORY-LOCKS

## Apps which use advisory locks

- The email-alert-api uses an advisory lock to prevent concurrent generation of emails in many of its workers, for example the [ImmediateEmailGenerationWorker](https://github.com/alphagov/email-alert-api/blob/master/app/workers/immediate_email_generation_worker.rb).  Not using the lock here can result in duplicate emails being sent out.

- The publishing-api uses an advisory lock to prevent concurrent writes to the content-store in [ContentStoreWriter](https://github.com/alphagov/publishing-api/blob/master/app/clients/content_store_writer.rb).  Not using the lock here can result in overlapping modifications to the same content item.

A complete and up-to-date list can be found using [the GitHub search](https://github.com/search?q=org%3Aalphagov+with_advisory_lock&type=Code).
