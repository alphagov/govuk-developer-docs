---
owner_slack: "#govuk-web-support"
title: Deploy non-emergency global banner
parent: "/manual.html"
layout: manual_layout
section: Publishing
important: true
---

A site-wide (global) banner can be activated to convey important information on
GOV.UK which is not deemed emergency-level information. Unlike the [emergency
banner](/manual/emergency-publishing.html), we show a user the global banner no
more than 3 times, by storing the view count in a cookie.

The [configuration for the global banner](https://github.com/alphagov/govuk_web_banners/blob/main/config/govuk_web_banners/global_banners.yml) is contained in the govuk_web_banners gem.

## Activate the global banner

1. Follow the instructions in the [govuk_web_banners README.md](https://github.com/alphagov/govuk_web_banners?tab=readme-ov-file#adding-global-banners)
1. Make a minor release of the gem.
1. Allow dependabot to pick up the new gem version. Dependamerger will pick up the PR
   and (since it's a minor version) will generally automerge the change the following
   morning. If you need it sooner, you can force dependabot checks and merge the
   resulting PRs manually.

As shown in the instructions the banner can be configured ahead of time - it must have
a specified start date, but that can be the current date to deploy immediately.

## Troubleshoot the banner

1. If a page isn't showing the banner, check that the deploy of that app with the new gem
   version succeeded, for example by checking when Frontend was last synced in Argo CD
   ([staging](https://argo.eks.staging.govuk.digital/applications/cluster-services/frontend),
   [production](https://argo.eks.production.govuk.digital/applications/cluster-services/frontend)).
1. Make sure you are looking at the same environment where you deployed your
   change to the app.
1. Use a fresh private/Incognito window so that your testing is not affected by
   browser state such as cookies or cache.
1. Wait 5–10 minutes for caches to expire, then repeat the previous step.

If the banner is still not showing, there may be a bug or misconfiguration
somewhere. You might be able to work around the problem temporarily until
the underlying issue is fixed.

1. Try clearing the frontend memcache. Log into the AWS web console for the
   appropriate environment, find [frontend-memcached-govuk under Elasticache,
   Memcached
   clusters](https://eu-west-1.console.aws.amazon.com/elasticache/home?region=eu-west-1#/memcached/frontend-memcached-govuk)
   and press the Reboot button. The UI will ask you to confirm the request.
1. Consider [clearing the page from the CDN
   cache](/manual/purge-cache). Most
   pages expire from the CDN cache within 5 minutes so this is unlikely (though
   not impossible) to be the issue.
