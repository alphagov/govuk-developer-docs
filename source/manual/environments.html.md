---
owner_slack: "#govuk-developers"
title: GOV.UK's environments (integration, staging, production)
section: Infrastructure
type: learn
layout: manual_layout
parent: "/manual.html"
---

GOV.UK has several environments with different purposes.

For a quick view of what's where, you can use the [release app](https://release.publishing.service.gov.uk).

## Continuous integration (CI)

Runs tests for applications. Hosted on Carrenza.

## Integration

Used by GOV.UK product teams to test changes to software.

Right now this environment is also used by content editors at GDS and in other departments
to preview their content changes. This functionality should be replaced by draft preview
functionality as part of the publishing platform.

Integration is hosted on [AWS][govuk-in-aws].

[govuk-in-aws]: /manual/govuk-in-aws.html

## Staging

Used by GOV.UK product teams while deploying changes to ensure that they behave correctly
in a production-like environment. This means that staging must be similar to production
so that we're able to test things like the performance impact of changes.

Staging is hosted on [AWS][govuk-in-aws].

Access to Staging is restricted to office IPs, so you'll need to [be
on the VPN](manual/get-started.html#4-connecting-to-the-gds-vpn).
AWS configuration can be found in
[govuk-aws-data](https://github.com/alphagov/govuk-aws/blob/master/terraform/projects/infra-security-groups/cache.tf).

## Production

The thing that runs the website for real people.

Production is hosted on [AWS][govuk-in-aws].
