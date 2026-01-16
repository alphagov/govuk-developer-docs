---
owner_slack: "#govuk-platform-engineering-team"
title: Ask for help
parent: "/manual.html"
layout: manual_layout
section: Learning GOV.UK
---

If you and your colleagues can’t resolve a technical issue, problem or question, you should try talking with (in this order):

1. Your tech lead (TL)
1. [#govuk-tech-leads](https://gds.slack.com/channels/govuk-tech-leads)
1. The [senior tech team](#contact-senior-tech)

## Contact Senior Tech

You can ping `@govuk-senior-tech-people` on Slack, or email [govuk-senior-tech-members](https://groups.google.com/a/digital.cabinet-office.gov.uk/g/govuk-senior-tech-members/members).

## Contact Technical Support of the relevant area of GOV.UK

There are channels for each area of GOV.UK:

- `#govuk-ask-platform-engineering`
- `#govuk-publishing-service-support`
- `#govuk-web-support`

In addition, there's a `#govuk-technical-on-call` channel that can be used to communicate with the on-call engineers in a public forum. However, bear in mind that Slack does not page their phones, so whereas in-hours you may be able to `@` the on-call engineer, out-of-hours you'll need to contact via PagerDuty.

## Ask the developer communities

### The GOV.UK developer community ([#govuk-developers])

- helps each other with specialised knowledge about specific areas of the platform
- supports each other with issues deploying changes to GOV.UK
- ensures missions are delivered technically in the best and most appropriate way

### GOV.UK [Platform Engineering] team ([#govuk-ask-platform-engineering])

- manages the Kubernetes clusters and base images for running GOV.UK applications
- works on long-term improvements to the efficiency, reliability and security of GOV.UK
- supports CI/CD (build, release, rollout) automation
- manages some access control automation such as govuk-user-reviewer
- can offer advice on monitoring and alerting
- can offer design reviews and advice to help build your application for
  reliability, robustness and low maintenance (especially at the early stages of
  the software lifecycle)
- can offer advice and assistance with changes such as migrating from one
  database to another safely and efficiently

[#govuk-developers]: https://gds.slack.com/channels/govuk-developers
[#govuk-ask-platform-engineering]: https://gds.slack.com/channels/govuk-ask-platform-engineering
[Platform Engineering]: /platform-engineering.html
