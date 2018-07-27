---
owner_slack: "#govuk-2ndline"
title: URLs in data sync failed to munge
section: Icinga alerts
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-06-25
review_in: 3 months
---

As part of the data syncs, the router data should update to point to the relevant environment.

If this fails, then on integration for example, apps will appear to be broken - you'll likely see `cache-1.router.integration.publishing.service.gov.uk;5xx rate for www-origin` alerts and 5xx's for frontend apps.

Check URLs in router-api by SSHing onto a machine with router-api (router-backend for live stack; draft-cache for draft stack) and running the following commands:

```
govuk_app_console router-api

pp Backend.pluck(:backend_url)
```

If most of the URLs don't have `integration` or `staging` then the `scripts/router-munge-hostnames.sh` in `env-sync-and-backup` repo failed for some reason.

A quick fix is to run the following rake task for the content-store and draft-content via jenkins:

`register_backends`
