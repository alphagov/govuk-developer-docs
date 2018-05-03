---
owner_slack: "#govuk-2ndline"
title: Redirect a Whitehall asset URL
section: Assets
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2017-10-25
review_in: 6 months
---

When a Whitehall asset e.g. a PDF attachment is updated Whitehall currently doesn't
redirect the old asset URL. Even if the filename stays the same the `id` within the URL
changes.

Whilst the content on the site will have the new URL, some content will have
been linked from external sites and will start to return 404s.

To redirect these, create a `Redirect` content item for them in publishing API. 
This can be done from Whitehall as per [this PR](https://github.com/alphagov/whitehall/pull/3505)

