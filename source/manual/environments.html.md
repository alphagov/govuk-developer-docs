---
owner_slack: "#2ndline"
title: GOV.UK's environments (integration, staging, production)
section: Environments
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2017-11-22
review_in: 3 months
---

GOV.UK has several environments with different purposes.

## Continuous integration (CI)

Runs tests for applications. Hosted by Carrenza.

## Integration

Used by GOV.UK product teams to test changes to software.

Right now this environment is also used by content editors at GDS and in other departments
to preview their content changes. This functionality should be replaced by draft preview
functionality as part of the publishing platform.

Integration is [shut down each weekday night][jenkins-integration-shutdown] and [started each weekday morning][jenkins-integration-startup].

Integration is hosted by Carrenza in their Slough datacentre.

[jenkins-integration-shutdown]: https://github.com/alphagov/govuk-puppet/blob/850ac77f75f41be0bd34ff0a04bd59bff9e50c30/modules/govuk_jenkins/templates/jobs/stop_vapps.yaml.erb
[jenkins-integration-startup]: https://github.com/alphagov/govuk-puppet/blob/850ac77f75f41be0bd34ff0a04bd59bff9e50c30/modules/govuk_jenkins/templates/jobs/start_vapps.yaml.erb

## Staging

Used by GOV.UK product teams while deploying changes to ensure that they behave correctly
in a production-like environment. This means that staging must be similar to production
so that we're able to test things like the performance impact of changes.

Staging is primarily hosted by Carrenza in their London datacentre.

## Production

The thing that runs the website for real people.

Production is primarily hosted by Carrenza in their Slough datacentre.
