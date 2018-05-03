---
owner_slack: "#govuk-2ndline"
title: Name a new application or gem
section: Packaging
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-03-08
review_in: 6 months
---

This describes how you should name an application or gem on GOV.UK. It was first proposed in [RFC 63](https://github.com/alphagov/govuk-rfcs/blob/master/rfc-063-naming-new-apps-gems-on-gov-uk.md).

## Naming applications

Firstly, the [service manual has good guidance on naming things](https://www.gov.uk/service-manual/design/naming-your-service).

The most important rules:

- The name should be self-descriptive. No branding or puns.
- Use dashes for the URL and GitHub repo
- The name of the app should be the same on GitHub, Puppet and hostname

### Publishing applications

Applications that publish things are named **x-publisher**.

Good:

- specialist-publisher
- manuals-publisher

Not so good:

- publisher (too generic)
- contacts-admin (could be contacts-publisher)

### Frontend applications

Applications that render content to end users on GOV.UK are named
**x-frontend**

Good:

- government-frontend
- email-alert-frontend

Not so good:

- collections (could be collections-frontend)
- frontend (too generic)

### APIs

Applications that just expose an API are named **x-api**.

Good:

- publishing-api
- email-alert-api
- router-api

Not so good:

- rummager (should be search-api)

### Admin applications

Applications that "manage" things can be called **x-manager** or **x-admin** or
**thing-doer**.

Good:

- search-admin
- local-links-manager
- content-tagger

No so good:

- signonotron2000
- maslow (needs-manager)

## Naming gems

- Use the official [Rubygems naming convention](http://guides.rubygems.org/name-your-gem/)
- Use underscores for multiple words
- Use `govuk_` prefix if the gem is only interesting to projects within GOV.UK

Good:

- `govuk_sidekiq`
- `govuk_content_models`
- `govuk_admin_template`
- `vcloud-edge_gateway`

Not so good:

- `slimmer`
- `plek`
- `gds-sso` (should be `gds_sso`, or `govuk_sso`)
