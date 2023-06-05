---
owner_slack: "#govuk-developers"
title: Deploy Static
section: Deployment
layout: manual_layout
parent: "/manual.html"
---

Before rolling out a release of Static to production, you must:

1. Deploy the Static release to staging.
1. Check that the deployment succeeded, for example by checking the last synced
   time in [Argo
   CD](https://argo.eks.staging.govuk.digital/applications/static)).
1. Wait 10 minutes.
1. Check that the next Smokey run passes in staging. Ignore any Smokey run that
   started less than 5 minutes after the Static rollout, because it may have
   received responses cached before the rollout.
1. Double-check that the homepage looks OK and click around a couple of pages
   on the site.

## Why?

[Static](https://github.com/alphagov/static) requires extra care when
deploying, because serves partial pages (for example the header and footer)
that are cached and reused by many of the frontend rendering apps via the
[Slimmer](https://github.com/alphagov/slimmer/) library.

Releases of Static are not automatically promoted to the staging and production
environments. This is because:

- the smoke tests do not currently take into
  account the caching of Static's responses by the frontend apps
- Static does not yet have sufficient test coverage

Why 10 minutes? Slimmer caches Static's responses for up to 1 minute by default.
Argo CD polls GitHub for changes every 3 minutes. The rollout itself (within
Kubernetes) typically takes another minute. The HTTP `cache-control: max-age`
for most pages is 5 minutes. The smoke tests defeat the edge cache where
appropriate, so the last 5 minutes really only matters for manual testing.
