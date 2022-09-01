---
owner_slack: "#govuk-2ndline-tech"
title: 2nd line
parent: "/manual.html"
layout: manual_layout
section: 2nd line
type: learn
---

2ndline is the user support function of GOV.UK. 2nd line’s main responsibilities:

- Monitoring the state of the GOV.UK infrastructure
- Investigating and responding to technical bug reports
- Providing first line support to queries from data.gov.uk users
- Taking on urgent work or work that doesn’t necessarily belong in any team

You’ll be set up in [PagerDuty](/manual/2nd-line#pagerduty) so that you can be called if there are any urgent alerts during working hours. 2ndline shifts are a great opportunity to learn about the GOV.UK stack.

Every Monday, at least 2 people from GOV.UK - 2 developers and usually a shadow developer - join the team to work on Technical 2nd Line. [An ‘interruptible’ Site Reliability Engineer (SRE) is also available][].

> Technical 2nd line takes priority over the work you do in your usual team.

Shifts start at 9:30 and end at 17:30. [You can check the Technical 2nd Line rota to find out when your shift is][]. You are required to attend a daily morning standup with your paired 2ndline partner and the 2ndline team. There’s a short retrospective at the handover meeting at the end of your shift.

If you have meetings to attend then attend them. Please let the delivery manager and the team know when you’ll be away for long periods, and be respectful of the amount of work your colleagues may have to pick up while you’re away. If there are lots of alerts, you’ll need to prioritise Technical 2nd Line above your meetings.

## Monitoring

We have a [Technical 2nd Line dashboard][] showing a high level overview of the state of the GOV.UK environments. You can also [install our Chrome extension][] if you want a permanently visible overview. You will need to be on the [VPN](/manual/vpn.html) if accessing from home.

### Icinga

We use Icinga to monitor our platform and alert us when things go wrong. Many alerts have corresponding  documentation in these developer docs, detailing how to respond.

You should record critical alerts that aren't easily solved to the [GOV.UK Technical 2nd Line Trello board][] to help inform the Technical 2nd Line tech lead(s) and the GOV.UK SREs. Technical 2nd Line should investigate these alerts when there is downtime; you do not necessarily have to fix them.

[Read more about Icinga](/manual/icinga.html).

### PagerDuty

Some alerts are urgent enough to warrant immediate attention, such as parts of the site becoming unavailable or large quantities of error pages being served. We use [PagerDuty][] to notify the primary and secondary engineers on Technical 2nd Line during office hours (9:30am to 5:30pm), and on-call engineers outside of office hours.

[Read more about PagerDuty](/manual/pagerduty.html).

### Incidents

If there is a service outage or loss of functionality to a service (whether external or internal), or a security vulnerability is discovered, Technical 2nd Line will [declare an incident](/manual/incident-management-guidance.html).

## Zendesk

[Zendesk][zendesk] is our support ticketing system. When not dealing with incidents and alerts, we should be working through Zendesk tickets.

Read more about [processing Zendesk tickets on Technical 2nd Line](/manual/zendesk.html).

You will likely need to use [Grafana](/manual/grafana.html) to investigate service issues.

## Slack channels

Follow these Slack channels while working on Technical 2nd Line:

- `#govuk-2ndline-tech` - the main channel for people on technical 2nd line
- `#govuk-deploy` - every time a Staging/Production deploy is done, this is automatically posted to - people also manually post when putting branches on Integration for testing
- `#govuk-developers` - this is a general channel for developers and can be a good place to ask questions if you are struggling
- `#govuk-replatforming` - this is the channel for the Replatforming team, where the SREs are currently working. However, you should use #govuk-2ndline-tech to contact the RE interruptible person about urgent GOV.UK infrastructure issues.

[Technical 2nd Line dashboard]: https://alphagov.github.io/frame-splits/index.html?title=2nd+Line+Dashboard&layout=2x1-responsive&url%5B%5D=https%3A%2F%2Fgovuk-secondline-blinken.herokuapp.com%2Fblinken.html&url%5B%5D=https%3A%2F%2Fgrafana.production.govuk.digital%2Fdashboard%2Ffile%2F2ndline_health.json&url%5B%5D=https%3A%2F%2Fgovuk-zendesk-display-screen.herokuapp.com&url%5B%5D=
[GOV.UK Technical 2nd Line Trello board]: https://trello.com/b/M7UzqXpk/govuk-2nd-line
[install our Chrome extension]: https://github.com/alphagov/govuk-secondline-blinken#chrome-extension
[PagerDuty]: https://governmentdigitalservice.pagerduty.com
[Zendesk]: https://govuk.zendesk.com
[An ‘interruptible’ Site Reliability Engineer (SRE) is also available]:https://docs.publishing.service.gov.uk/manual/raising-issues-with-reliability-engineering.html
[You can check the Technical 2nd Line rota to find out when your shift is]:https://docs.google.com/spreadsheets/d/1OTVm_k6MDdCFN1EFzrKXWu4iIPI7uR9mssI8AMwn7lU/edit#gid=1297388378
