---
owner_slack: "#govuk-2ndline-tech"
title: Technical 2nd line
parent: "/manual.html"
layout: manual_layout
section: 2nd line
type: learn
---

Technical 2nd Line is the user support function of GOV.UK.

Technical 2nd Line’s main responsibilities are:

- Monitoring the state of the GOV.UK infrastructure
- Investigating and responding to technical bug reports
- Taking on urgent work or work that doesn’t necessarily belong in any team

You’ll be set up in [PagerDuty](/manual/2nd-line#pagerduty) so that you can be called if there are any urgent alerts during working hours. Technical 2nd Line shifts are a great opportunity to learn about the GOV.UK stack.

Every Monday, at least 2 people from GOV.UK - a Primary and Secondary, and usually a Shadow - join the team to work on Technical 2nd Line. There are also standbys for the Primary and Secondary.

All of these roles can be fulfilled by developers and Site Reliability Engineers (SREs), whereas only some can be fulfilled by frontend developers, junior technologists and apprentices. See [role specific policies](#role-specific-policies) for details.

> Technical 2nd Line takes priority over the work you do in your usual team.

Shifts start at 9:30 and end at 17:30. [You can check the Technical 2nd Line rota to find out when your shift is][2ndline-rota].

[2ndline-rota]: https://docs.google.com/spreadsheets/d/1OTVm_k6MDdCFN1EFzrKXWu4iIPI7uR9mssI8AMwn7lU/edit#gid=1297388378.

You are required to attend a daily morning standup with your paired 2nd Line partner and the Technical 2nd Line team. There’s a short retrospective at the handover meeting at the end of your shift.

Standby developers are not expected to attend the standups or the incoming handover. If they're called onto the shift, they should attend the next standup, and may wish to attend the outgoing handover at the end of the shift.

If you have meetings to attend then attend them. Please let the delivery manager and the team know when you’ll be away for long periods, and be respectful of the amount of work your colleagues may have to pick up while you’re away. If there are lots of alerts, or there's a live incident, or an urgent Zendesk ticket, you’ll need to prioritise Technical 2nd Line above your meetings.

## Role specific policies

Backend developers and SREs are all expected to be on the in-hours and on-call rota, unless their head of community agrees that they have reason to opt out.

Frontend developers are expected to be on the in-hours rota, unless their head of community agrees that they have reason to opt out. They are _not_ expected to be on the on-call rota. Junior technologists and technologist apprentices are also expected to take part in the in-hours rota and not the on-call rota.

A junior technologist can be a shadow or a secondary, but won't be a primary.

A technologist apprentice will only fulfil the shadow role, and will be limited to Production Deploy access. However, if they are confident, they can request to be added to the secondary role and given Production Admin access, at their Line Manager's discretion.

See the [2nd line roles and Production Access flow diagram](https://docs.google.com/presentation/d/10oRKrXqYki7LSFUySjb1e_FdTYGLihMKjeoH9qWC1kU/edit) for a visualisation of these rules.

## Shift swaps, working patterns and sickness

Technical 2nd Line takes priority over the work you do in your usual team. It also takes priority over things like All Staff events, which you will be unable to attend in person, though can attend remotely (if possible) provided you keep on top of Zendesk and alerts. Note that standby developers can attend such events in person, but must be contactable by phone and able to access their laptop at short notice.

If you need to swap your shift, it’s your responsibility to ensure that adequate cover is in place.

- If you need cover for a day or two, arrange a swap for those days with another developer. Please ensure delivery managers are aware of this.

- If you need a whole shift swap, arrange this with another developer from your team.

For either of the above, let the Technical 2nd Line delivery manager know. Please update the schedule on [PagerDuty][].

If you cannot make your shift because you’re ill, message the delivery manager and #govuk-2ndline-tech Slack channel.
The corresponding standby developer will then take your place.

If your working patterns are not compatible with a 9.30am-5.30pm shift, let the Technical 2nd Line team know so they can find extra support.

If you do not work a 5-day week, please talk to your delivery manager to arrange cover with another developer on your team.

## Monitoring

We have a [Technical 2nd Line dashboard][] showing a high level overview of the state of the GOV.UK environments. You can also [install our Chrome extension][] if you want a permanently visible overview. You will need to be connected to the [GDS VPN][gds-vpn] if accessing from home.

### Icinga

We use Icinga to monitor our platform across our environments ([CI/Integration][], [Staging][], [Production][]) and alert us when things go wrong. Many alerts have corresponding documentation in our [GOV.UK developer docs][], detailing how to respond. [Read more about Icinga][].

If you see critical alerts that aren't easily solved, start a thread in the #govuk-2ndline-tech Slack channel.

NB: Technical 2nd Line should investigate these alerts when there is nothing more urgent happening; you do not necessarily have to fix them.

### Grafana

We use Grafana dashboards to monitor the health of our applications and service across our environments ([Integration](https://grafana.blue.integration.govuk.digital/?orgId=1), [Staging](https://grafana.blue.staging.govuk.digital/?orgId=1), [Production](https://grafana.blue.production.govuk.digital/). Some useful dashboards include:

- Second line, which includes data from our Origin health and Edge health dashboards
- Sidekiq
- Application deployment dashboards

[Read more about Grafana](/manual/grafana.html).

### PagerDuty

Some alerts are urgent enough to warrant immediate attention, such as parts of the site becoming unavailable or large quantities of error pages being served. We use [PagerDuty][] to notify the primary and secondary engineers on Technical 2nd Line during office hours (9:30am to 5:30pm), and on-call engineers outside of office hours. We carry out a [Pagerduty drill](/manual/pagerduty.html#pagerduty-drill) every Wednesday morning at 10am UTC.

[Read more about PagerDuty](/manual/pagerduty.html).

## Incidents

If there is a service outage or loss of functionality to a service (whether external or internal), or a security vulnerability is discovered, Technical 2nd Line will [declare an incident](/manual/incident-management-guidance.html) and write up an incident report. We normally review incidents on Mondays at 2-3pm.

## Zendesk

[Zendesk][zendesk] is our support ticketing system. When not dealing with incidents and alerts, we should be working through Zendesk tickets.

Read more about [processing Zendesk tickets on Technical 2nd Line](/manual/zendesk.html).

## 2nd Line Trello Board

We use the [GOV.UK Technical 2nd Line Trello board][] to capture pieces of work 2nd Line are required to do, such as:

- Leaver tickets
- Setting up production access
- Recording technical issues

The board is reviewed during the weekly Technical 2nd Line handover meeting, where developers can talk the next team through any new cards and oustanding issues.

It's your responsibility to help keep this board up to date for the next 2nd Line team.

At the start of your Technical 2nd Line shift you should:

- Read through the cards under [Ongoing issues, useful Info & unexplained events](https://trello.com/c/TwquoCfW/316-readme) so that you're aware of any ongoing problems that have already been identified. You should try to investigate these issues when there is nothing more urgent happening. At the end of your shift please comment on cards as to whether you saw this issue/alert. This will help the Technical 2nd Line leads review them over a longer period of time and identify any stale cards

When creating a new card please include:

- A summary of the issue
- A screenshot of the alert/issue
- Any additional information that maybe be lost over time e.g. logs
- Links to related Zendesk tickets and suggested reply to users
- Any investigation you have done so far/steps you have taken as a workaround

This will help inform developers, Technical 2nd Line tech lead(s), and the GOV.UK SREs about known issues.

## Slack channels

Follow these Slack channels while working on Technical 2nd Line:

- [#govuk-2ndline-tech] - the main channel for people on Technical 2nd Line
- [#govuk-deploy] - every time a Staging/Production deploy is done, this is automatically posted to - people also manually post when putting branches on Integration for testing
- [#govuk-developers] - this is a general channel for developers and can be a good place to ask questions if you are struggling
- [#govuk-platform-engineering] - Platform Engineering team looks after the GOV.UK Kubernetes clusters and base images

[Technical 2nd Line dashboard]: https://govuk-2ndline-dashboard.herokuapp.com/
[GOV.UK Technical 2nd Line Trello board]: https://trello.com/b/M7UzqXpk/govuk-2nd-line
[install our Chrome extension]: https://github.com/alphagov/govuk-secondline-blinken#chrome-extension
[PagerDuty]: https://governmentdigitalservice.pagerduty.com
[Zendesk]: https://govuk.zendesk.com
[You can check the Technical 2nd Line rota to find out when your shift is]:https://docs.google.com/spreadsheets/d/1OTVm_k6MDdCFN1EFzrKXWu4iIPI7uR9mssI8AMwn7lU/edit#gid=1297388378
[CI/Integration]: https://alert.integration.publishing.service.gov.uk/
[Staging]: https://alert.blue.staging.govuk.digital/
[Production]: https://alert.blue.production.govuk.digital/
[GOV.UK developer docs]: /
[Read more about Icinga]: /manual/icinga.html
[Alerts which don't add value]: https://trello.com/c/A3mKmh5s/583-this-column-is-to-record-the-same-alerts-are-coming-up-again-and-again-but-cant-action-when-it-spikes
[Ongoing issues, useful Info & unexplained events]: https://trello.com/c/TwquoCfW/316-readme
[Missing documentation]: https://trello.com/c/owAK2OjY/1009-please-use-this-column-to-record-any-missing-documentation-you-notice-and-were-not-able-to-add-during-your-shift
[gds-vpn]: https://docs.google.com/document/d/1O1LmLByDLlKU4F1-3chwS8qddd2WjYQgMaaEgTfK5To/edit
[#govuk-2ndline-tech]: https://gds.slack.com/channels/govuk-2ndline-tech
[#govuk-deploy]: https://gds.slack.com/channels/govuk-deploy
[#govuk-developers]: https://gds.slack.com/channels/govuk-developers
[#govuk-platform-engineering]: https://gds.slack.com/channels/govuk-platform-engineering
