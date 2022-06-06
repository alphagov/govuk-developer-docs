---
owner_slack: "#govuk-developers"
title: Application ownership
section: Applications
layout: manual_layout
parent: "/manual.html"
---

This describes what ownership of a GOV.UK application means in practice.

## What ownership means

The owner of an application is responsible for:

- keeping its code up to date (eg dependency updates and Rails/Ruby upgrades etc), in line with [our policy on keeping software current][software-policy]. This includes monitoring relevant CVEs and making informed decisions, taking into account any risk, on when to upgrade. The relevant team should be marked as owner in this [configuration file][repos-yaml], which is used to render the [list of all GOV.UK repositories][repos-list].
- Sentry alerts. The relevant team will ideally set up [Slack alerting][sentry-slack-alerts]
- monitoring performance, including setting any Service Level Objectives/Indicators or similar measures
- maintaining and prioritising a backlog, to include improvements and bug-fixing
- dealing with any security issues arising from IT healthchecks etc
- actions arising from incident reviews (the Tech Lead and/or Product Manager should attend any incident review relating to the application)
- making lifecycle decisions about the application, including if it should be retired. An application only exists to serve a purpose, and teams should feel empowered to create and retire them as needed
- strategic thinking and planning around the application and how it fits with others
- deciding to implement controls around who can review or merge code to their application

## What ownership doesn't mean

- The owner team isn’t the only team that contributes changes to the app. The owning team should be made aware of and consulted on any changes, and have the final say over whether a proposed change is merged (including through PR merge permissions)
- As with all complex systems, the owning team isn't expected to know every detail about an app. Teams are expected to increase their understanding over time
- Ownership of an application doesn’t necessarily mean that the application is regularly improved. It might mean the team plays more of a “custodian” role - only fixing security issues and urgent bugs rather than adding features.

[software-policy]: /manual/keeping-software-current.html
[repos-yaml]: https://github.com/alphagov/govuk-developer-docs/blob/main/data/repos.yml
[repos-list]: /repos.html
[sentry-slack-alerts]: /manual/sentry.html#slack-alerts
