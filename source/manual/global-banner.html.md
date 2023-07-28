---
owner_slack: "#govuk-2ndline-tech"
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

The content of the global banner is contained in
[`app/views/components/_global_bar.html.erb`] in Static.

## Activate the global banner

In [`app/views/components/_global_bar.html.erb`]:

1. Update the variables `title`, `title_href`, `link_href` and `link_text` with
   the relevant info where applicable, otherwise set them to `false`.
1. Change the value of `show_global_bar` to `true`.
1. Optional: set the `always_visible` boolean to `true` if the banner should
   not disappear after being seen 3 times.
1. [Deploy Static]. See the [guidance on deploying Static](/manual/deploy-static.html).

![screenshot](images/global_banner.png)

## Exclude specific pages from showing the banner

The target page linked to from the banner will automatically not show the banner.

To prevent other pages from showing the banner, add them to `urlBlockList` in
`app/assets/javascripts/global-bar-init.js` in Static.

## Update the global banner version

The number of times a user has viewed the banner is stored in a
`global_bar_seen` cookie. Once the view count reaches 3, that user will not see
that banner again, even if new banner content is deployed.

The user will only see the banner again after the third time if either:

- their `global_bar_seen` cookie expires, or
- the `version` field in their cookie differs from the value of
  `BANNER_VERSION` in [`global-bar-init.js`]

To show the global banner again for all users including those who have already
seen it 3 times:

1. Increment the value of `BANNER_VERSION` in [`global-bar-init.js`].
1. [Deploy Static].

## Remove the global banner

1. In [`app/views/components/_global_bar.html.erb`], change the value of
   `show_global_bar` to `false`.
2. [Deploy Static].

## Troubleshoot the banner

1. Check that your rollout of Static succeeded, for example by checking when
   Static was last synced in Argo CD
   ([staging](https://argo.eks.staging.govuk.digital/applications/cluster-services/static),
   [production](https://argo.eks.production.govuk.digital/applications/cluster-services/static)).
1. Make sure you are looking at the same environment where you deployed your
   change to Static.
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

[`app/views/components/_global_bar.html.erb`]: https://github.com/alphagov/static/blob/main/app/views/components/_global_bar.html.erb
[`global-bar-init.js`]: https://github.com/alphagov/static/blob/main/app/assets/javascripts/global-bar-init.js
[Deploy Static]: https://github.com/alphagov/static/actions/workflows/deploy.yml
