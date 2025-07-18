---
owner_slack: "#govuk-search"
title: "What to do if someone says search is down"
parent: "/manual.html"
layout: manual_layout
section: Search
---

As described in [GOV.UK Search: how it works][link-1], there are two Search stacks on GOV.UK. This documentation aims to provide some debugging steps to take in the event that someone tells you "search is down".

This information is currently summarised as a [flow chart][link-2]

![Screenshot of flow chart][link-2]

## Identify what exactly is broken

Searches from [search/all][link-5] with a query param are sent to SearchAPI v2, and google vertex. [Without a query param][link-12], requests are sent to search-api (v1), which talks to Elasticsearch. So a quick way to identify which search stack is implicated is to see if searching with or without a query param results in different behaviour.

### Check the error rates for site search

The [GOV.UK Search Grafana dashboard][link-10] visualizes metrics for site search. The Search error rate is usually close to, or at 0.00%. If the errors here are high, this suggests site search is implicated. Skip to [If site search is unavailable](#If-site-search-is-unavailable).

### Check error rates for search v1

Check the [application dashboard for SearchAPI (v1)][link-11] to see if it's serving a high number of errors.

### Are all dynamic pages failing to load?

Pages that display search results - from either the new or old search stack - are dynamic and therefore cannot be mirrored. An incident involving the failure of a rendering application or a general frontend misconfiguration is often spotted first on search/all, even though it is not a failure of a search product. To identify if this is the case, you could check:

- [Complain about your council][link-3] which uses site search and is rendered by Frontend.
- [Guidance and Regulation finder][link-4] which uses old search and is rendered by Finder frontend.

If both of those pages fail to load, it is highly unlikely that the cause is a failure of both search products and more likely a broader issue.

## If site search is unavailable

If the problem appears to be with Site search, is the problem is with SearchAPI v2 or with Google Vertex which provides our search results?

Things to check:

### 1. Sentry alerts in #govuk-search-alerts

Check for unexpected sentry errors that might help identify issues. In addition to catching general exceptions,
Sentry is [also used][link-6] to catch synchronisation errors (when new content is pushed to the VAIS datastore).

A high number of synchronisation errors would suggest that new content is failing to reach our datastore, rather than failing to be returned as search results.

### 2. Application logs in Kibana

SearchAPIv2 raises a [DiscoveryEngine::InternalError][link-7] in the event of an error from Vertex. We do not surface those errors in Sentry, but they can be found in Kibana. A quick hacky way to find errors is to search for the Rails logger message ["Did not get search results"][link-9]. A high number of these requests suggests a problem with Vertex, which should be raised with [Google support][link-8].

## If site search is returning bad results

Search result relevance is fine tuned via a combination of:

1. Boosts and demotions applied at the [serving configuration level][link-13]
2. Boosts for [recency][link-14] applied at the application level at query time
3. Constant training of the model on [user event (GA4) data][link-15] sent to vertex from our BiqQuery account.

Recent changes to these files, or a failure of the user event data import would all be candidate causes of a reduction in search result quality. But they would be unlikely to have a catastrophically bad impact.

[link-1]: govuk-search.html.md
[link-2]: ../images/search-debugging-steps.png
[link-3]: https://www.gov.uk/complain-about-your-council
[link-4]: https://www.gov.uk/search/guidance-and-regulation
[link-5]: https://www.gov.uk/search/all
[link-6]: https://github.com/search?q=repo%3Aalphagov%2Fsearch-api-v2+GovukError&type=code
[link-7]: https://github.com/alphagov/search-api-v2/blob/d820f02b1bd94a5f34eb44ca67b536b85e630f96/app/services/discovery_engine/query/search.rb#L31-L37
[link-8]: to-come
[link-9]: https://github.com/alphagov/search-api-v2/blob/d820f02b1bd94a5f34eb44ca67b536b85e630f96/app/services/discovery_engine/query/search.rb#L34
[link-10]: https://grafana.eks.production.govuk.digital/d/govuk-search/gov-uk-search?orgId=1&from=now-24h&to=now&timezone=browser
[link-11]: https://grafana.eks.production.govuk.digital/d/app-requests/app3a-request-rates-errors-durations?orgId=1&from=now-30m&to=now&timezone=browser&var-namespace=apps&var-app=search-api-v2&var-app=search-api&var-error_status=$__all&refresh=1m
[link-12]: https://github.com/alphagov/finder-frontend/blob/489fe974178bc8ebdbedad727890528c6a5dfa9f/app/lib/search/query.rb#L139
[link-13]: https://github.com/alphagov/govuk-infrastructure/blob/1fa78b9fabcc3cdbfd419e0964a7bec45089bcd3/terraform/deployments/search-api-v2/serving_config_global_default.tf#L8-L14
[link-14]: https://github.com/alphagov/search-api-v2/blob/d820f02b1bd94a5f34eb44ca67b536b85e630f96/app/services/discovery_engine/query/news_recency_boost.rb#L8
[link-15]: https://github.com/alphagov/search-api-v2/blob/d820f02b1bd94a5f34eb44ca67b536b85e630f96/lib/tasks/user_events.rake
