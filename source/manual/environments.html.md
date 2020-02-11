---
owner_slack: "#govuk-developers"
title: GOV.UK's environments (integration, staging, production)
section: Infrastructure
type: learn
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-11-06
review_in: 3 months
---

GOV.UK has several environments with different purposes.

For a quick view of what's where, you can use the release app.

## Continuous integration (CI)

Runs tests for applications. Hosted by Carrenza.

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

Staging is primarily hosted by Carrenza in their London datacentre.
It is currently being migrated to [AWS][govuk-in-aws]. Check individual application developer
docs to see if it is hosted with AWS or Carrenza.

## Production

The thing that runs the website for real people.

Production is primarily hosted by Carrenza in their Slough datacentre.
It is currently being migrated to [AWS][govuk-in-aws]. Check individual application developer
docs to see if it is hosted with AWS or Carrenza.
