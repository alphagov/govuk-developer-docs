---
owner_slack: "#govuk-2ndline"
title: Pingdom Bouncer canary check
parent: "/manual.html"
layout: manual_layout
type: learn
section: Monitoring
---

Bouncer has a canary route at <https://www.direct.gov.uk/__canary__>
which queries all the database tables which Bouncer uses to serve all
responses to users and checks that those tables are not empty. The
canary should return 200; if it doesn't then errors will be being served
to users - see the table below for more details of the errors in each
case.

Possible causes of errors on the canary route include:

- DNS problems for `www.direct.gov.uk` or
  `bouncer.publishing.service.gov.uk` - check Bouncer's Nginx
  logs via the [logit.io dashboard](https://logit.io)
  to see which requests are getting through
- CDN problems resulting in requests for `www.direct.gov.uk` not being
  correctly passed to `https://bouncer.publishing.service.gov.uk`
- `bouncer-*` or `transition-postgresql-slave-1` machines being
  unavailable
- Bouncer's dependencies being missing or having errors in its
  configuration
- [memory leaks in Bouncer](https://graphite.publishing.service.gov.uk/render/?width=600&height=300&target=alias(dashed(constantLine(6442450944)),%22critical%22)&target=alias(dashed(constantLine(4294967296)),%22warning%22)&target=bouncer-*_redirector.processes-app-bouncer.ps_rss&from=-2days)
- the app being unable to connect or authorise to the database
- the database or the required tables being missing or empty
- the `bouncer` role not having `SELECT` privileges on the required tables

The database tables checked by the canary route (in order) and the
effect on requests for transitioned sites of errors when querying them:

  Database table         | HTTP status codes for requests for transitioned sites | |
  -----------------------| -------------------------------|-----------------------
  table name             | when table inaccessible | when table missing data
  `hosts`                | `500` for all requests | `404` for all requests
  `sites`                | `500` for all requests | `500` for all requests
  `mappings`             | `500` for most requests | `404` for most requests
  `whitelisted_hosts`    | `500` for requests which should redirect to non-`*.gov.uk`/`*.mod.uk`/`*.nhs.uk` domains | `501` for those requests
  `organisations`        | `500` for most requests which should<br>serve a 404 or 410 page | `500` for those requests

There are other tables in the `transition_production` database but they
are only used by Transition and not by Bouncer.
