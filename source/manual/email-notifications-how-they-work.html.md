---
owner_slack: "#govuk-notifications"
title: "Email notifications: how they work"
section: Emails
type: learn
layout: manual_layout
parent: "/manual.html"
---

## High-level overview

The purpose of the email notifications system is to inform users when content they are interested in is added to or changed on GOV.UK. Users can subscribe to receive updates for an area of interest, such as a topic, government department, or a set of search results. Current subscriptions to individual content items are not supported.

**Update September 2019:** the email system also now supports highly customised subscriptions for users completing the [Brexit Checker][brexit-checker], which operates in isolation from the rest of GOV.UK, and specifies its own notifications. More information can be found in [the ADR][message-adr] for these changes.

## Types of email

The email notification system generates 3 different types of email. These are transactional, immediate and digest.

**Transactional** emails are sent to confirm a new subscription, and to authenticate an existing subscriber so they can manage their subscriptions.

**Immediate** emails are generated shortly after the email system receives a content change, or a message, that corresponds to a user's immediate subscription. It's worth noting that "immediate" is a somewhat misleading name as these emails can sometimes take a long time (hours) to be sent when the system is busy.

**Digest** emails are generated daily and weekly for subscribers who have opted to have their updates sent to them in batches. These collate all of a subscriber's subscriptions into a single summary of all the relevant content changes and messages that occurred over the preceding day or week.

## Useful resources

- [Technical dashboard][email-alert-api-technical]
- [Product dashboard][email-alert-api-product]
- [How content is matched to subscriber lists][email-alert-api-matching]
- [Courtesy copies Google group][google-group]
  - Provides a way to view replicas of every immediate email notification generated in production.
  - Works by the group being subscribed to the "all-government-publishing-updates" list ([here][courtesy-subscription-page]).
- [How to receive emails in Integration and Staging][receiving-integration-staging-email]

## Email system apps

- [Finder Frontend][finder-frontend-email]
  - Provides a UI to sign up to filterable search results.

- [Travel Advice Publisher] / [Specialist Publisher]
  - Use Email Alert API directly to send email ([tech debt][travel-specialist-tech-debt]).

- [Email Alert Frontend][email-frontend-readme]
  - Provides a UI to sign up to static pages e.g. a taxon.
  - Provides a UI for a user to manage their subscriptions.
  - Communicates with Email Alert API to make changes.

- [Email Alert Service][email-service-readme]
  - Listens to the Publishing API message queue for `major` changes to content.
  - Communicates with Email Alert API API to trigger sending emails.

- [Email Alert API][email-api-readme]
  - Stores data about subscribers and the emails we send to them.
  - Provides APIs for working with subscriptions and sending emails.
  - Sends email using GOV.UK Notify, and [deals][email-spam-report] with spam reports.

Communication from Email Alert API to Notify is done via a HTTP API which is authenticated by [an API key][notify-api-key]. Communication from Notify to Email Alert API is [authenticated][email-spam-auth] with Signon and a bearer token.  Email Alert API is an internal application, so to enable callbacks two endpoints are [exposed][email-spam-public] publicly through <https://email-alert-api-public.publishing.service.gov.uk> (similarly for Integration and Staging).

[finder-frontend-email]: https://github.com/alphagov/finder-frontend/blob/main/app/controllers/email_alert_subscriptions_controller.rb
[email-frontend-readme]: https://github.com/alphagov/email-alert-frontend
[Specialist Publisher]: /repos/specialist-publisher.html
[Travel Advice Publisher]: /repos/travel-advice-publisher.html
[travel-specialist-tech-debt]: https://trello.com/c/tWIZfxfc/94-travel-advice-publisher-and-specialist-publisher-talk-directly-to-email-alert-api
[email-alert-api-technical]: https://grafana.production.govuk.digital/dashboard/file/email_alert_api_technical.json
[email-alert-api-product]: https://grafana.production.govuk.digital/dashboard/file/email_alert_api_product.json
[email-alert-api-matching]: https://github.com/alphagov/email-alert-api/blob/main/docs/matching-content-to-subscriber-lists.md
[receiving-integration-staging-email]: /manual/receiving-emails-from-email-alert-api-in-integration-and-staging.html
[google-group]: https://groups.google.com/a/digital.cabinet-office.gov.uk/forum/#!forum/govuk-email-courtesy-copies
[courtesy-subscription-page]: https://www.gov.uk/search/all/email-signup
[email-spam-report]: https://github.com/alphagov/email-alert-api/blob/main/app/controllers/spam_reports_controller.rb
[notify-api-key]: https://github.com/alphagov/email-alert-api/blob/05c99c4ed95f71dbca1d423dd3d5d438b93d6437/config/secrets.yml#L40
[email-spam-auth]: https://signon.publishing.service.gov.uk/api_users/14020/edit
[email-spam-public]: https://github.com/alphagov/govuk-aws/commit/442bd30c46f8c242a7df05a8c27a79855b5698fb#diff-069b7aaa2455edca6b507407de527eba4e4374d04b01584889519b6c5d6a4290R822
[message-adr]: https://github.com/alphagov/email-alert-api/blob/main/docs/adr/adr-004-message-concept.md
[brexit-checker]: https://github.com/alphagov/finder-frontend/tree/main/app/lib/brexit_checker
[email-service-readme]: https://github.com/alphagov/email-alert-service
[email-api-readme]: https://github.com/alphagov/email-alert-api
