---
owner_slack: "#govuk-search"
title: "Add a best bet to site search"
parent: "/manual.html"
layout: manual_layout
section: Search
---

### What is a best bet?

Sometimes we need to lift specific content to the top of search results, for example when a crucial new piece of content is added that hasn’t had time to naturally rise to the top by means of its popularity, or a page isn’t ranked well enough naturally.

### How to add a best bet

Add the path of the page to the [best bets YAML configuration file][link-1] in Search API v2, which will apply a [heavy query time boost][link-2] to the document.

Note that it is not currently possible to have a document as a best bet if it is completely unrelated to a query, i.e. if it would not naturally occur in results for the query. For example, you wouldn’t be able to add a document about strawberry yoghurt to the best bets for the query “pool noodle”.

[link-1]: https://github.com/alphagov/search-api-v2/blob/1c3e8115b15703a44691311a2971ce2dbee10c59/config/best_bets.yml
[link-2]: https://github.com/alphagov/search-api-v2/blob/1c3e8115b15703a44691311a2971ce2dbee10c59/app/services/discovery_engine/query/best_bets_boost.rb#L11
