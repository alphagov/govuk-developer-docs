---
owner_slack: "#govuk-2ndline"
title: Deploy non-emergency global banner
parent: "/manual.html"
layout: manual_layout
section: Publishing
important: true
last_reviewed_on: 2019-06-27
review_in: 3 months
---

A site-wide banner can be activated to convey important information on
GOV.UK which is not deemed emergency level information. Unlike the
[emergency banner](/manual/emergency-publishing.html), the global
banner disappears after someone has seen it twice (controlled by a
cookie).

The file `app/views/notifications/_global_bar.html.erb` in
[static](https://github.com/alphagov/static) contains the necessary
minified JavaScript and markup to activate and render the banner.

## Activating the global banner

In `app/views/notifications/_global_bar.html.erb`,

1. Update the variables `title`, `information`, `link_href` and `link_text` with the relevant information.
1. Update the `show_global_bar` variable to `true`
1. Deploy static

The usual rules apply with static template caching.

![screenshot](images/global_banner.png)

## Removing the global banner

In `app/views/notifications/_global_bar.html.erb`,

1. Update the `show_global_bar` variable to `false`
1. Deploy static
