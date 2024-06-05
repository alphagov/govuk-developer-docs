---
owner_slack: "#govuk-developers"
title: Document Collection emails - a special case
section: Emails
type: learn
layout: manual_layout
parent: "/manual.html"
---

[Document collections][document_collections_schema] are a type of GOV.UK page that is published by Whitehall, and rendered by [government-frontend][government-frontend]. This documentation seeks to explain how emails work on document collection pages, because at the time of writing, both the signup journey and the resulting email subscription for these pages are unique.

[document_collections_schema]: /document-types/document_collection.html
[government-frontend]: https://github.com/alphagov/government-frontend

## Background: specialist topics retirement

Prior to 2024, GOV.UK had three taxonomies:

* Taxonomy Topics (`taxons`)
* Mainstream Browse pages (`mainstream_browse_page`)
* Specialist Topics (`topic`)

In 2024, the Navigation team retired the Specialist Topic taxonomy. A result of this work was the roll out of two new email features that are present on document collection pages only.

To understand why this complexity was needed, it's necessary to explain how specialist topics were retired, and the consequences of the retirement for email subscribers.

### Specialist topic email subscriptions

Like taxonomy topics, specialist topics supported email alerts i.e. it was possible for a user to subscribe to emails on a specialist topic page. As part of the retirement work, most specialist topic pages were archived and redirected to existing content on GOV.UK, and any email subscriptions were terminated.

However around 50 high performing specialist topic pages were converted into document collections, and the original specialist topic page was redirected to the document collection conversion. For these pages, the migration of email subscribers from the specialist topic subscriber list, to the new document collection subscriber list was permitted.

In the majority of these 50 pages, this is the action that was taken. However one department was concerned that a document collection email subscription was so different from a specialist topic email subscription, that the migration would not meet the needs of its existing and future email subscribers.

It was necessary to address their concerns to unblock the retirement of specialist topics.

### Key differences between specialist topic and document collection email subcriptions

#### Breadth of subscription

* A specialist topic email subscription would notify users when any content tagged to the specialist topic was updated and published as a major change. This meant that a specialist topic email subscription was very broad, because there was no limit to the number of pages that could be tagged to a specialist topic.

* A document collection email subscription notifies users when either content listed on the document collection page, or the page itself, is updated and published as a major change. There is no technical limit to the number of links that can be added to a document collection, but sensible content design means that the number of linked content items on a document collection is far less than the number of pages that might be tagged to a specialist topic. For this reason a document collection email subscription is much narrower in scope.

To address this difference, and unblock the retirement of specialist topics, a new feature was rolled out called a [Taxonomy topic email override][taxonomy-topic-section].

This feature allows users to subscribe to a related taxonomy topic email list from a document collection page.

A taxonomy topic email subscription is similar to a specialist topic subscription, because an email is triggered when changes are made to content tagged to the taxonomy topic. Provided all content that was previously tagged to the specialist topic, was now tagged to the related taxonomy topic, the email subscriptions created would be similar.

[taxonomy-topic-section]: #what-is-a-taxonomy-topic-email-override

#### Requirement for a GOV.UK Account

* On Specialist topic pages, users subscribed to email alerts via the [Subscription links component][email-signup-subscription-links-heading]. This signup journey involved a user entering their email address and being sent a magic link to confirm their subscription. It was not necessary for the user to create or have an existing GOV.UK Account.

* Document collection pages by contrast used the [Single page notification button component][email-signup-single-button-heading] as a route into the sign up journey. This journey was hardcoded to enfore the GOV.UK Account, in other words clicking the button took the user directly to the account signup/signin page. It was not possible to subscribe to email alerts without having or creating a GOV.UK Account.

To address this difference, and unblock the retirement of specialist topics, a new variant of the single page notification button component was rolled out on document collection pages. [This variant is configured to skip the GOV.UK Account][email-signup-skip-account-heading], and sign the user up via a magic link instead.

It's worth highlighting that although the single page notification button looks the same to the user, the page they are taken to after clicking the button on a document collection page is different to the page they are taken to when clicking the identical button on all other page types.

[email-signup-subscription-links-heading]:/manual/email-signup-journeys.html#subscription-links-component
[email-signup-single-button-heading]:/manual/email-signup-journeys.html#single-page-notification-button-component
[email-signup-documentation]:/manual/email-signup-journeys.html
[email-signup-skip-account-heading]:/manual/email-signup-journeys.html#how-does-the-skip-account-feature-work

### What is a Taxonomy topic email override

* A `taxonomy_topic_email_override` is a type of edition_link that's added to the content item of a Document collection when it's [published][document-collection-presenter] from Whitehall.

* It's set via a rake task in Whitehall, full guidance is given in the section [How to set a taxonomy_topic_email_override][how-to-set]

* It stores the content_id of a taxonomy topic that a user will be subcribed to when signing up for emails on the document collection page.

* **It [can only be added to document collections][document-collection-schema] that have never previously been published.**

### How does the Taxonomy topic email override field work

When rendering a document collection page, government-frontend checks for the presence of a `taxonomy_topic_email_override` link in the content item.

