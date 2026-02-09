---
owner_slack: "#govuk-developers"
title: GOV.UK's sitemap
parent: "/manual.html"
type: learn
layout: manual_layout
section: Search on GOV.UK
---

GOV.UK's sitemap is available at https://www.gov.uk/sitemap.xml.
GOV.UK is far too big to fit into one sitemap, so this file is more of a 'sitemap index', which references around 30 other XML files, such as `https://www.gov.uk/sitemaps/sitemap_1.xml`.

## How the sitemap is generated

Every morning, a [search-api-generate-sitemap cronjob](https://github.com/alphagov/govuk-helm-charts/blob/edc7c7ccd7972ff84f95e652e37570c1bd35e4e5/charts/app-config/values-production.yaml#L2254-L2256) runs to generate a fresh sitemap.

The cronjob runs the [sitemap:generate_and_upload rake task](https://github.com/alphagov/search-api/blob/5636600a1dcb1517d30fe22334792b1e96537f6f/lib/tasks/sitemap.rake#L6) in search-api. This [enumerates over all documents in Search API](https://github.com/alphagov/search-api/blob/164b8ef982a7e360a05090676a158f05488365ce/lib/sitemap/generator.rb#L72) and [generates a sitemap](https://github.com/alphagov/search-api/blob/164b8ef982a7e360a05090676a158f05488365ce/lib/sitemap/generator.rb#L40-L41) matching the format specified in https://www.sitemaps.org/protocol.html. This job also [creates the sitemap index](https://github.com/alphagov/search-api/blob/164b8ef982a7e360a05090676a158f05488365ce/lib/sitemap/generator.rb#L32-L38).

The sitemap generator is [configured](https://github.com/alphagov/search-api/blob/164b8ef982a7e360a05090676a158f05488365ce/lib/sitemap/generator.rb#L154-L156) to search for documents across all of [Search API's indexes](#indexes).

## Indexes

search-api-v2 has no concept of an 'index'. search-api, on the other hand...

Documents are spread across three 'indexes' in Search API:

* `govuk`: the index populated by Publishing API, intended to encapsulate all GOV.UK content
* `government` and `detailed` - the remaining legacy '[content indexes](https://github.com/alphagov/search-api/blob/aef1da207bc6183e1681c405b8883f29a2d6fe56/elasticsearch.yml#L3)', encapsulating some Whitehall content and Detailed Guides respectively.

There are two Search API ADRs documenting the decision to move to one `govuk` index: [ADR-04](repos/search-api/arch/adr-004-transition-mainstream-to-publishing-api-index.html) and [ADR-06](/repos/search-api/arch/adr-006-transition-whitehall-to-publishing-api-index.html). Some legacy indexes (e.g. `mainstream`) have been fully migrated into it, but the two legacy indexes listed above remain.

One can find out which index a piece of content is saved under, using Search API's API: see `"index": "government"` on [this example](https://www.gov.uk/api/search.json?filter_link=/government/news/scottish-secretary-attends-royal-national-mod).
