---
owner_slack: "#govuk-developers"
title: Zendesk
parent: "/manual.html"
layout: manual_layout
section: Learning GOV.UK
type: learn
---

Zendesk is a support ticket system used across GOV.UK. Tickets are raised by:

- Members of the public (e.g. via the [GOV.UK contact form](https://www.gov.uk/contact/govuk))
- Government departments (e.g. via one of the forms on the [GOV.UK Support app](https://support.publishing.service.gov.uk/))
- Members of GDS (e.g. directly through <https://govuk.zendesk.com>)

## Service Level Agreements

GOV.UK have [committed to a minimum service level agreement](https://www.gov.uk/guidance/contact-the-government-digital-service/how-to-contact-gds) for tickets:

- 80% of tickets get a first reply to the ticket within 2 working days
- 80% of general enquiries (public tickets) resolved within 5 working days
- 70% of department tickets are closed within 5 working days

## Get started

[Create an account](https://govuk.zendesk.com/auth/v2/login/registration?auth_origin=3194076%2Cfalse%2Ctrue&amp;brand_id=3194076&amp;return_to=https%3A%2F%2Fgovuk.zendesk.com%2Fhc%2Fen-us&amp;theme=hc) then assign a new ticket to `2nd/3rd Line--Zendesk Administration` asking to give you "GDS Resolver Agent" access to [your product team's Zendesk group](#where-to-triage-tickets).

See the [Zendesk best practice slidedeck](https://docs.google.com/presentation/d/1iUbD-_uWyaNMeNj9h7Zvo9g2GWvRarg9kUh7pd0u32M/edit#slide=id.g134fafb13dc_0_0) for an overview and tour of the service.

In addition, you may want to bookmark these links for searching Zendesk:

- [Tickets you've commented on](https://govuk.zendesk.com/agent/search/1?type=ticket&q=commenter%3Ame)
- [Tickets you've been cc'd on](https://govuk.zendesk.com/agent/search/1?q=cc%3Ame)

Read the [Zendesk documentation](https://support.zendesk.com/hc/en-us/articles/4408835086106-Using-Zendesk-Support-advanced-search) for advanced search options.

## Where to triage tickets

Triage to the most applicable area of GOV.UK using the associated macro below. After using the macro, submit the ticket as open. This is also represented visually on the [Zendesk flow diagram](https://docs.google.com/presentation/d/1EotoM2CVtqlnx54Qz5bP7OyIx5c9ji_GptUuymHkBrc/edit).

| Zendesk view | Macro for triaging to this view | Responsible for |
|--------------|---------------------------------|----------|
| [GOV.UK Publishing Service Support](https://govuk.zendesk.com/agent/filters/5273818481554) | [Triage to GOV.UK Publishing Service Support](https://govuk.zendesk.com/admin/workspaces/agent-workspace/macros/13679777581980) | Publishing apps, unpublishing content, etc |
| [GOV.UK Web Support](https://govuk.zendesk.com/agent/filters/360000012465) | [Triage to GOV.UK Web Support](https://govuk.zendesk.com/admin/workspaces/agent-workspace/macros/13679771783708) | User-facing GOV.UK, emails, GOV.UK search, GOV.UK chat, postcode lookup etc  |
| [GOV.UK Platform Support](https://govuk.zendesk.com/agent/filters/12863141605916) | [Triage to GOV.UK Platform Support](https://govuk.zendesk.com/admin/workspaces/agent-workspace/macros/13672505486492) | Developer tools, Terraform, DNS / domains, Content Data, Slack bots, etc |
| [data.gov.uk support](https://govuk.zendesk.com/agent/filters/1900002360214) | [Triage to data.gov.uk support](https://govuk.zendesk.com/admin/workspaces/agent-workspace/macros/13813477886620) | data.gov.uk (DGU), CKAN |
| [GOV.UK Data Support](https://govuk.zendesk.com/agent/filters/13388501247260) | [Triage to GOV.UK Data Support](https://govuk.zendesk.com/admin/workspaces/agent-workspace/macros/13661730061340) | Related links, Google Analytics, GovSearch, etc |
| [GOV.UK Campaigns Tech Support](https://govuk.zendesk.com/agent/filters/8935249582876) | [Triage to GOV.UK Campaign Support](https://govuk.zendesk.com/admin/workspaces/agent-workspace/macros/13792771654300) | Anything to do with the [campaign platform](https://userguide.campaign.gov.uk/) |

Most technical tickets are triaged automatically to the correct place via the "trigger rules" in Zendesk - see [Zendesk triggers for technical GOV.UK groups](#zendesk-triggers-for-technical-govuk-groups). If no specific trigger rule has been configured, tickets go straight to GDS's User Support team, who then triage tickets on to other teams where appropriate.

Other useful groups:

- Content support for queries from publishers etc - `2nd Line--GOV.UK Content Triage, Gov't` ("Triage to GOV.UK 2nd line content - govt support" macro)
- Content support for queries from general public - `2nd Line--GOV.UK Content Triage, Public`
- Content support for publishers with Signon/permissions issues - `3rd line--GOV.UK Content Training and Accounts`
- GOV.UK Policy & Strategy - `3rd Line--GOV.UK Policy and Strategy`
- GDPR and Privacy enquiries - `3rd Line--GDS Privacy`
- Licensing - `1st Line--Licensing Support`
- Security issues - `3rd Line--Cyber Security`
- User Support - `2nd Line--User Support Escalation`
- GOV.UK Forms - `1st Line--GOV.UK Forms`

## Zendesk triggers for technical GOV.UK groups

Every product area should have its own view of Zendesk tickets and an optional set of 'triggers' that automatically assign certain tickets to said view. Some triggers also [notify Slack](#slack-triggers).

| Zendesk view | Triggers |
|--------------|----------|
| [GOV.UK Publishing Service Support](https://govuk.zendesk.com/agent/filters/5273818481554) | [Email](https://govuk.zendesk.com/admin/objects-rules/rules/triggers/5591644703004), [Initial routing: Route 'publishing service' tickets raised via Support app](https://govuk.zendesk.com/admin/objects-rules/rules/triggers/14230797794460), [Tell GOV.UK Publishing Service Support about new ticket](https://govuk.zendesk.com/admin/objects-rules/rules/triggers/13776514277660) |
| [GOV.UK Web Support](https://govuk.zendesk.com/agent/filters/360000012465) | [Email](https://govuk.zendesk.com/admin/objects-rules/rules/triggers/16165694317596), [Initial routing: Route 'web' support tickets raised via Support app](https://govuk.zendesk.com/admin/objects-rules/rules/triggers/14231993238556), [Tell GOV.UK Web Support about new ticket](https://govuk.zendesk.com/admin/objects-rules/rules/triggers/13478776988188) |
| [GOV.UK Platform Support](https://govuk.zendesk.com/agent/filters/12863141605916) | [Email](https://govuk.zendesk.com/admin/objects-rules/rules/triggers/13149293739804), [Initial routing: Route 'platform' support tickets raised via Support app](https://govuk.zendesk.com/admin/objects-rules/rules/triggers/17923494146332) [Automatically close unactionable hostmaster tickets](https://govuk.zendesk.com/admin/objects-rules/rules/triggers/13991870416156), [Tell GOV.UK Platform Support about new ticket](https://govuk.zendesk.com/admin/objects-rules/rules/triggers/12864044593692) |
| [data.gov.uk support](https://govuk.zendesk.com/agent/filters/1900002360214) | [Tell GOV.UK data.gov.uk Support about new ticket](https://govuk.zendesk.com/admin/objects-rules/rules/triggers/14643274949020) |
| [GOV.UK Data Support](https://govuk.zendesk.com/agent/filters/13388501247260) | [Tell GOV.UK Data Support about new ticket](https://govuk.zendesk.com/admin/objects-rules/rules/triggers/14607012989980) |
| [GOV.UK Campaigns Tech Support](https://govuk.zendesk.com/agent/filters/8935249582876) | [Email](https://govuk.zendesk.com/admin/objects-rules/rules/triggers/4951487443986), [Initial Routing: Gov't Form new campaign requests to 3rd Line - GOV.UK Policy and Strategy](https://govuk.zendesk.com/admin/objects-rules/rules/triggers/30476171) |

Some triggers power Slack notifications via the Zendesk/Slack integration. For example, the [Tell GOV.UK Platform Support about new ticket](https://govuk.zendesk.com/admin/objects-rules/rules/triggers/12864044593692) trigger checks whether a `slack_has_been_notified` tag is present on the ticket, as well as whether or not this is the kind of ticket we're interested in (must be in `1st Line--GOV.UK Web Support` and must not contain a tag irrelevant to Platform, e.g. `govuk_data_support`). Only if the tag is absent do the corresponding trigger 'actions' fire, which are "Zendesk integration" (the thing that fires the Slack message) and also "Add tags". Here, we add the `slack_has_been_notified` tag, meaning only one notification is sent per ticket, which reduces noise. We also add the `govuk_platform_support` tag here.