* If a link is found, the page is rendered with a [sign up link component][email-signup-documentation signup-link-heading] that will find or create a taxonomy topic email subscription for the topic stored in the field.

* If no link is found, the page is rendered with a [single page notification button][email-signup-single-button-heading] that will sign the user up to a standard document collection email list instead.

[document-collection-presenter]: https://github.com/alphagov/whitehall/blob/21f85c4b483e907e6e57aa27507c261d3f08a50a/app/presenters/publishing_api/document_collection_presenter.rb#L46
[document-collection-schema]: https://github.com/alphagov/publishing-api/blob/main/content_schemas/formats/document_collection.jsonnet#L69-L71
[email-signup-documentation signup-link-heading]:/manual/email-signup-journeys.html#sign-up-link-component
[email-signup-single-button-heading]:/manual/email-signup-journeys.html#single-page-notification-button-component
[email-signup-subscription-link-heading]:/manual/email-signup-journeys.html#subscription-links-component
[email-signup-subscription-link-heading]:/manual/email-signup-journeys.html#subscription-links-component
[email_signup_component_guide]: https://components.publishing.service.gov.uk/component-guide/signup_link

### How to set a taxonomy_topic_email_override

It is only possible to set this field on document collections that have never been published before.

> Once a document is published with a `taxonomy_topic_email_override`, the field cannot be changed.

#### Warning: Do not set this field unless you have an exceptionally good reason

The following developer steps should **only** be taken if the request has comes from a content designer that has followed the guidance set out in [HMRC topic document collections: guidance for JCDs on 2nd line][content_documentation]. This is because once published, the field cannot be changed, so it's important that any government publisher requesting this feature has been talked through the risks and benefits before the override is set.

[content_documentation]: https://docs.google.com/document/d/1MR5OaFG_DOCmWGL9o9MSGIPLMFe2mmSrV6Va-99cSzw/edit#heading=h.y6ckz26uo2lf

#### Step one - Find the id of the document collection

1. Log into the whitehall admin UI via signon.
2. The ID can be taken from the URL of the document collection. E.g. `12345` for a document_collection at URL `whitehall-admin.publishing.service.gov.uk/government/admin/collections/12345`

#### Step two -  Run the rake task

The `taxonomy_topic_email_override` field can be set by running the following [rake task][whitehall_rake_task] from a Whitehall machine. This task runs in `dry_run` mode by default, unless a confirmation string is passed in. If the document collection has previously been published an error will be raised.

Dry run: `rake:set_taxonomy_topic_email_override[document_collection_id,taxon_content_id]`

For real: `rake:set_taxonomy_topic_email_override[document_collection_id,taxon_content_id,run_for_real]`

[whitehall_rake_task]: https://github.com/alphagov/whitehall/blob/main/lib/tasks/set_taxonomy_topic_email_override.rake

### What to do if you're asked to set or update a taxonomy topic email override field on a live page

As mentioned above, it is not possible to set this field unless the document collection is new and has not been published before.

However it is possible to create new content with a `taxonomy_topic_email_override`, to replace the original.

The steps to take depend on whether the original document collection was published with or without an override.

### Setting a `taxonomy_topic_email_override` if the original document collection was published without one

#### Step one - create a replacement document collection

1. The department must create a draft for a new document collection, that will replace the existing one.
2. A developer sets a taxonomy topic email override on the replacement document by following the steps [above][how-to-set].
3. The department confirms that the email override has been set to the correct taxonomy topic by checking the email notification tab on the document collection edit page in Whitehall. **The department must not publish the page until Step two below is complete.**
4. Department publishes the page.
5. Content designer unpublishes the original page and creates a redirect from the old document collection to the new document collection.

[how-to-set]: #1-find-the-content-id-of-the-document-collection

#### Step two - migrate any orphaned email subscribers

As described [above][how-does-it-work], if the original page was published without a taxonomy_topic_email_override, the page would have displayed a single page notification button that subscribed users to a standard document collection email list.

Those email subscribers can be bulk migrated to the appropriate taxonomy topic SubscriberList before the document collection page is unpublished and redirected.

Run the `data_migration:move_all_subscribers` [rake task][bulk-migrate-rake] from an email-alert-api machine.

[how-does-it-work]: #how-does-the-taxonomy-topic-email-override-field-work
[bulk-migrate-rake]:https://github.com/alphagov/email-alert-api/blob/main/lib/tasks/data_migration.rake#L4-L11

### Overriding an existing `taxonomy_topic_email_override` for previously published pages

In this case, we can create replacement content as described in [step one][step-one] above. However we cannot migrate any email subscribers that have signed up whilst the page was live.

This is because if the original page was published with an override, the page would have displayed a sign up link that subscribed users to a taxonomy topic email list as described in the section [How does the Taxonomy topic email override field work][how-it-works].

Email alert API does not store information about the page from which a user subscribed to a links-based list. So it is not possible to confidently identify the users that need to be migrated (as some could have signed up from the taxonomy page itself). This limitation/risk was acknowledged by both the department, and senior leadership when the feature was rolled out.

[step-one]: #step-one---create-a-replacement-document-collection
[how-it-works]: #how-does-the-taxonomy-topic-email-override-field-work
