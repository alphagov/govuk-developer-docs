---
layout: document_type_layout
title: Document types on GOV.UK
---

A _document type_ describes a category of pages that can exist on GOV.UK. Document types are different from [content schemas], which define the structure of a piece of content.

GOV.UK Developer Docs automatically generates documentation about document types based on data in the [govuk_document_types repo].

## Relationship between document type and content schema

The mapping between GOV.UK document types and content schemas is many-to-many. A document type can correspond to one or more content schemas. A content schema can permit one or more document types for content items that conform to that schema.

## Analyse document types

Data about document types is available [in CSV format](document-types.csv). You can import this data into Google Sheets using the `importData` function:

```
=importData("https://docs.publishing.service.gov.uk/document-types.csv")
```

Google Sheets will [refresh the data hourly].

### Query document types in Search API

You can use Search API to [query for document types].

> Search API will not return document types which have yet to be migrated out of Whitehall.

[content schemas]: content-schemas.html
[govuk_document_types repo]: https://github.com/alphagov/govuk_document_types
[query for document types]: https://www.gov.uk/api/search.json?count=0&facet_content_store_document_type=115,examples:1,example_scope:query,example_fields:rendering_app
[refresh the data hourly]: https://support.google.com/docs/answer/58515?hl=en#zippy=%2Cchoose-how-often-formulas-calculate
