<!-- This file was automatically generated. DO NOT EDIT DIRECTLY. --> This is the primary interface from publishing apps to the publishing pipeline.
Applications PUT items as JSON conforming to a schema specified in
[govuk-content-schemas][govuk-content-schemas-repo]

Content locations are arbitrated internally by the Publishing API, the content is then
forwarded to the live and draft content stores, and placed on the message queue
for other apps (eg email-alert-service) to consume.

## Endpoints index
- [`PUT /v2/content/:content_id`](#put-v2contentcontent_id)
- [`POST /v2/content/:content_id/publish`](#post-v2contentcontent_idpublish)
- [`POST /v2/content/:content_id/unpublish`](#post-v2contentcontent_idunpublish)
- [`POST /v2/content/:content_id/discard-draft`](#post-v2contentcontent_iddiscard-draft)
- [`GET /v2/content`](#get-v2content)
- [`GET /v2/content/:content_id`](#get-v2contentcontent_id)
- [`POST /v2/actions/:content_id`](#post-v2actionscontent_id)
- [`PATCH /v2/links/:content_id`](#patch-v2linkscontent_id)
- [`GET /v2/links/:content_id`](#get-v2linkscontent_id)
- [`GET /v2/expanded-links/:content_id`](#get-v2expanded-linkscontent_id)
- [`GET /v2/linked/:content_id`](#get-v2linkedcontent_id)
- [`GET /v2/linkables`](#get-v2linkables)
- [`POST /lookup-by-base-path`](#post-lookup-by-base-path)
- [`GET /debug/:content_id`](#get-debugcontent_id)
- [`PUT /paths/:base_path`](#put-pathsbase_path)

### Optimistic locking (`previous_version`)

All PUT and POST endpoints take an optional JSON attribute `previous_version`
in the request. If given, the corresponding value should be a integer. This
allows the Publishing API to check that the publishing app sending the request
intends to update the latest lock version of the model in question.

If `previous_version` is provided, the Publishing API will confirm that the
provided value matches that of the content item in the Publishing API. If it
does not, a 409 Conflict response will be given.

### Warnings

Some endpoints may return warnings along with the content items. For
those that do, in the top level object for the content item, there
will be a value named "warnings". This will be an object, where the
names are the warnings that are applicable, and the coresponding
values are a human readable description of the warning.

#### Content Item Blocking Publish

This warning is only applicable for content items in the draft state, and
indicates that the draft cannot be published due to the presence of another
content item.

This will occur when the draft has a different content id from an existing item
of content, published (or unpublished) at the same base path. Some document
types are exempt from this restriction, and if either the draft, or the
blocking content item are of a "substitutable" document type, upon the publish
of the draft, the blocking item will be unpublished.

## `PUT /v2/content/:content_id`

[Request/Response detail][put-content-pact]

Used to create or update a draft content item. It will restrict creation if
there is already a draft content item with the same `base_path` and `locale`.
Uses [optimistic-locking](#optimistic-locking-previous_version).

The request must conform to the schema defined in govuk-content-schemas if it
doesn't a 422 response will be returned with an error message stating that the
payload did not conform to the schema with further error details. In
development, an error can occur if you do not have the govuk-content-schemas
locally, in which case ensure that you have pulled the latest
version of [GOV.UK content schema][govuk-content-schemas-repo] and set the
GOVUK_CONTENT_SCHEMAS_PATH environment variable to the location on your
machine - eg `export GOVUK_CONTENT_SCHEMAS_PATH=/var/govuk/govuk-content-schemas`.

If the request is successful, this endpoint will respond with the
presented content item and [warnings](#warnings).

### Path parameters
- [`content_id`](publishing-api-model.html#content_id)
  - Specifies the `content_id` of the content to be created or updated.

### JSON attributes
- [`access_limited`](publishing-api-model.html#access_limited) *(optional)*
  - A JSON object with a key of "users" the value of which is a array of UUIDs
    identifying users.
  - If provided, only the specified users will be able to view the content item
    on the draft frontend applications. It has no effect on live content.
- [`analytics_identifier`](publishing-api-model.html#analytics_identifier) *(optional)*
  - An identifier to track the content item in analytics software.
- [`base_path`](publishing-api-model.html#base_path) *(conditionally required)*
  - Required if `schema_name` (or `format`) is not one of "contact" or
    "government".
  - The path that this item will use on [GOV.UK](https://www.gov.uk).
- `change_note` *(optional)*
  - Specifies the [change note](publishing-api-model.html#change_notes).
  - Ignored if the `update_type` is not major.
- `description` *(optional)*
  - A description of the content that can be displayed publicly.
  - TODO: verify what this is meant for and does, and if this is a string or a
    JSON object. Validations appear to differ with database.
- [`details`](publishing-api-model.html#details) *(conditionally required, default: {})*
  - JSON object representing data specific to the `document_type`.
  - Validation for this can occur through the schema referenced in
    `schema_name`.
  - **Deprecated**: If there is no top-level `change_note` attribute,
    and this is a "major" `update_type`, then the Publishing API may
    extract the `change_note` from the details hash. This behaviour is
    for backwards compatibility, the top-level `change_note` attribute
    should be used instead.
	- If `details` has a member named `change_note`, that is used.
	- Otherwise, if `details` contains a member named
      `change_history`, then the `note` with the latest coresponding
      `public_timestamp` is used.
  - TODO: verify the validation on this field.
- [`document_type`](publishing-api-model.html#document_type) *(conditionally required)*
  - TODO: Add description.
  - Required if `format` is not provided.
- [`format`](publishing-api-model.html#format) **Deprecated** *(conditionally required)*
  - Superseded by the `document_type` and `schema_name` fields.
  - This is required if either `document_type` or `schema_name` is not
    specified.
- `last_edited_at` *(optional)*
  - An [ISO 8601][iso-8601] formatted timestamp should be provided, although
    [other formats][to-time-docs] may be accepted.
  - Specifies when this content item was last edited.
  - If omitted and `update_type` is "major" or "minor" `last_edited_at` will be
    set to the current time.
  - TODO: What should happen if the update_type is changed in a later request?
- [`locale`](publishing-api-model.html#locale) *(optional, default: "en")*
  - Accepts: An available locale from the [Rails I18n gem][i18n-gem]
  - Specifies the locale of the content item.
- [`need_ids`](publishing-api-model.html#need_ids) *(optional)*
  - An array of user need ids from the [Maslow application][maslow-repo]
- [`phase`](publishing-api-model.html#phase) *(optional, default: "live")*
  - Accepts: "alpha", "beta", "live"
  - TODO: What is this for?
- [`previous_version`](publishing-api-model.html#previous_version) *(optional, recommended)*
  - Used to ensure that the most recent version of the draft is being updated.
- [`public_updated_at`](publishing-api-model.html#public_updated_at) *(conditionally required)*
  - Required if `document_type` (or `format`) is not "contact" or "government".
  - An [ISO 8601][iso-8601] formatted timestamp should be provided, although
    [other formats][to-time-docs] may be accepted.
  - The publicly shown date that this content item was last edited at.
  - TODO: Check whether this validation is enforced in the API.
- [`publishing_app`](publishing-api-model.html#publishing_app) *(required)*
  - The name of the application making this request, words separated with
    hyphens.
- [`redirects`](publishing-api-model.html#redirects) *(conditionally required)*
  - Required for a `document_type` (or `format`) of "redirect".
  - An array of redirect values. (TODO: link directly to example)
- [`rendering_app`](publishing-api-model.html#rendering_app) *(conditionally required)*
  - Required for a `document_type` (or `format`) that is not "redirect" or
    "gone".
  - The hostname for the frontend application that will render this content
    item.
- [`routes`](publishing-api-model.html#routes) *(conditionally required)*
  - Required for a `document_type` (or `format`) that is not "redirect".
  - An array of route values. (TODO: link directly to example)
- [`schema_name`](publishing-api-model.html#schema_name) *(conditionally required)*
  - Required if `format` is not provided.
  - The name of the [GOV.UK content schema][govuk-content-schemas-repo]
    that the request body will be validated against.
- [`title`](publishing-api-model.html#title) *(conditionally required)*
  - Required for a `document_type` (or `format`) that is not "redirect" or
    "gone".
- [`update_type`](publishing-api-model.html#update_type) *(optional)*
  - Accepts: "major", "minor", "republish"
  - TODO: Check this is validated against.

### State changes
- If a `base_path` is provided it is reserved for use of the given
  `publishing_app`.
- Any draft content items that have a matching `base_path` and `locale` and
  have a document_type of "coming soon", "gone", "redirect" or "unpublishing"
  will be deleted.
- If a content item matching `content_id` and `locale` already exists in a
  "draft" state:
  - The existing draft content item will be updated and the lock version will
    be incremented.
  - If the `base_path` has changed since the last update, a draft redirect
    content item will be created.
- If a content item matching `content_id` and `locale` does not exist in a
  "draft" state:
  - A new content item will be created.
  - If the `base_path` is different to that of the published content item (if
    this exists) a draft redirect content item will be created.
- The draft content store will be updated with the content item and any
  associated redirects.

## `POST /v2/content/:content_id/publish`

[Request/Response detail][publish-pact]

Transitions a content item from a draft state to a published state. The content
item will be sent to the live content store. Uses
[optimistic-locking](#optimistic-locking-previous_version).

### Path parameters
- [`content_id`](publishing-api-model.html#content_id)
  - Identifies the draft content item to publish.

### JSON attributes
- [`update_type`](publishing-api-model.html#update_type) *(conditionally required)*
  - Accepts: "major", "minor", "republish"
  - Will fallback to the `update_type` set when the draft was created if not
    specified in the request.
- [`locale`](publishing-api-model.html#locale) *(optional, default: "en")*
  - Accepts: An available locale from the [Rails I18n gem][i18n-gem]
  - Specifies the locale of the content item to be published.
- `previous_version` *(optional, recommended)*
  - Used to ensure that the version being published is the most recent draft
    created.

### State changes
- The draft content item with the matching `content_id`, `locale` and
  `previous_version` will have its state set to "published".
- Any previously published content items for this `content_id` and `locale`
  will have their state set to "superseded".
- For an `update_type` of "major" the `public_updated_at` field will be updated
  to the current time.
- For an `update_type` other than "major":
  - If it exists, the [change note](publishing-api-model.html#change-notes) will be
    deleted, as change notes are only for major updates.
- If the content item has a non-blank `base_path`:
  - If the `base_path` of the draft item differs to the published version of
    this content item:
    - Redirects to this content item will be published.
  - Any published content items that have a matching `base_path` and `locale`
    and have a document_type of "coming soon", "gone", "redirect" or
    "unpublishing" will have their state changed to "unpublished" with a type
    of "substitute".
  - The live content store will be updated with the content item and any
    associated redirects.
  - All published content items that link to this item (directly or through a
    recursive chain of links) will be updated in the live content store.

## `POST /v2/content/:content_id/unpublish`

[Request/Response detail][unpublish-pact]

Transitions a content item into an unpublished state. The content item will be
updated or removed from the live content store depending on the unpublishing
type. Uses [optimistic-locking](#optimistic-locking-previous_version).

### Path parameters
- [`content_id`](publishing-api-model.html#content_id)
  - Identifies the content item to unpublish.

### JSON attributes
- `allow_draft` *(optional)*
  - Boolean value, cannot be `true` if `discard_drafts` is also `true`.
  - Specifies that only a draft content item will be unpublished.
- `alternative_path` *(conditionally required)*
  - Required for a `type` of "redirect", Optional for a `type` of "gone".
  - If specified, this should be [`base_path`](publishing-api-model.html#base_path).
- `discard_drafts` *(optional)*
  - Boolean value, cannot be `true` if `allow_drafts` is also `true`.
  - Specifies that if a draft exists, it will be discarded.
- `explanation` *(conditionally required)*
  - Required for a `type` of "withdrawal", Optional for a type of "gone".
  - Message that will be displayed publicly on the page that has been unpublished.
- [`locale`](publishing-api-model.html#locale) *(optional, default: "en")*
  - Accepts: An available locale from the [Rails I18n gem][i18n-gem]
  - Specifies the locale of the content item to unpublish.
- `previous_version` *(optional, recommended)*
  - Used to ensure that the version being unpublished is the most recent
    version of the content item.
- `type` *(required)*
  - Accepts: "gone", "redirect", "withdrawal", "vanish"
  - The type of unpublishing that is being performed.
- `unpublished_at` *(optional)*
  - An [ISO 8601][iso-8601] formatted timestamp should be provided, although
    [other formats][to-time-docs] may be accepted.
  - Specifies when this content item was withdrawn. Ignored for unpublishing
    types other than `withdrawn`.
  - If omitted, the `withdrawn_at` time will be taken to be the time this call
    was made.


### State changes
- If the unpublishing `type` is "gone", "redirect" or "withdrawal":
  - If the content item matching `content_id`, `locale` and `previous_version`
    has a draft state and `allow_draft` is `true`:
    - The draft content item state is set to "unpublished".
    - If a previously published version of the content item exists it's state
      will be set to "superseded".
  - If the content item matching `content_id`, `locale` and `previous_version`
    has a draft and `discard_drafts` is `true`:
    - The draft content item will be deleted from the Publishing API.
    - The draft content item will be removed from the draft content store.
    - The published content item state is set to "unpublished".
  - If the content item matching `content_id`, `locale` and `previous_version`
    has no draft:
    - The published content item state is set to "unpublished".
  - The live content store will be updated with the unpublished content item.
  - All published content items that link to this item (directly or through a
    recursive chain of links) will be updated in the live content store.
- If the unpublishing `type` is "vanish":
  - The content item will be removed from the live content store.

## `POST /v2/content/:content_id/discard-draft`

[Request/Response detail][discard-draft-pact]

Deletes a draft version of a content item. Replaces the draft content item on
the draft content store with the published item, if one exists. Uses
[optimistic-locking](#optimistic-locking-previous_version).

### Path parameters
- [`content_id`](publishing-api-model.html#content_id)
  - Identifies the content item with a draft state.

### JSON attributes
- [`locale`](publishing-api-model.html#locale) *(optional, default: "en")*
  - Accepts: An available locale from the [Rails I18n gem][i18n-gem]
  - Specifies which locale of the draft content item to delete.
- `previous_version` *(optional, recommended)*
  - Used to ensure the version being discarded is the current draft.

### State changes
- The draft content item will be deleted from the Publishing API.
- The draft content item will be removed from the draft content store.
- If a published content item exists it will be added to the draft content store.

## `GET /v2/content`

 [Request/Response detail][index-content-pact]

Retrieves a paginated list of content items for the provided query string
parameters. If content items exists in both a published and a draft state, the
draft is returned.

### Query string parameters
- [`document_type`](publishing-api-model.html#document_type) *(required)*
  - The type of content item to return.
- `fields[]` *(optional)*
  - Accepts an array of: "analytics_identifier", "base_path",
    "content_id", "description", "document_type", "locale",
    "public_updated_at", "schema_name", "title"
  - Determines which fields will be returned in the response, if omitted all
    fields will be returned.
- [`locale`](publishing-api-model.html#locale) *(optional, default "en")*
  - Accepts: An available locale from the [Rails I18n gem][i18n-gem]
  - Used to restrict content items to a given locale.
- `order` *(optional, default: "-public_updated_at")*
  - The field to sort the results by.
  - Returned in an ascending order unless prefixed with a hyphen, e.g.
    "-base_path".
- `page` *(optional, default: 1)*
  - The page of results requested.
- `per_page` *(optional, default: 50)*
  - The number of results to be shown on a given page.
- `q` *(optional)*
  - Search term to match against [`title`](publishing-api-model.html#title) and
    [`base_path`](publishing-api-model.html#base_path) fields.
- `publishing_app` *(optional)*
  - Used to restrict content items to those for a given publishing app.
- `states` *(optional)*
  - Used to restrict content items to those in the specified states.

## `GET /v2/content/:content_id`

[Request/Response detail][show-content-pact]

Retrieves a single content item for a `content_id` and `locale`. By default the
most recent version is returned, which may be a draft.

If the returned item is in the draft state, [warnings](#warnings) may be
included within the response.

### Path parameters
- [`content_id`](publishing-api-model.html#content_id)
  - Identifies the content item to be returned.

### Query string parameters
- [`locale`](publishing-api-model.html#locale) *(optional, default "en")*
  - Accepts: An available locale from the [Rails I18n gem][i18n-gem]
  - Used to return a specific locale.
- `version` *(optional)*
  - Specify a particular user facing version of this content item.
  - If omitted the most recent version is returned.

## `POST /v2/actions/:content_id`

TODO: Request/Response pact for actions

**Note - The usage opportunities for this endpoint is currently in discovery,
this feature may change significantly in time.**

Creates an action for the content item that is specified, defaults to
targeting a draft version of the content item but can be specified to target
live version. Uses [optimistic-locking](#optimistic-locking-previous_version).

### Path parameters
- [`content_id`](publishing-api-model.html#content_id)
  - Identifies a content item.

### JSON attributes
- `action` (required)
  - Currently an arbitrary name describing the workflow a content item has gone
    through
  - Provided in CamelCase
- `draft` (optional, default: "true")
  - Whether to target the live or draft version of a content item.
- [`locale`](publishing-api-model.html#locale) *(optional, default: "en")*
  - Accepts: An available locale from the [Rails I18n gem][i18n-gem]
  - Specifies which locale of the draft content item to delete.
- `previous_version` *(optional, recommended)*
  - Used to ensure the version being discarded is the current draft.

### State changes
- The draft content item will be deleted from the Publishing API.
- The draft content item will be removed from the draft content store.
- If a published content item exists it will be added to the draft content store.
## `PATCH /v2/links/:content_id`

[Request/Response detail][patch-link-set-pact]

Creates or updates a set of links for the given `content_id`. Link sets can be
created before or after the [PUT request](#put_v2contentcontent-id) for the
content item. These are tied to a content item solely by matching `content_id`
and they are not associated with a content item's locale or version. The
ordering of links in the request is preserved.

### Path parameters
- [`content_id`](publishing-api-model.html#content_id)
  - Identifies the content item the links are for.

### JSON attributes
- `links` *(required)*
  - A JSON object containing arrays of [`content_id`](publishing-api-model.html#content_id)s for
    each `link_type`.
  - An empty array for a `link_type` will delete that `link_type`.

```javascript
  "links": {
    "organisations": [
      "591436ab-c2ae-416f-a3c5-1901d633fbfb"
    ],
    "unwanted_link_type": []
  }
```
- `previous_version` *(optional, recommended)*
  - Used to ensure that we are updating the current version of the link set.

### State changes
- A link set is created or updated, with the `lock_version` of the link set
  being incremented.
- The draft content store is updated if there is a draft of the content item.
- The live content store is updated if there is a published version of the
  content item.

## `GET /v2/links/:content_id`

[Request/Response detail][show-links-pact]

Retrieves the link set for the given `content_id`. Returns arrays of
`content_id`s representing content items. These are grouped by `link_type`.
The ordering of the returned links matches the ordering when they were created.

### Path parameters
- [`content_id`](publishing-api-model.html#content_id)
  - Identifies the content item links will be retrieved for.

## `GET /v2/expanded-links/:content_id`

[Request/Response detail][show-expanded-links-pact]

Retrieves the expanded link set for the given `content_id`. Returns arrays of
details for each linked content item in groupings of `link_type`.

### Path parameters
- [`content_id`](publishing-api-model.html#content_id)
  - Identifies the content item links will be retrieved for.

## `GET /v2/linked/:content_id`

 [Request/Response detail][show-linked-pact]

Retrieves all content items that link to the given `content_id` for some
`link_type`.

### Path parameters
- [`content_id`](publishing-api-model.html#content_id)
  - Identifies the content item that may have been linked to.

### Query string parameters
- `link_type` *(required)*
  - The type of link between the documents.
- `fields[]` *(required)*
  - Accepts an array of: "analytics_identifier", "base_path",
    "content_id", "description", "document_type", "locale",
    "public_updated_at", "schema_name", "title"
  - Determines which fields will be returned in the response.

## `GET /v2/linkables`

 [Request/Response detail][index-linkables-pact]

Returns abridged versions of all content items matching the given
`document_type`. Returns `title`, `content_id`, `publication_state`, `base_path`
from the content item. It also adds a special field `internal_name`, which is
`details.internal_name` and falls back to `title`.

### Query string parameters:
- `document_type` *(required)*
  - The type of content item to return.

## `POST /lookup-by-base-path`

 [Request/Response detail][lookup-by-base-path-pact]

Retrieves published content items for a given collection of base paths. Returns
a mapping of `base_path` to `content_id`.

### POST parameters:
- `base_paths[]` *(required)*
  - An array of [`base_path`](publishing-api-model.html#base_path)s to query by.

## `GET /debug/:content_id`

Displays debug information for `content_id`.

### Path parameters:
- [`content_id`](publishing-api-model.html#content_id)
  - Identifies the content item to debug.

### Usage:
  ```
  ssh backend-1.integration -CNL 8888:127.0.0.1:3093
  ```

And then open http://localhost:8888/debug/f141fa95-0d79-4aed-8429-ed223a8f106a

Alternatively add the following host to your hosts file:
  ```
  127.0.0.1 publishing-api.integration.publishing.service.gov.uk
  ```

And then open
http://publishing-api.integration.publishing.service.gov.uk:8888/debug/f141fa95-0d79-4aed-8429-ed223a8f106a

## `PUT /paths/:base_path`

 [Request/response detail][reserve-path-pact]

Reserves a path for a publishing application. Returns success or failure only.

### Path parameters
- [`base_path`](publishing-api-model.html#base_path)
  - Identifies the path that will be reserved

### JSON parameters:
- [`publishing_app`](publishing-api-model.html#publishing_app) *(required)*
  - The name of the application making this request, words separated with hyphens.
- `override_existing` (optional)
  - Explicitly claim a path that has already been reserved by a different
    publishing_app. If not true, attempting to do this will fail.

### State changes
- If no path reservation for the supplied base_path is present, one will be
  created for the supplied publishing_app.
- If a path reservation exists for the supplied base_path but a different
  publishing_app, and `override_existing` is not true, the command will fail.
- If a path reservation exists for the supplied base_path and a different a
  publishing_app, and `override_existing` is true, the existing reservation will
  be updated to the supplied publishing_app.

[govuk-content-schemas-repo]: https://github.com/alphagov/govuk-content-schemas
[put-content-pact]: https://pact-broker.dev.publishing.service.gov.uk/pacts/provider/Publishing%20API/consumer/GDS%20API%20Adapters/latest#a_request_from_the_Whitehall_application_to_create_a_content_item_at_/test-item_given_/test-item_has_been_reserved_by_the_Publisher_application
[iso-8601]: https://en.wikipedia.org/wiki/ISO_8601
[to-time-docs]: http://apidock.com/rails/String/to_time
[i18n-gem]: https://github.com/svenfuchs/rails-i18n
[maslow-repo]: https://github.com/alphagov/maslow
[publish-pact]: https://pact-broker.dev.publishing.service.gov.uk/pacts/provider/Publishing%20API/consumer/GDS%20API%20Adapters/latest#a_publish_request_for_version_3_given_the_content_item_bed722e6-db68-43e5-9079-063f623335a7_is_at_version_3
[unpublish-pact]: https://pact-broker.dev.publishing.service.gov.uk/pacts/provider/Publishing%20API/consumer/GDS%20API%20Adapters/latest#an_unpublish_request_given_a_published_content_item_exists_with_content_id:_bed722e6-db68-43e5-9079-063f623335a7
[discard-draft-pact]: https://pact-broker.dev.publishing.service.gov.uk/pacts/provider/Publishing%20API/consumer/GDS%20API%20Adapters/latest#a_request_to_discard_draft_content_given_a_content_item_exists_with_content_id:_bed722e6-db68-43e5-9079-063f623335a7
[index-content-pact]: https://pact-broker.dev.publishing.service.gov.uk/pacts/provider/Publishing%20API/consumer/GDS%20API%20Adapters/latest#a_get_entries_request_given_a_content_item_exists_in_multiple_locales_with_content_id:_bed722e6-db68-43e5-9079-063f623335a7
[show-content-pact]: https://pact-broker.dev.publishing.service.gov.uk/pacts/provider/Publishing%20API/consumer/GDS%20API%20Adapters/latest#a_request_to_return_the_content_item_given_a_content_item_exists_with_content_id:_bed722e6-db68-43e5-9079-063f623335a7
[patch-link-set-pact]: https://pact-broker.dev.publishing.service.gov.uk/pacts/provider/Publishing%20API/consumer/GDS%20API%20Adapters/latest#a_request_to_update_the_linkset_at_version_3_given_the_linkset_for_bed722e6-db68-43e5-9079-063f623335a7_is_at_version_3
[show-links-pact]: https://pact-broker.dev.publishing.service.gov.uk/pacts/provider/Publishing%20API/consumer/GDS%20API%20Adapters/latest#a_get-links_request_given_empty_links_exist_for_content_id_bed722e6-db68-43e5-9079-063f623335a7
[show-expaned-links-pact]: https://pact-broker.dev.publishing.service.gov.uk/pacts/provider/Publishing%20API/consumer/GDS%20API%20Adapters/latest#a_get-expanded-links_request_given_empty_links_exist_for_content_id_bed722e6-db68-43e5-9079-063f623335a7
[show-linked-pact]: https://pact-broker.dev.publishing.service.gov.uk/pacts/provider/Publishing%20API/consumer/GDS%20API%20Adapters/latest#a_request_to_return_the_items_linked_to_it_given_no_content_exists
[index-linkables-pact]: https://pact-broker.dev.publishing.service.gov.uk/pacts/provider/Publishing%20API/consumer/GDS%20API%20Adapters/latest#a_get_linkables_request_given_there_is_content_with_format_'topic'
[lookup-by-base-path-pact]: https://pact-broker.dev.publishing.service.gov.uk/pacts/provider/Publishing%20API/consumer/GDS%20API%20Adapters/latest#a_/lookup-by-base-path-request_given_there_are_live_content_items_with_base_paths_/foo_and_/bar
[reserve-path-pact]: https://pact-broker.dev.publishing.service.gov.uk/pacts/provider/Publishing%20API/consumer/GDS%20API%20Adapters/latest#a_request_to_put_a_path_given_no_content_exists
