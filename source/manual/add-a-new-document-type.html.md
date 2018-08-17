---
title: Add a new document type
parent: "/manual.html"
layout: manual_layout
section: Tools
owner_slack: "#govuk-2ndline"
last_reviewed_on: 2018-08-17
review_in: 3 months
---

The [document type](https://docs.publishing.service.gov.uk/document-types.html) describes what a page on GOV.UK looks like.

## Add the document type in the govuk-content-schema repo

You need to add the document type into the [allowed document types](https://github.com/alphagov/govuk-content-schemas/blob/master/lib/govuk_content_schemas/allowed_document_types.yml) in [content-schemas](https://github.com/alphagov/govuk-content-schemas).

Once you have added the document type you should:

- commit the change
- run `bundle exec rake` to generate the schemas again
- commit this update separately

Examples of implementation:

- [https://github.com/alphagov/govuk-content-schemas/pull/652](https://github.com/alphagov/govuk-content-schemas/pull/652)
- [https://github.com/alphagov/govuk-content-schemas/pull/630](https://github.com/alphagov/govuk-content-schemas/pull/630)

## Create a new rake task in the publishing app

The rake task will publish the route using the new document type.

Before you begin, you must identify which publishing and rendering applications will use the document type. You need to include these as parameters (payload) when you generate the route.

Examples of implementation:

- [https://github.com/alphagov/collections-publisher/pull/250/files](https://github.com/alphagov/collections-publisher/pull/250/files)

You should publish your new content item with your document type to the Publishing API, especially if you want it to be part of search as it makes it easy to integrate search this way.

> **Note**
> Having a document type with `placeholder` prefix will not publish routes. More information can be found here under
[placeholder items](https://github.com/alphagov/content-store/blob/f5bf2ae1d86b6a38d52d22074c0d13acf2a0413c/doc/route_registration.md#placeholder-items).

## Add a new content schema

[See "Adding a new schema"](https://github.com/alphagov/govuk-content-schemas/blob/master/docs/adding-a-new-schema.md)

## Make the new document type available to search

[See "Make a new document type available to search"](/manual/make-a-new-document-type-available-to-search.html)
