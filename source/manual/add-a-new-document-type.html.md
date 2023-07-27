---
owner_slack: "#govuk-developers"
title: Add a new document type
parent: "/manual.html"
layout: manual_layout
section: Publishing
---

The [document type][] describes what a page on GOV.UK looks like.

[document type]: /document-types.html

## Add the document type in the govuk-content-schema repo

You need to add the document type into the [allowed document types][] in [publishing api][]. Once you have added the document type you should:

- Commit the change
- Run `bundle exec rake` to generate the schemas again
- Commit this update separately

Examples of implementation (note that these examples are for the retired govuk-content-schemas repo: please add examples of adding to publishing api when these are available):

- <https://github.com/alphagov/govuk-content-schemas/pull/652>
- <https://github.com/alphagov/govuk-content-schemas/pull/630>

[allowed document types]: https://github.com/alphagov/publishing-api/tree/main/content_schemas/allowed_document_types.yml
[publishing api]: https://github.com/alphagov/publishing-api

## Add a new content schema

If your document type needs a new content schema, see "[Adding a new schema][]".

[Adding a new schema]: /repos/publishing-api/content_schemas/adding-a-new-schema.html

## Make the new document type available to search

If your document type should be available in search results, see "[Make a new document type available to search][]".

[Make a new document type available to search]: /manual/make-a-new-document-type-available-to-search.html

## Create a new Rake task in the publishing app

If your new document type will be published as a static route (rather than from a publishing app), you'll need to create a Rake task to publish the route using the new document type.

Before you begin, you must identify which publishing and rendering applications will use the document type. You need to include these as parameters (payload) when you generate the route.

See "[Publish special routes]" for more information.

> Note: having a document type with `placeholder` prefix will not publish routes. Read more about [placeholder items][placeholder-items].

[Publish special routes]: /manual/publish-special-routes.html
[placeholder-items]: /repos/content-store/placeholder_item.html
