---
title: Add a new document type
parent: "/manual.html"
layout: manual_layout
section: Tools
owner_slack: "@davidslv and @matmoore"
last_reviewed_on: 2017-08-08
review_in: 3 months
---

The [document type](https://docs.publishing.service.gov.uk/document-types.html) describes what a page on GOV.UK looks like.

## Add the document type in the govuk-content-schema repo

You need to add the document type into the [allowed document types](https://github.com/alphagov/govuk-content-schemas/blob/master/lib/govuk_content_schemas/allowed_document_types.yml) in [content-schemas](https://github.com/alphagov/govuk-content-schemas/blob/master/lib/govuk_content_schemas).

Once you have added the document type you should:

- commit the change
- run the default [rake task](https://docs.publishing.service.gov.uk/manual/running-rake-tasks.html) to generate the schemas again
- commit this update separately

Examples of implementation:

- [https://github.com/alphagov/govuk-content-schemas/pull/652](https://github.com/alphagov/govuk-content-schemas/pull/652)
- [https://github.com/alphagov/govuk-content-schemas/pull/630](https://github.com/alphagov/govuk-content-schemas/pull/630)

## Create a new rake task in the Publishing API

The rake task will publish the route using the new document type.

Before you begin you must identify which publishing and rendering applications will use the document type. You need to include these as parameters (payload) when you generate the route.

Examples of implementation:

- [https://github.com/alphagov/collections-publisher/pull/250/files](https://github.com/alphagov/collections-publisher/pull/250/files)

You should publish your new content item with your document type to the Publishing API, especially if you want it to be part of search as it makes it easy to integrate search this way.

### Please note
Having a document type with `placeholder` prefix will not publish routes. More information can be found here under
[placeholder items](https://github.com/alphagov/content-store/blob/f5bf2ae1d86b6a38d52d22074c0d13acf2a0413c/doc/route_registration.md#placeholder-items).


## Add a new content schema

If you need help with adding a new schema in govuk-content-schemas please read the following: [https://github.com/alphagov/govuk-content-schemas/blob/master/docs/adding-a-new-schema.md](https://github.com/alphagov/govuk-content-schemas/blob/master/docs/adding-a-new-schema.md)

## Make the new document type available to search

Any document type that the publishing api knows about can be added to our internal search.
By default, all document types in internal search also get included in the GOV.UK sitemap, which tells external search engines about our content.

The app responsible for search is [Rummager](https://github.com/alphagov/rummager). Rummager listens to RabbitMQ messages about published documents to know when to index documents. For the new document type to be indexed, you need to add it to a whitelist.

### 1. Decide what fields you want to make available to search
Rummager has it’s own concept of document type, which represents the schema used to store documents in Elasticsearch (the search engine).

Normally, you’ll map your document type an existing rummager document type. If in doubt, use “[edition](https://docs.publishing.service.gov.uk/apis/publishing-api/model.html#edition)” - this is used for most documents.

Then, modify [mapped_document_types.yml](https://github.com/alphagov/rummager/blob/master/config/govuk_index/mapped_document_types.yaml) with the mapping from the publishing api document type.

If you want search to be able to use metadata that isn’t defined in an any rummager document type, then you’ll need to add new fields to rummager.

Rummager knows how to handle most of the core fields from the publishing platform, like title, description, and public_updated_at.
It looks at the `body` or `parts` fields to work out what text to make searchable. If your schema uses different fields to render the text of the page, update the [IndexableContentKeys](https://github.com/alphagov/rummager/blob/master/lib/govuk_index/indexable_content_keys.rb) module as well.

The part of rummager that translates between publishing api fields and search fields is [elasticsearch_presenter.rb](https://github.com/alphagov/rummager/blob/master/lib/govuk_index/presenters/elasticsearch_presenter.rb). Modify this if there is anything special you want search to do with your documents (for example: appending additional information to the title).

### 2. Add the document type to migrated_formats.yaml
Add the document_type name to the [`migrated`](https://github.com/alphagov/rummager/blob/master/config/govuk_index/migrated_formats.yaml) list in rummager.

### 3. Republish all the documents
Republish all the documents and they should appear in search. You can test this through the API using a query such as:

- [https://www.gov.uk/api/search.json?count=0&filter_content_store_document_type=guide](https://www.gov.uk/api/search.json?count=0&filter_content_store_document_type=guide)
- [https://www-origin.integration.publishing.service.gov.uk/api/search.json?count=0&filter_content_store_document_type=guide](https://www-origin.integration.publishing.service.gov.uk/api/search.json?count=0&filter_content_store_document_type=guide)


