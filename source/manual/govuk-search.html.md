---
owner_slack: "#govuk-search"
title: "GOV.UK Search: Introduction and overview"
parent: "/manual.html"
layout: manual_layout
section: Search on GOV.UK
related_repos: [search-admin, search-api, search-api-v2]
type: learn
---

There are two common kinds of public-facing search service on GOV.UK: [Site search](#site-search) and [Finders](#finders).

In addition, there is also the publicly available https://www.gov.uk/api/search.json, powered by [search-api][]. See [Using the Search API](https://docs.publishing.service.gov.uk/repos/search-api/using-the-search-api.html) for examples of how to use this. There is no equivalent publicly available endpoint for querying search-api-v2.

## Site search

Site search is available on the GOV.UK homepage and from the blue super navigation header at the top of all gov.uk pages.

The url of site search is https://www.gov.uk/search/all which is rendered by finder frontend, and referred to in code as the all_content finder.

Search results for site search are usually provided by [search-api-v2][] and Google Cloud Platform (GCP)'s Agent Search ("Discovery Engine"). Except in the following cases when site search falls back to using [search-api][]

1. When [no search query][no-keyword-link] is provided.
2. When the [query param `use_v1=true`][use-v1-link] is present, eg https://www.gov.uk/search/all?order=updated-newest&use_v1=true
3. When a [world_locations][world-locations-link] query param is present, eg https://www.gov.uk/search/all?order=updated-newest&world_locations=france

More information is available at [GOV.UK Site search: How it works](./govuk-site-search.html.md)

## Finders

Finders are search pages on GOV.UK that are configured to return only a subset of available search results scoped by document type. They are rendered by Finder Frontend, and their search results are provided by [search-api][].

Some examples:

- https://www.gov.uk/search/news-and-communications
- https://www.gov.uk/search/research-and-statistics
- https://www.gov.uk/government/statistical-data-sets

 All finder content items are configured and published from search-api, except for specialist finders which are published by [specialist-publisher][] e.g. https://www.gov.uk/cma-cases (see [configuration](https://github.com/alphagov/specialist-publisher/blob/73392474433567dd5da75d4c307d99a2fe83c9b6/lib/documents/schemas/cma_cases.json))

Documentation on how finder frontend queries the two search api applications is available at [Finder Frontend: How search works](https://docs.publishing.service.gov.uk/repos/finder-frontend/how-search-works.html)

## Search API versus Search API V2

[search-api-v2][] was built to improve the quality of search results for the majority of GOV.UK users (when compared with search-api) and retains a "minimally compatible" API with search-api. It uses Google Cloud Platform (GCP)'s Agent Search ("Discovery Engine") product as its underlying search engine.

[search-api][] uses an old version of Elasticsearch as its underlying search engine. There is currently no clear roadmap for retiring search-api.

## How content gets into search

Content is published via Publishing API. After an edition is changed, Publishing API [publishes a message](https://github.com/alphagov/publishing-api/blob/6143731ffad5db48476d7647a75413c42a5224fd/app/services/downstream_service.rb#L40) to the `published_documents` topic exchange it [configured](https://github.com/alphagov/publishing-api/blob/52a763dc2bf29fd7038bdc6b8db3b617dfadafab/config/initializers/services.rb#L38-L49) on startup. Interested parties, such as search-api and search-api-v2, [subscribe to this exchange](https://github.com/alphagov/search-api/blob/a8045a2ef9d906e05d36a7708672e176dc4a3f8a/lib/tasks/message_queue.rake#L4-L13) to perform post-publishing actions.

search-api and search-api-v2 [listen to the publishing queue](https://github.com/alphagov/search-api/blob/a8045a2ef9d906e05d36a7708672e176dc4a3f8a/lib/tasks/message_queue.rake#L15-L21) using the [govuk_message_queue_consumer gem](https://github.com/alphagov/govuk_message_queue_consumer). In search-api-v2, [PublishingApiMessageProcessor](https://github.com/alphagov/search-api-v2/blob/main/app/message_processors/publishing_api_message_processor.rb) processes the indexing of the content, whereas in search-api, the work is done by [MessageProcessor](https://github.com/alphagov/search-api/blob/ae8308de19a1521777ca1bd6a1a828efaef2c2d3/lib/indexer/message_processor.rb#L11).

In addition to GOV.UK content, GDS staff can insert "external links" into search [via Search Admin](#search-admin).

### Filtered content

Not all content is indexed into search. For example, currently we only allow documents in English to be added to search, and we ignore particular formats.

The document filtering is part of the message handling functionality in [search-api](https://github.com/alphagov/search-api/blob/main/lib/govuk_index/publishing_event_message_handler.rb#L71-L77) and [search-api-v2](https://github.com/alphagov/search-api-v2/blob/main/app/models/concerns/publishing_api/action.rb).

## Search Admin

The [Search Admin application](https://search-admin.publishing.service.gov.uk/) gives GDS staff a means of inserting "external links" into search. For example, [searching for "Complain about bus services - Bus Users"](https://www.gov.uk/search/all?keywords=Complain+about+bus+services+-+Bus+Users) surfaces a link to a [non-GOV.UK URL](https://bususers.org/uk/complaints-administrator/).

As of March 2025, Search Admin is undergoing improvements. Watch this space!

## Known limitations

- [It isn't possible to see draft content in search results served by Search API v1 on the draft stack](https://trello.com/c/OwzUwkD6/103-it-isnt-possible-to-see-draft-content-in-search-results-served-by-search-api-v1-on-the-draft-stack)
- [Non-English content isn't supported](https://trello.com/c/ZzszTweH/115-non-english-content-isnt-supported-by-search-api)

---

[search-api-v2]: https://github.com/alphagov/search-api-v2
[search-api]: https://github.com/alphagov/search-api
[specialist-publisher]: https://github.com/alphagov/specialist-publisher
[finder-frontend]: https://github.com/alphagov/finder-frontend
[no-keyword-link]: https://github.com/alphagov/finder-frontend/blob/main/app/lib/search/query.rb#L139
[use-v1-link]: https://github.com/alphagov/finder-frontend/blob/main/app/lib/search/query.rb#L125
[world-locations-link]: https://github.com/alphagov/finder-frontend/blob/main/app/lib/search/query.rb#L136
