---
owner_slack: "#govuk-2ndline"
title: Deploy non-emergency global banner
parent: "/manual.html"
layout: manual_layout
section: Publishing
important: true
last_reviewed_on: 2019-09-26
review_in: 6 months
---

A site-wide banner can be activated to convey important information on GOV.UK
which is not deemed emergency level information. Unlike the
[emergency banner](/manual/emergency-publishing.html), the global banner
disappears after someone has seen it twice (controlled by a cookie).

The file `app/views/notifications/_global_bar.html.erb` in
[static](https://github.com/alphagov/static) contains the necessary minified
JavaScript and markup to activate and render the banner.

## Activating the global banner

In `app/views/notifications/_global_bar.html.erb`,

1. Update the variables `title`, `title_href`, `link_href` and `link_text` with the relevant info where applicable, otherwise set to `false`.
1. Update the `show_global_bar` variable to `true`
1. Deploy static

The usual rules apply with static template caching.

![screenshot](images/global_banner.png)

## Add the target page to blocklist

The target page linked to from the banner will automatically hide the banner. Add any other pages that don't need to show the banner to the `urlBlockList` in `app/assets/javascripts/global-bar-init.js`.

### Versioning the global banner

The number of times a user has viewed the banner is stored in a `global_bar_seen` cookie. Once the view count reaches 3, a user will not see the cookie again, even if the banner is re-deployed. The only way a user will see the banner again is if 1) the `global_bar_seen` cookie expires or 2) the global banner is versioned.

To version the global banner, increase the `BANNER_VERSION` in `global-bar-init.js` by one.

## Removing the global banner

In `app/views/notifications/_global_bar.html.erb`,

1. Update the `show_global_bar` variable to `false`
1. Deploy static
