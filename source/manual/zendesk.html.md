---
owner_slack: "#govuk-2ndline-tech"
title: Zendesk
parent: "/manual.html"
layout: manual_layout
section: 2nd line
type: learn
---

Zendesk is a support ticket system used across GOV.UK. See the [Zendesk best practice slidedeck](https://docs.google.com/presentation/d/1iUbD-_uWyaNMeNj9h7Zvo9g2GWvRarg9kUh7pd0u32M/edit#slide=id.g134fafb13dc_0_0) for an overview and tour of the service. Zendesk includes tickets raised by:

- Members of the public (e.g. via the [GOV.UK contact form](https://www.gov.uk/contact/govuk))
- Government departments (e.g. via one of the forms on the [GOV.UK Support app](https://support.publishing.service.gov.uk/))
- Members of GDS (e.g. directly through <https://govuk.zendesk.com>)

Unless configured otherwise, many tickets go straight to GDS's User Support team, who then triage tickets on to other teams (such as Technical 2nd Line) where appropriate. GOV.UK has comitted to a [service level agreement](#service-level-agreements) for ticket response and resolution times.

## Summary of GOV.UK Zendesk groups

Every product area should have its own view of Zendesk tickets, a macro to make it easier for staff to triage tickets into said view, and an optional set of 'triggers' that automatically assign certain tickets to said view. Some triggers also [notify Slack](#slack-triggers).

| Zendesk view | Macro for triaging to this view | Triggers |
|--------------|---------------------------------|----------|
| [Technical 2nd Line](https://govuk.zendesk.com/agent/filters/10864660813212) | N/A | [Email](https://govuk.zendesk.com/admin/objects-rules/rules/triggers/11509330463644), [Initial Routing: Gov't Form publisher tech fault requests to 2nd Line--GOV.UK Alerts and Issues](https://govuk.zendesk.com/admin/objects-rules/rules/triggers/35985647) |
| [data.gov.uk support](https://govuk.zendesk.com/agent/filters/1900002360214) | [Triage to data.gov.uk support](https://govuk.zendesk.com/admin/workspaces/agent-workspace/macros/13813477886620) | N/A |
| [GOV.UK Platform Support](https://govuk.zendesk.com/agent/filters/12863141605916) | [Triage to GOV.UK Platform Support](https://govuk.zendesk.com/admin/workspaces/agent-workspace/macros/13672505486492) | [Email](https://govuk.zendesk.com/admin/objects-rules/rules/triggers/13149293739804), [Tell GOV.UK Platform Support about new ticket](https://govuk.zendesk.com/admin/objects-rules/rules/triggers/12864044593692) |
| [GOV.UK Publishing Service Support](https://govuk.zendesk.com/agent/filters/5273818481554) | [Triage to GOV.UK Publishing Service Support](https://govuk.zendesk.com/admin/workspaces/agent-workspace/macros/13679777581980) | [Email](https://govuk.zendesk.com/admin/objects-rules/rules/triggers/5591644703004), [Tell GOV.UK Publishing Service Support about new ticket](https://govuk.zendesk.com/admin/objects-rules/rules/triggers/13776514277660) |
| [GOV.UK Web Support](https://govuk.zendesk.com/agent/filters/360000012465) | [Triage to GOV.UK Web Support](https://govuk.zendesk.com/admin/workspaces/agent-workspace/macros/13679771783708) | [Tell GOV.UK Web Support about new ticket](https://govuk.zendesk.com/admin/objects-rules/rules/triggers/13478776988188) |
| [GOV.UK Campaigns Tech Support](https://govuk.zendesk.com/agent/filters/8935249582876) | [Triage to GOV.UK Campaign Support](https://govuk.zendesk.com/admin/workspaces/agent-workspace/macros/13792771654300) | [Email](https://govuk.zendesk.com/admin/objects-rules/rules/triggers/4951487443986), [Initial Routing: Gov't Form new campaign requests to 3rd Line - GOV.UK Policy and Strategy](https://govuk.zendesk.com/admin/objects-rules/rules/triggers/30476171) |
| [GOV.UK Data Support](https://govuk.zendesk.com/agent/filters/13388501247260) | [Triage to GOV.UK Data Support](https://govuk.zendesk.com/admin/workspaces/agent-workspace/macros/13661730061340) | N/A |

Other useful groups:

- Content support - `2nd Line--GOV.UK Content Triage, Gov't` and `2nd Line--GOV.UK Content Triage, Public`
- Signon/permissions issues - `3rd line--GOV.UK Content Training and Accounts`
- GOV.UK Policy & Strategy - `3rd Line--GOV.UK Policy and Strategy`
- GDPR and Privacy enquiries - `3rd Line--GDS Privacy`
- Licensing - `1st Line--Licensing Support`
- Security issues - `3rd Line--Cyber Security`
- User Support - `2nd Line--User Support Escalation`

### Slack triggers

We're making increasing use of the Zendesk/Slack integration, which is powered by Zendesk 'triggers'.

For example, the [Tell GOV.UK Platform Support about new ticket](https://govuk.zendesk.com/admin/objects-rules/rules/triggers/12864044593692) trigger checks whether a `slack_has_been_notified` tag is present on the ticket, as well as whether or not this is the kind of ticket we're interested in (must be in `2nd Line--GOV.UK Alerts and Issues` and must have at least one tag relevant to Platform, e.g. `fault_with_content_data`).

Only if the tag is absent do the corresponding trigger 'actions' fire, which are "Zendesk integration" (the thing that fires the Slack message) and also "Add tags". We add `slack_has_been_notified` (meaning only one notification is sent per ticket, which reduces noise), and also `govuk_platform_support`, which is the only tag that drives the [GOV.UK Platform Support view](https://govuk.zendesk.com/agent/filters/12863141605916). This means that the only place we need to define our set of platform-related tags is in the "Tell GOV.UK Platform Support about new ticket" trigger.

## Useful searches

- [Tickets you have commented on](https://govuk.zendesk.com/agent/search/1?type=ticket&q=commenter%3Ame)
- Read the [Zendesk documentation](https://support.zendesk.com/hc/en-us/articles/4408835086106-Using-Zendesk-Support-advanced-search) for advanced search options

## Service Level Agreements

GOV.UK have [committed to a minimum service level agreement](https://www.gov.uk/guidance/contact-the-government-digital-service/how-to-contact-gds) for tickets:

- 80% of tickets get a first reply to the ticket within 2 working days
- 80% of general enquiries (public tickets) resolved within 5 working days
- 70% of department tickets are closed within 5 working days

## Technical 2nd Line

### Get started

[Create an account](https://govuk.zendesk.com/auth/v2/login/registration?auth_origin=3194076%2Cfalse%2Ctrue&amp;brand_id=3194076&amp;return_to=https%3A%2F%2Fgovuk.zendesk.com%2Fhc%2Fen-us&amp;theme=hc) then assign a new ticket to `2nd/3rd Line--Zendesk Administration` asking to give you "GDS Resolver Agent" access to `2nd Line--GOV.UK Alerts and Issues`.

When you've logged in, navigate to the `2nd Line--GOV.UK Alerts and Issues` view (see [Summary of GOV.UK Zendesk groups](#summary-of-govuk-zendesk-groups)).

### Workflow

Work on 'High' priority tickets first - these will have been triaged by Technical 2nd Line already, so should be relevant and actionable - and start with the oldest "Updated" date. If there are no High priority tickets, work on the "Normal" priority tickets, again starting with the oldest "Updated" date.

Most tickets should be triaged to the most relevant product team, who are more likely to be able to help the user more quickly than a 2nd line engineer who lacks context of the product. Follow the [Zendesk flow diagram](https://docs.google.com/presentation/d/1EotoM2CVtqlnx54Qz5bP7OyIx5c9ji_GptUuymHkBrc/edit) to know who to triage to, and when. 'Urgent' work should still be carried out by Technical 2nd Line at this stage.

When picking up a ticket, click the "take it" link under "Assignee", and write a "Public Reply" to inform the user you're looking into the issue (click "Internal note" to change the response type). Finally, click "Submit as Open", to formally undertake a ticket.

You can use Internal Notes to keep a log of actions you've taken so far: this can make it easier for other staff to pick up where you left off if you're unable to solve the ticket yourself. If you run a rake task or execute code directly on a console, include a copy of the commands you ran as an internal note on the ticket.

> Please note that departments can see internal notes, so don’t write anything you wouldn’t say to someone publicly.

If you need more information from the user, fill in the "Public reply" as appropriate and click "Submit as Pending" to indicate the ticket is awaiting a response from the user. Note that if a ticket has been pending a response for 5 or more days with no response from the requester, you can submit it as solved: do this by clicking the "Apply macro" button at the bottom of the ticket screen, then choosing the "GOV.UK 2nd line tech: pending for 5+ days" option.

When you think you've resolved a ticket, click "Submit as Solved". You do not need to wait for user confirmation to close the ticket - they can always reopen the ticket if they still need assistance.
