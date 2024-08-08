---
owner_slack: "#govuk-developers"
title: GOV.UK's sitemap
parent: "/manual.html"
type: learn
layout: manual_layout
---

GOV.UK's sitemap is available at https://www.gov.uk/sitemap.xml.
GOV.UK is far too big to fit into one sitemap, so this file is more of a 'sitemap index', which references around 30 other XML files, such as `https://www.gov.uk/sitemaps/sitemap_1.xml`.

## How the sitemap is generated

Every morning, a [search-api-generate-sitemap cronjob](https://github.com/alphagov/govuk-helm-charts/blob/edc7c7ccd7972ff84f95e652e37570c1bd35e4e5/charts/app-config/values-production.yaml#L2254-L2256) runs to generate a fresh sitemap.

The cronjob runs the [sitemap:generate_and_upload rake task](https://github.com/alphagov/search-api/blob/5636600a1dcb1517d30fe22334792b1e96537f6f/lib/tasks/sitemap.rake#L6) in search-api. This [enumerates over all documents in Search API](https://github.com/alphagov/search-api/blob/164b8ef982a7e360a05090676a158f05488365ce/lib/sitemap/generator.rb#L72) and [generates a sitemap](https://github.com/alphagov/search-api/blob/164b8ef982a7e360a05090676a158f05488365ce/lib/sitemap/generator.rb#L40-L41) matching the format specified in https://www.sitemaps.org/protocol.html. This job also [creates the sitemap index](https://github.com/alphagov/search-api/blob/164b8ef982a7e360a05090676a158f05488365ce/lib/sitemap/generator.rb#L32-L38).

The sitemap generator is [configured](https://github.com/alphagov/search-api/blob/164b8ef982a7e360a05090676a158f05488365ce/lib/sitemap/generator.rb#L154-L156) to search for documents across all of [Search API's indexes](#indexes).

## How content gets into Search API

The preferred pattern is for content to be published via Publishing API.
After an edition is changed, Publishing API [publishes a message](https://github.com/alphagov/publishing-api/blob/6143731ffad5db48476d7647a75413c42a5224fd/app/services/downstream_service.rb#L40) to the `published_documents` topic exchange it [configured](https://github.com/alphagov/publishing-api/blob/52a763dc2bf29fd7038bdc6b8db3b617dfadafab/config/initializers/services.rb#L38-L49) on startup. Interested parties, such as Search API, can [subscribe to this exchange](https://github.com/alphagov/search-api/blob/a8045a2ef9d906e05d36a7708672e176dc4a3f8a/lib/tasks/message_queue.rake#L4-L13) to perform post-publishing actions.

Search API [listens to the publishing queue](https://github.com/alphagov/search-api/blob/a8045a2ef9d906e05d36a7708672e176dc4a3f8a/lib/tasks/message_queue.rake#L15-L21) using the [govuk_message_queue_consumer gem](https://github.com/alphagov/govuk_message_queue_consumer). Its [MessageProcessor](https://github.com/alphagov/search-api/blob/ae8308de19a1521777ca1bd6a1a828efaef2c2d3/lib/indexer/message_processor.rb#L11) processes the indexing of the content.

However, message queues aren't the only way to get content into Search API.
Whitehall [calls Search API directly](https://github.com/alphagov/whitehall/blob/e748b577e0f13c01fe62bad2a303340ab5acc7c4/lib/whitehall/searchable.rb#L53), via [Whitehall::SearchIndex](https://github.com/alphagov/whitehall/blob/e748b577e0f13c01fe62bad2a303340ab5acc7c4/lib/whitehall/search_index.rb#L40), which is [called by](https://github.com/alphagov/whitehall/blob/a67fae1b8a0963927f38ce9987b99059fa9fff92/app/models/concerns/searchable.rb#L116) any model that includes the [Searchable](https://github.com/alphagov/whitehall/blob/a67fae1b8a0963927f38ce9987b99059fa9fff92/app/models/concerns/searchable.rb) module. This legacy behaviour is [recognised tech debt](https://trello.com/c/vnrBGTvr/26-search-is-populated-by-whitehall-sending-data) and should be removed.

Note that there shouldn't be a situation where Whitehall submits content to Search API both directly _and_ via Publishing API. The [Search API's 'migrated formats' file](https://github.com/alphagov/search-api/blob/main/config/govuk_index/migrated_formats.yaml) controls which document types Search API expects from each source. There's a `non_indexable` section at the bottom that includes all of the Whitehall document types. Search API checks when processing messages from Publishing API whether or not the document type is indexable, and [ignores them if it's not](https://github.com/alphagov/search-api/blob/60a909bb51229fa5ad683be49f873084557fc0a9/lib/govuk_index/publishing_event_worker.rb#L88).

## Indexes

Documents are spread across three 'indexes' in Search API:

* `govuk`: the index populated by Publishing API, intended to encapsulate all GOV.UK content
* `government` and `detailed` - the remaining legacy '[content indexes](https://github.com/alphagov/search-api/blob/aef1da207bc6183e1681c405b8883f29a2d6fe56/elasticsearch.yml#L3)', encapsulating some Whitehall content and Detailed Guides respectively.

There are two Search API ADRs documenting the decision to move to one `govuk` index: [ADR-04](repos/search-api/arch/adr-004-transition-mainstream-to-publishing-api-index.html) and [ADR-06](/repos/search-api/arch/adr-006-transition-whitehall-to-publishing-api-index.html). Some legacy indexes (e.g. `mainstream`) have been fully migrated into it, but the two legacy indexes listed above remain.

One can find out which index a piece of content is saved under, using Search API's API: see `"index": "government"` on [this example](https://www.gov.uk/api/search.json?filter_link=/government/news/scottish-secretary-attends-royal-national-mod).
