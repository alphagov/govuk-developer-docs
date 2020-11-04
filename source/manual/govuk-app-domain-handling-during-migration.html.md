---
owner_slack: "#re-govuk"
title: app_domain handling in GOV.UK during migration to AWS
section: Infrastructure
layout: manual_layout
type: learn
parent: "/manual.html"
---

> Deprecation note:
> This page should be removed after all machines in Carrenza have been shutdown
> and all reference to this has been removed from [govuk-puppet](https://github.com/alphagov/govuk-puppet)

The app-by-app migration plan to move GOV.UK to AWS introduced an `$app_domain_internal` parameter in addition to the previously used `$app_domain`.

This is necessary because in AWS we use a `<environment>.govuk-internal.digital` domain in addition to the `<environment>.govuk.digital` domain.

Furthermore, the `app_domain` parameter may be set to the `<environment>.publishing.service.gov.uk` for migrated apps as well. The exact configuration depends on the current state of the migrated app as well as its dependencies.

 For example, migrated backend applications, such as Support, may be configured to use the `<environment>.publishing.service.gov.uk` `$app_domain` to facilitate access to Signon over the internet.

 Applications in Carrenza which talk to AWS over the VPN need to resolve `<environment>.govuk-internal.digital`. The names under `govuk-internal.digital` point to private IP addresses in AWS.

At the moment this is only done for RabbitMQ exchange federation because the performance platform (backdrop) still depends on RabbitMQ.

As a rule of thumb:

- Applications which have been moved to AWS and have all their dependencies in AWS will use `$app_domain=<environment>.govuk.digital` and `$app_domain_internal=<environment>.govuk-internal.digital`.
- Applications which remain in Carrenza, including all their dependencies, will only use `app_domain=<environment>.publishing.service.gov.uk`.
- Applications having dependencies in both AWS and Carrenza will require some customisation of service resolution in form of a Plek URI override and may use either `$app_domain=<environment>.govuk.digital` or `$app_domain=<environment>.publishing.service.gov.uk`.

Note: we use [Plek](https://github.com/alphagov/plek) to generate the correct base URLs for internal GOV.UK services. These URLs can be overridden when a [Plek instance is instantiated](https://github.com/alphagov/plek/blob/master/lib/plek.rb#L29).

Since setting the correct service discovery environment for a particular app is complicated due to the migration to AWS, please take extra care to make sure you understand the effects of changes to the app_domain parameter and Plek URI overrides via environment variables.

If in doubt, please [talk to Reliability Engineering](https://docs.publishing.service.gov.uk/manual/raising-issues-with-reliability-engineering.html) to make sure your changes will not have unintended side effects.
