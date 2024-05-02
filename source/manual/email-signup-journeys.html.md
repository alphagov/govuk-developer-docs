---
owner_slack: "#govuk-notifications"
title: "Email signup journeys and email subscriptions across GOV.UK"
section: Emails
type: learn
layout: manual_layout
parent: "/manual.html"
---

There are a number of different ways that a user can subscribe to email notifications on GOV.UK. This documentation seeks to explain the different signup journeys, and types of subscription that are created.

## Email sign up entry points

### Single page notification button component

[The single page notification button component][single-page-notification-button] was rolled out in early 2022, and is present on many pages types including Call for evidence, Consultations, Detailed guides, Document collections and Publications. This signup flow subscribes users to a [content-id based][email-alert-api-documentation-content-id] email subscription.

The button was designed to enforce the GOV.UK account, in other words the user would be forced to sign-in or create an account to be able to complete their subscription journey. This tight coupling with the account was by design, to help increase the number of users signing up to the new GOV.UK account.

Since its initial roll out, the component has been extended so that it can now be [configured][skip-account-documentation] to skip the account sign up flow, and allow users to sign up via a magic link instead. At the time of writing, this customisation has only been implemented on Document collection pages. You can read about the reasons for this feature here: [Document Collection emails - a special case][document-collection-emails-documenation]

[document-collection-emails-documenation]: /manual/document-collection-emails-a-special-case.html.md

#### How does the skip account feature work?

- By default, the button will post to `/email/subscriptions/single-page/new?topic_id=slug` which is served by email-alert-frontend's [govuk_account_signups controller][email-alert-frontend-account-controller]. This route enforces the GOV.UK account.
- If the [skip_account parameter is present][govuk-publishing-components-present], the button will post to `/email-signup/?link=/slug` which is served by email-alert-frontend's [content_item_signups controller][email-alert-frontend-content-item-controller]. This route signs the user up by magic link.

[single-page-notification-button]: https://components.publishing.service.gov.uk/component-guide/single_page_notification_button
[skip-account-documentation]: https://components.publishing.service.gov.uk/component-guide/single_page_notification_button/with_skip_account
[email-alert-api-documentation-content-id]: https://github.com/alphagov/email-alert-api/blob/main/docs/matching-content-to-subscriber-lists.md#uuid-field
[email-alert-frontend-account-controller]:https://github.com/alphagov/email-alert-frontend/blob/810f3bd43dde903ca85cbf99c073c61bf037ca16/config/routes.rb#L39
[govuk-publishing-components-present]: https://github.com/alphagov/govuk_publishing_components/blob/main/lib/govuk_publishing_components/presenters/single_page_notification_button_helper.rb#L64-L66

### Sign up link component

[The Sign up link component][sign-up-link] predates the single page notification button, and is present on taxonomy topic pages only (see [here][taxonomy-topic-example] for an example). When subscribing to a topic that has subtopics, a checkbox form allows users to select which subtopics they would like to receive alerts about.

This component posts to `/email-signup/?link=/slug` which is served by email-alert-frontend's [content_item_signups controller][email-alert-frontend-content-item-controller]. This controller makes a request to Email Alert API for a [links-based][email-alert-api-documentation-links] email subscription.

The signup journey does not enforce the GOV.UK account, the user must enter an email address and is sent a magic link to confirm their subscription.

[sign-up-link]: https://components.publishing.service.gov.uk/component-guide/signup_link
[taxonomy-topic-example]: https://www.gov.uk/education
[email-alert-api-documentation-links]: https://github.com/alphagov/email-alert-api/blob/main/docs/matching-content-to-subscriber-lists.md#json-fields
[email-alert-frontend-content-item-controller]: https://github.com/alphagov/email-alert-frontend/blob/810f3bd43dde903ca85cbf99c073c61bf037ca16/config/routes.rb#L11

### Subscription links component

[The Subscription links component][subscription-links] is used on many pages, including:

- the announcements section of some [people pages][people-finder] (there's an example [here][rishi-sunak-page])
- organisation pages
- service manual pages
- specialist finders
- topical event pages
- travel advice pages
- world location news pages
- world wide taxon pages

The signup journey does not enforce the GOV.UK account, the user must enter an email address and is sent a magic link to confirm their subscription.

On Travel advice pages, the component posts to `/email/subscriptions/new?frequency=whatever&topic_id=slug` which is served by email-alert-frontend's [subscriptions controller][email-alert-frontend-subscriptions-controller]. This signup flow is the only place that the legacy [email_alert_signup][email-alert-schema] schema is currently used. The subscription that is created is [tag-based][email-alert-api-documentation-links].

You can read more about how email subscriptions work on specialist finders and the other page types mentioned above [here][finder-frontend-docs]

[subscription-links]: https://components.publishing.service.gov.uk/component-guide/subscription_links
[people-finder]: https://www.gov.uk/government/people
[rishi-sunak-page]: https://www.gov.uk/government/people/rishi-sunak
[email-alert-frontend-subscriptions-controller]:https://github.com/alphagov/email-alert-frontend/blob/main/config/routes.rb#L35
[finder-frontend-docs]https://github.com/alphagov/finder-frontend/blob/main/docs/finder-email-alerts.md
[email-alert-schema]: https://github.com/alphagov/publishing-api/blob/main/content_schemas/dist/formats/email_alert_signup/notification/schema.json
[email-alert-api-documentation-links]: https://github.com/alphagov/email-alert-api/blob/main/docs/matching-content-to-subscriber-lists.md#json-fields
