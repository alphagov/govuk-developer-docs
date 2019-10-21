---
owner_slack: "#re-govuk"
title: app_domain handling in GOV.UK during migration to AWS
section: Infrastructure
layout: manual_layout
type: learn
parent: "/manual.html"
last_reviewed_on: 2019-10-21
review_in: 3 months
---

The app-by-app migration plan to move GOV.UK to AWS introduced the need to introduce an `$app_domain_internal` parameter in addition to the `$app_domain` used prior. This is due to the fact that in AWS, we use a `<environment>.govuk-internal.digital` domain in addition to the `<environment>.govuk.digital` domain.

Furthermore, the `app_domain` parameter may be set to the `<environment>.publishing.service.gov.uk` for migrated apps as well. The exact configration depends on the current state of the migrated app as well as its dependencies. For example, migrated backend applications, such as Support, may be configured to use the `<environment>.publishing.service.gov.uk` `$app_domain` to facilitate access to Signon over the internet. Applications in Carrenza which talk to AWS over the VPN need to be able to resolve the `<environment>.govuk-internal.digital`. This internal domain is resolved to the private IP CIDR in AWS (at the moment this is only done for RabbitMQ exchange federation).

As a rule of thumb:

- Applications which have been moved to AWS and have all their dependencies in AWS will use `$app_domain=<environment>.govuk.digital` and `<$app_domain_internal=<environment>.govuk-internal.digital` consistently.
- Applications which remain in Carrenza, including all their dependencies, will only use `app_domain=<environment>.publishing.service.gov.uk`.
- Applications having dependencies in both AWS and Carrenza will require some customisation of service resolution in form of a Plek URI override and may use either `$app_domain=<environment>.govuk.digital` or `$app_domain=<environment>.publishing.service.gov.uk`.

Since setting the correct service discovery environment for a particular app is complicated due to the migration to AWS, please take extra care to make sure you understand the effects of changes to the app_domain parameter and Plek URI overrides via environment variables. If in doubt, please liaise with RE:GOV.UK, e.g. via Slack #re-govuk to make sure your changes do not have unintended side effects.
