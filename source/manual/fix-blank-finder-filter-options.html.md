---
title: Fix blank options in finder filters
parent: "/manual.html"
layout: manual_layout
section: Publishing
owner_slack: "#2ndline"
last_reviewed_on: 2018-01-26
review_in: 3 months
related_applications: [rummager, finder-frontend]
---

On finder pages, facets on the left hand side can be populated from "link"
fields in the search documents, like people, organisations, topics.

If the pages for those things don't themselves exist in search, finder frontend
won't be able to fill in the titles:

![People facet with blank options](/images/blank-facets.png)

This can be detected by the [Finder Frontend feature in
Smokey][finder-frontend-smokey]. An example error would be `And I should see a
closed facet titled "People" with non-blank values`.

To fix the issue:

- Inspect the blank options using your browser developer tools to work out which
  pages are affected
- Republish those pages in whitehall

[finder-frontend-smokey]: https://github.com/alphagov/smokey/blob/master/features/finder_frontend.feature
