---
owner_slack: "#govuk-2ndline"
title: 2nd line
parent: "/manual.html"
layout: manual_layout
section: 2nd line
type: learn
---

2nd line has three main responsibilities:

- Monitoring the state of the GOV.UK infrastructure
- Investigating and responding to technical bug reports
- Providing first line support to queries from data.gov.uk users
- Taking on urgent work or work that doesn't necessarily belong in any team

If you're new to 2nd line, read about our [working patterns, ceremonies and policies](/manual/welcome-to-2nd-line.html).

## Monitoring

We have a [2nd line dashboard][] showing a high level overview of the state of the GOV.UK environments. You can also [install our Chrome extension][] if you want a permanently visible overview. You will need to be on the [VPN](/manual/vpn.html) if accessing from home.

### Icinga

We use Icinga to monitor our platform and alert us when things go wrong. Many alerts have corresponding  documentation in these developer docs, detailing how to respond.

You should record critical alerts that aren't easily solved to the [GOV.UK 2nd line Trello board][] to help inform the 2nd line tech lead(s) and the GOV.UK SREs. 2nd line should investigate these alerts when there is downtime; you do not necessarily have to fix them.

[Read more about Icinga](/manual/icinga.html).

### PagerDuty

Some alerts are urgent enough to warrant immediate attention, such as parts of the site becoming unavailable or large quantities of error pages being served. We use [PagerDuty][] to notify the primary and secondary engineers on 2nd line during office hours (9:30am to 5:30pm), and on-call engineers outside of office hours.

[Read more about PagerDuty](/manual/pagerduty.html).

### Incidents

If there is a service outage or loss of functionality to a service (whether external or internal), or a security vulnerability is discovered, 2nd line will [declare an incident](/manual/incident-management-guidance.html).

## Zendesk

[Zendesk][zendesk] is our support ticketing system. When not dealing with incidents and alerts, we should be working through Zendesk tickets.

Read more about [processing Zendesk tickets on 2nd line](/manual/zendesk.html).

You will likely need to use [Grafana](/manual/grafana.html) to investigate service issues.

## Slack channels

Follow these Slack channels while working on 2nd line:

- `#govuk-2ndline` - the main channel for people on technical 2nd line
- `#govuk-deploy` - every time a Staging/Production deploy is done, this is automatically posted to - people also manually post when putting branches on Integration for testing
- `#govuk-developers` - this is a general channel for developers and can be a good place to ask questions if you are struggling
- `#govuk-replatforming` - this is the channel for the Replatforming team, where the SREs are currently working. However, you should use #govuk-2ndline to contact the RE interruptible person about urgent GOV.UK infrastructure issues.

[2nd line dashboard]: https://alphagov.github.io/frame-splits/index.html?title=2nd+Line+Dashboard&layout=2x1-responsive&url%5B%5D=https%3A%2F%2Fgovuk-secondline-blinken.herokuapp.com%2Fblinken.html&url%5B%5D=https%3A%2F%2Fgrafana.production.govuk.digital%2Fdashboard%2Ffile%2F2ndline_health.json&url%5B%5D=https%3A%2F%2Fgovuk-zendesk-display-screen.herokuapp.com&url%5B%5D=
[GOV.UK 2nd line Trello board]: https://trello.com/b/M7UzqXpk/govuk-2nd-line
[install our Chrome extension]: https://github.com/alphagov/blinkenjs#chrome-extension
[PagerDuty]: https://governmentdigitalservice.pagerduty.com
[Zendesk]: https://govuk.zendesk.com
