---
owner_slack: "#2ndline"
title: GOV.UK's environments (integration, staging, production)
section: Environments
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/infrastructure/architecture/environments.md"
last_reviewed_at: 2017-02-11
review_in: 6 months
---

> **This page was imported from [the opsmanual on github.gds](https://github.gds/gds/opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.gds/gds/opsmanual/tree/master/infrastructure/architecture/environments.md)


# GOV.UK's environments (integration, staging, production)

GOV.UK has several environments with different purposes.

## Continuous integration (CI)

Runs tests for applications. Hosted by Skyscape.

## Integration

Used by GOV.UK product teams to test changes to software.

Right now this environment is also used by content editors at GDS and in other departments
to preview their content changes. This functionality should be replaced by draft preview
functionality as part of the publishing platform.

Integration is hosted by Carrenza in their Slough datacentre.

## Staging

Used by GOV.UK product teams while deploying changes to ensure that they behave correctly
in a production-like environment. This means that staging must be similar to production
so that we're able to test things like the performance impact of changes.

Staging is primarily hosted by Carrenza in their London datacentre.

## Production

The thing that runs the website for real people.

Production is primarily hosted by Carrenza in their Slough datacentre.
