---
title: Fix blank options in finder filters
parent: "/manual.html"
layout: manual_layout
section: Publishing
owner_slack: "#govuk-2ndline"
last_reviewed_on: 2018-08-17
review_in: 6 months
related_applications: [rummager, finder-frontend]
---

On finder pages, facets on the left hand side can be populated from "link"
fields in the search documents, like people, organisations, topics.

If the pages for those things don't themselves exist in search, finder-frontend
won't be able to fill in the titles:

![People facet with blank options](/images/blank-facets.png)

To fix the issue:

- Inspect the blank options using your browser developer tools to work out which
  pages are affected
- Republish those pages in whitehall

[finder-frontend-smokey]: https://github.com/alphagov/smokey/blob/master/features/finder_frontend.feature
