---
layout: api_layout
title: Publishing API Model
source_url: https://github.com/alphagov/publishing-api/blob/master/doc/model.md
edit_url: https://github.com/alphagov/publishing-api/edit/master/doc/model.md
---
 <!-- This file was automatically generated. DO NOT EDIT DIRECTLY. --> This document outlines the Publishing API's model in moderate detail and
explains some of the design decisions and business needs for it.

Index:
 - [Content Item Fields](#content-item-fields)
 - [Change Notes](#change-notes)
 - [User Need](#user-need)
 - [General Themes](#general-themes)
 - [Content Item Uniqueness](#content-item-uniqueness)
 - [Lock Version](#lock-version)
 - [User-Facing Version](#user-facing-version)
 - [Workflow](#workflow)

## Content Item Fields

### `base_path`

Example: */vat-rates*

Required: Yes

The `base_path` specifies the route at which the content item will be served on
the GOV.UK website. Content items must have unique `base_paths` and the
Publishing API will not accept the request if this is not the case. This
uniqueness constraint extends to locale, as well. The English and French lock version
of a content item must have different `base_paths`.

### `content_id`

Example: *d296ea8e-31ad-4e0b-9deb-026da695bb65*

Required: Yes

The `content_id` is the content item’s main identifier and it forms its identity
as it travels through the pipeline. This is why requests to create and query
content items are keyed by `content_id` in the URL of the request.

Each `content_id` refers to a single piece of content, with a couple of caveats:

- Content IDs are shared across locales – the English and French lock versions of a
content item share a `content_id`

- `content_ids` are shared across publish states – the draft and live lock versions of
a content item share a `content_id`

`content_ids` are [UUIDs](https://github.com/alphagov/govuk-content-schemas/blob/44dfad0cc241b7bd9576f0a7cf7f3fdeac8ddfce/formats/metadata.json#L94-L97)
and will not be accepted by the Publishing API otherwise.

Note: Previously, the `base_path` was a content item's main identifier. This is
no longer the case. It has been changed to `content_id` because base paths had
a tendency to change.

### `publishing_app`

Example: *collections-publisher*

Required: Yes

The `publishing_app` identifies the application that published the content item.
When a content item is created, its `base_path` is registered to the
`publishing_app`. The path may not be used by a content item that was created
with a different `publishing_app`.

The `publishing_app` can then be used to filter content items when requests are
made to the Publishing API. The `publishing_app` is also used as a means of
auditing which applications are making use of the publishing pipeline.

Note: The value of the `publishing_app` field should be hyphenated as this is
the convention used in the Router API.

### `details`

Example: *{ body: "Something about VAT" }*

Required: Conditionally

The `details` (sometimes referred to as “details hash”) contains content and
other attributes that are specific to the `schema_name` of the content item. The
[GOV.UK content schemas](https://github.com/alphagov/govuk-content-schemas)
determine which fields appear in the details and which are required. The details
can contain arbitrary JSON that will be stored against the content item.

Not all schemas have required fields and so details is not required unless the
schema demands it. If it is not set, it will default to an empty JSON object
as specified in the GOV.UK content schemas.

## document_type

Examples: *manual, policy, redirect*

Required: Conditionally

The `document_type` specifies the type of content item that will be rendered.
It is used downstream to render the content item according to a specific layout
for that `document_type` and to filter a list of objects in publishing apps.

There is not a formal list of acceptable values for `document_type`. It
should be in the form of a-z string with underscore separators.

This field, together with `schema_name`, replaces the `format` field. It is
required in the absence of a `format` field.

If the `document_type` is one of either *redirect* or *gone*, the content item is
considered non-renderable and this waives the requirement for some of the other
fields in the content item to be present, namely `title`, `rendering_app` and
`public_updated_at`.

### format

**Deprecated**

Examples: *manual, policy, redirect*

Required: Conditionally

The `format` specifies the data format of the content item as per the
[GOV.UK content schemas](https://github.com/alphagov/govuk-content-schemas).
It is used downstream to render the content item according a specific layout for
that `format`.

This field has been replaced by sending both the `document_type` and
`schema_name` fields. Both of which are required if this field is omitted.

### `public_updated_at`

Example: *2015-01-01T12:00:00Z*

Required: Conditionally

The `public_updated_at` records the last time the content item was updated. This
is the time that will appear alongside the content item in the front-end to
inform users of the time at which that particular content item was updated. The
`public_updated_at` must use the [ISO 8601 format](https://en.wikipedia.org/wiki/ISO_8601).

The `public_updated_at` is required except in cases where the content item is
non-renderable (see [**document_type**](#document_type)). This will not be set
automatically and must be provided by the publishing application.

Note: This is subject to change. It may be that we automatically set
`public_updated_at` on behalf of publishing applications in the future. Please
speak to the Publishing Platform team if you have questions about this.

### `routes`

Example: *[{ path: “/vat-rates”, type: "exact" }]*

Required: Conditionally

The `routes` are used to configure the GOV.UK router for the content item. The
`routes` appear as a JSON array and each element in this array is a JSON object
that contains the properties *path* and *type*. No other properties are
supported.

The `routes` are required, except for the case when the content item
has a `document_type` of *redirect*. In this case, the `routes` must not be
present as it doesn’t make sense to have routes for a redirect. When the
`document_type` is anything except *redirect*, the routes must include
the `base_path` of the content item.

If additional `routes` are specified other than the one for the `base_path`, all
of these `routes` must reside under the `base_path`. Here is an example:

```
[
  { path: “/vat-rates”, type: "exact" },
  { path: “/vat-rates/tax-thresholds”, type: "exact" },
  { path: “/vat-rates/more-resources”, type: "exact" }
]
```

Note: Collectively, routes and redirects must have unique paths. The Publishing
API will not accept content items where the routes and redirects conflict with
each other.

### `redirects`

Example: *[{ path: “/vat-rates/tax-thresholds”, type: "exact", destination: “/vat-rates/bands” }]*

Required: Conditionally

The `redirects` are used to configure the GOV.UK router to specify redirects
related to the content item. The `redirects` appear as a JSON array and each
element in this array is a JSON object that contains the properties *path*,
*type* and *destination*. No other properties are supported. The *type* must be
set to one of either *exact* or *prefix*.

An *exact type* denotes that the *path* should be checked for an exact match
against the user’s request URL when determining whether a redirect should occur.
A *prefix type* denotes that any subpath under the specified path should be
redirected to the destination. You can think of these as “exact” and “wildcard”
matches, respectively. Although *prefix* types are supported, they are
discouraged. Please speak to the Publishing Platform team if you'd like to make
use of this feature.

The `redirects` are optional, except for the case when the content
item has a `document_type` of *redirect*. In this case, the redirects must be
present and they must include the `base_path` of content_item in the *path*
property.

Redirects are subject to the same requirement as routes in that their paths must
reside under the `base_path` of the content item (see [**routes**](#routes)).

Note: Collectively, routes and redirects must have unique paths. The Publishing
API will not accept content items where the routes and redirects conflict with
each other.

### `rendering_app`

Example: *government-frontend*

Required: Conditionally

The `rendering_app` identifies the front-end application that is responsible for
rendering the content item. The router will use this information to direct
users' requests to the appropriate front-end application.

The `rendering_app` is required except in cases where the content item is
non-renderable (see [**document_type**](#document_type)).

### schema_name

Examples: *manual, policy, redirect*

Required: Conditionally

The `schema_name` specifies the schema file used to validate the request
as per the
[GOV.UK content schemas](https://github.com/alphagov/govuk-content-schemas).

This field is required when the deprecated field `format` is not provided.

At present, not all content goes through the publishing pipeline, but there is
still a need to link to content items on our legacy infrastructure. There are
some special formats that can be used in these cases. The `schema_name` should be
prefixed with *placeholder_* or set to *placeholder*. See
[here](https://github.com/alphagov/content-store/blob/master/doc/placeholder_item.md)
for more information.

### `title`

Example: *VAT rates*

Required: Conditionally

The `title` names the content item. It is required except in cases where the
content item is non-renderable (see [**document_type**](#document_type)).

### `update_type`

Example: *major*

Required: Conditionally

The `update_type` is an indicator of the importance of the change to the content
item since the last time it was published. This field is required when
publishing the content item.

There’s no restriction on what the `update_type` should be, but at present we
use:

- *minor* - for minor edits that won’t be important to users

- *major* - for major edits that will be important to users

- *republish* - for when the content item needs to be re-sent to downstream
systems

- *links* - for when only the links of the content item have changed

Please discuss with the Publishing Platform team if you'd like to introduce new
`update_types`.

An example case for when a republish `update_type` should be used is when there
had previously been a problem with a downstream system and that system did not
act on publish events correctly. For example, there could have been a problem
with sending email alerts and so one way that this could be rectified might be
to republish the content items.

The *links* `update_type` is set automatically when the /links endpoint is used.
There is no need to set this manually. All of these `update_types` form part of
the routing key when the content item document is placed on the message queue,
together with the `document_type` of the content item (e.g. *policy.major*).

The *major* `update_type` is the only `update_type` that currently triggers email
alerts to be sent to users.

### `access_limited`

Example: *{ users: ["bf3e4b4f-f02d-4658-95a7-df7c74cd0f50"] }*

Required: No

The `access_limited` field determines who should be granted access to the
content item before it has been published. At the point of publish the content
item is public and everyone has access to it. This field should be used when a
content item needs to be drafted but it should not be visible on
content-preview (except for authorised users) until a publish occurs. Typically,
members of the organisation that created the content are in the list of
authorised users.

The value of this field should be set to a JSON object that contains the key
*users* and a value that is an array of [UUIDs](https://github.com/alphagov/govuk-content-schemas/blob/44dfad0cc241b7bd9576f0a7cf7f3fdeac8ddfce/formats/metadata.json#L94-L97).
These are the users that should be granted access to the content item. At
present, the only supported key is *users*.  If `access_limited` is not set, no
access restriction will be placed on the content item.

When front-end applications make requests to the content store, they must supply
the user they are making the request on behalf of if the content item is
restricted. An authentication proxy, that sits in front of the content store,
will reject the request if the supplied [UUID](https://github.com/alphagov/govuk-content-schemas/blob/44dfad0cc241b7bd9576f0a7cf7f3fdeac8ddfce/formats/metadata.json#L94-L97)
is not in the list of `access_limited` *users* for the content item. An example
of this header can be seen [here](https://github.com/alphagov/content-store/pull/129).

### `analytics_identifier`

Example: *GDS01*

Required: No

The `analytics_identifier` is the identifier that is used to track the content
item in analytics software. The front-end applications are responsible for
rendering the `analytics_identifier` in the metadata of the page (if present) so
that information about user activity can be tracked for the content item.

### `links`

Example: *{ “related”: [“8242a29f-8ad1-4fbe-9f71-f9e57ea5f1ea”] }*

Required: No

The `links` contain the [UUIDs](https://github.com/alphagov/govuk-content-schemas/blob/44dfad0cc241b7bd9576f0a7cf7f3fdeac8ddfce/formats/metadata.json#L94-L97)
of other content items that this content item links to. For example, if a
content item has some attachments or contacts that it references, these content
items should appear in the `links` of the content item.

The `links` for content items are managed separately to the content item itself.
When changing `links`, it is not necessary to republish the content item.
Instead, these changes will immediately be sent downstream to the draft content
store and also to the live content store if the content item has previously been
published.

An update to the `links` causes a message to be placed on the message queue.
This message will have a special update_type of links (see [**update_type**](#update_type)).
Email alerts will not be sent when the update_type is links.
This queue is consumed by the Rummager application in order to reindex the
appropriate content when `links` change for a content item.

### `locale`

Example: *en*

Required: No

The `locale` is the language in which the content item is written. Front-end
applications will optionally provide this string when querying the content store
in order to retrieve content items in a given `locale`.

A list of valid locales can be viewed in the Publishing API [here](https://github.com/alphagov/publishing-api/blob/9caeccc856ad372e332f56d64d0a96ab5df76b27/config/application.rb#L32-L37).
This field is not required and if a `locale` is not provided, it will be set to
*en* automatically.

### `need_ids`

Example: *["1234", "1235"]*

Required: No

The `need_ids` are the identifiers of [user needs](https://www.gov.uk/design-principles)
that are entered through the [Maslow application](https://github.com/alphagov/maslow).
They are passed through to the content store, untouched by the pipeline. The
front-end applications can then use the `need_ids` to present pages to users
that show how effectively users' needs are being met. [Here is an example](https://www.gov.uk/info/overseas-passports).

### `phase`

Examples: *alpha, beta, live*

Required: No

The `phase` is an optional field that may be used to indicate the ‘Service
Design Phase’ of the content item. The phase must be one of either *alpha*,
*beta* or *live*. If the `phase` is not specified, the Publishing API will
default it to *live*.

Content items will be published to the content store regardless of their
`phase`.  If a content item has a `phase` of either *alpha* or *beta*, a visual
component will be added to the front-end to show this (assuming the front-end
application for that format supports this).

There is more information on what each of the phases mean [here](https://www.gov.uk/service-manual/phases).

## Change Notes

Every content item can have an associated change note in the Publishing API.

This is a plain text description of the changes that have been made in
a major update of the content.

If the `change_history` has not been specified in the `details` for a
content item, the change notes will be used to create a
`change_history` to send to the content store (see the schema in the
[GOV.UK content schemas][govuk-content-schemas] repository for the
format).

[govuk-content-schemas]: https://github.com/alphagov/govuk-content-schemas

## User Need

We based this object model on the needs of our users. In the Publishing Platform
team, we are in a unique position such that the majority of our users are in
fact other developers working on their respective publishing applications.

In summary, this object model aims to address the following needs:

- Enable *dependency resolution* work. Specifically, this includes the ability
to support features such as Govspeak, Related Links and Breadcrumbs

- Enable *historical editions* by preserving historical versions of content
items (not just the latest draft/published)

In addition to these user needs, we also aim to:

- Reduce complexity in the system. Specifically, we'd like to separate out
concepts where appropriate and reduce duplication (previously we had separate
models for draft and live content items)

- Improve flexibility by moving towards a model that caters for changing
requirements without requiring significant re-writes of application code

## High-level Diagram

The following is a high-level diagram that was generated with
[plantuml](http://plantuml.com/plantuml/). The source that generated this diagram is
checked into this repository.

![Diagram of the object model](model/object-model.png)

## General Themes

You can see that ContentItem is central to the app's object model. The majority
of models within the app relate to ContentItem in some way. This shouldn't be
surprising as the Publishing API's core responsibility is to provide workflow
as a service for managing content.

Note that all of the arrows are pointing inwards to ContentItem and not the
other way around. This indicates that these models have visibility of the
ContentItem whereas ContentItem is shielded from the complexity of these
models. This improves extensibility as new concepts can be added without having
to re-open ContentItem to add new behaviour. See the
[open/closed principle](https://en.wikipedia.org/wiki/Open/closed_principle) for
more explanation of this approach.

Consider the alternative where all of this information resides in fields on the
ContentItem. If this were the case, we'd have to repeatedly update this model
when almost any piece of business logic changes within the app. If the
ContentItem has multiple responsibilities, this could be made more difficult as
this class would be significantly more complicated. By breaking distinct
concepts into separate models, it is easier to reason about a specific piece of
business logic.

An example of a model that has a large number of responsibilities is
[Edition](https://github.com/alphagov/whitehall/blob/master/app/models/edition.rb)
in the Whitehall application. This has become a
[God object](https://en.wikipedia.org/wiki/God_object) that is arguably quite
difficult to work with.

## Content Item Uniqueness

The ContentItem model is a simple model that houses content. It is surrounded by
objects that determine:

- The locale of the content (Translation)
- The base_path of the content (Location)
- The workflow state of the content (State)
- The user-facing version of the content (UserFacingVersion)

The uniqueness of a ContentItem is ensured by rules based on these objects.

Only one item in either a draft or a live state can be registered at a base_path.
Thus the rules for a base_path are:

1. A base_path for a draft ContentItem must be distinct from the base_path of
   any other draft ContentItems.
2. A base_path for a live ContentItem must be distinct from the base_path for
   any other live ContentItems

NB
- A draft ContentItem is a ContentItem with a state of "draft"
- A live ContentItem is a ContentItem with a state of "published" or
  "unpublished", however it does not include those with an unpublishing type of
  "substitute".

There can be only one instance of a ContentItem for a content_id and a
particular locale with a state of draft.

There can be only one instance of a ContentItem for a content_id and a
particular locale with a state of published/unpublished.

There can be multiple instance of a ContentItem for a content_id, a particular
locale and a state of superseded.

Only one instance of a ContentItem for a particular locale can be at a
user-facing version. Thus a rule exists that no two ContentItems can have
the same content id, the same user-facing version and the same locale.

## Lock Version

The lock version exists to prevent destructive changes being made to data when
multiple people are editing the same piece of content at the same time. It does
this by tracking a system-level version for arbitrary models in the domain.
Currently, we make use of lock versions for content items and link sets.

The lock version differs from the user-facing version in that it is an internal
system version that is not intended to be shown to a user. Instead, it forms
part contract between publishing apps and the Publishing API. It is not
mandatory that publishing apps make use of the lock version feature, but it is
strongly recommended that they do to prevent losses to work.

## User-Facing Version

The user-facing version, as the name implies, is the version for a piece of
content that is visible to users in publishing applications. This number changes
as a result of the user re-drafting a piece of content and it stays the same as
the content item transitions between states such as *draft* and *published*.

Longer term, we intend to use this model to support the user need related to
historical versions of content items. The object model is flexible enough to
support retrieval of older versions of content. Currently, there's no mechanism
to get these older pieces of content, but this could be added in time.

## Workflow

The following is a workflow diagram that was generated with
[graphviz](http://www.webgraphviz.com/). It shows how a content item's
user-facing version and state transition as actions are performed on it. The
source that generated this diagram is checked into this repository.

![Diagram of workflow](model/workflow.png)
