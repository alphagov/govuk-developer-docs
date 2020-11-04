---
owner_slack: "#govuk-searchandnav"
title: Make a new document type available to search
parent: "/manual.html"
layout: manual_layout
section: Publishing
related_applications: [search-api]
---

Any document type that the Publishing API knows about can be added to our
internal search. By default, all document types in internal search also get
included in the GOV.UK sitemap, which tells external search engines about our
content.

The app responsible for search is [Search API][search-api]. Search API listens
to RabbitMQ messages about published documents to know when to index documents.
For the new document type to be indexed, you need to add it to a whitelist.

### 1. Decide what fields you want to make available to search

Search API has its own concept of [document type][doc-types], which represents
the schema used to store documents in Elasticsearch (the search engine).
Normally, you’ll map your document type to an existing Search API document type.
If in doubt, use "[edition][edition]", as this is used for most documents.
Then, modify [mapped_document_types.yml][mapped-doc-types] with the mapping
from the publishing api document type.

If you want search to be able to use metadata that isn’t defined in an any
Search API document type, then you’ll need to add new fields to Search API.

Search API knows how to handle most of the core fields from the publishing
platform, like `title`, `description`, and `public_updated_at`. It looks at the
`body` or `parts` fields to work out what text to make searchable. If your
schema uses different fields to render the text of the page, update the
[IndexableContentPresenter][i-c-presenter] as well.

The part of Search API that translates between Publishing API fields and search
fields is [ElasticsearchPresenter][e-s-presenter].
Modify this if there is anything special you want search to do with your
documents (for example: appending additional information to the title).

### 2. Add the document type to migrated_formats.yaml

Add the document_type name to the [`migrated` list][migrated-list] in Search
API.

### 3. Reindex

If your new document uses an existing schema, **this is not necessary**.

Reindex the `govuk` index following the instructions in
[Reindex an Elasticsearch index][reindex].

### 4. Republish all the documents

Republish all the documents. If they have been published already, you can
republish them with the [Publishing API represent_downstream][task] rake task:

```sh
$ rake represent_downstream:document_type[new_document_type]
```

You can test that the documents appear in search through the API using a query such as:

- [https://www.gov.uk/api/search.json?count=0&filter_content_store_document_type=guide][query-1]
- [https://www-origin.integration.publishing.service.gov.uk/api/search.json?count=0&filter_content_store_document_type=guide][query-2]

[search-api]: https://github.com/alphagov/search-api
[doc-types]: https://github.com/alphagov/search-api/blob/master/docs/schemas.md#elasticsearch-document-types
[edition]: https://github.com/alphagov/search-api/blob/master/config/schema/elasticsearch_types/edition.json
[mapped-doc-types]: https://github.com/alphagov/search-api/blob/master/config/govuk_index/mapped_document_types.yaml
[i-c-presenter]: https://github.com/alphagov/search-api/blob/master/lib/govuk_index/presenters/indexable_content_presenter.rb
[e-s-presenter]: https://github.com/alphagov/search-api/blob/master/lib/govuk_index/presenters/elasticsearch_presenter.rb
[migrated-list]: https://github.com/alphagov/search-api/blob/master/config/govuk_index/migrated_formats.yaml
[reindex]: reindex-elasticsearch.html
[task]: https://github.com/alphagov/publishing-api/blob/master/lib/tasks/represent_downstream.rake
[query-1]: https://www.gov.uk/api/search.json?count=0&filter_content_store_document_type=guide
[query-2]: https://www-origin.integration.publishing.service.gov.uk/api/search.json?count=0&filter_content_store_document_type=guide
