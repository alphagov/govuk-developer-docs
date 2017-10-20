---
title: Make a new document type available to search
parent: "/manual.html"
layout: manual_layout
section: Publishing
owner_slack: "@davidslv and @matmoore"
last_reviewed_on: 2017-08-08
review_in: 3 months
related_applications: [rummager]
---


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


