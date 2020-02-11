---
owner_slack: "#govuk-developers"
title: Add a new document type
parent: "/manual.html"
layout: manual_layout
section: Publishing
last_reviewed_on: 2020-01-17
review_in: 6 months
---

The [document type] describes what a page on GOV.UK looks like.

## Add the document type in the govuk-content-schema repo

You need to add the document type into the
[allowed document types][allowed-document-types] in
[govuk-content-schemas][govuk-content-schemas].

Once you have added the document type you should:

- commit the change
- run `bundle exec rake` to generate the schemas again
- commit this update separately

Examples of implementation:

- [https://github.com/alphagov/govuk-content-schemas/pull/652][pr-652]
- [https://github.com/alphagov/govuk-content-schemas/pull/630][pr-630]

## Create a new rake task in the publishing app

The rake task will publish the route using the new document type.

Before you begin, you must identify which publishing and rendering applications
will use the document type. You need to include these as parameters (payload)
when you generate the route.

Examples of implementation:

- [https://github.com/alphagov/collections-publisher/pull/250][pr-250]

You should publish your new content item with your document type to the
Publishing API, especially if you want it to be part of search, as it makes it
easy to integrate search this way.

> **Note**
>
> Having a document type with `placeholder` prefix will not publish routes. More
> information can be found here under [placeholder items][placeholder-items].

## Add a new content schema

See "[Adding a new schema][adding-a-new-schema]"

## Make the new document type available to search

See "[Make a new document type available to search][new-doc-type-search]"

[document type]: https://docs.publishing.service.gov.uk/document-types.html
[allowed-document-types]: https://github.com/alphagov/govuk-content-schemas/blob/master/lib/govuk_content_schemas/allowed_document_types.yml
[govuk-content-schemas]: https://github.com/alphagov/govuk-content-schemas
[pr-652]: https://github.com/alphagov/govuk-content-schemas/pull/652
[pr-630]: https://github.com/alphagov/govuk-content-schemas/pull/630
[pr-250]: https://github.com/alphagov/collections-publisher/pull/250
[placeholder-items]: https://github.com/alphagov/content-store/blob/f5bf2ae1d86b6a38d52d22074c0d13acf2a0413c/doc/route_registration.md#placeholder-items
[adding-a-new-schema]: https://github.com/alphagov/govuk-content-schemas/blob/master/docs/adding-a-new-schema.md
[new-doc-type-search]: /manual/make-a-new-document-type-available-to-search.html
