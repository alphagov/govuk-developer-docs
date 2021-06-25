---
owner_slack: "#govuk-2ndline"
title: Raise issues with Reliability Engineering
parent: "/manual.html"
layout: manual_layout
section: 2nd line
---

When on 2nd line you may experience an issue with GOV.UK that requires asking the Site Reliability Engineers (SREs) who work on GOV.UK infrastructure for assistance. The SREs previously worked in the RE GOV.UK team in Reliability Engineering, but currently they work as part of the Replatforming team. It is best to use RE GOV.UK channels for communication.

There are [Reliability Engineering docs](https://reliability-engineering.cloudapps.digital/) for users of their systems. There are also [other Reliability Engineering docs](https://re-team-manual.cloudapps.digital/) for use by the team, these may contain more technical details.

## If you require urgent assistance

Contact GOV.UK SREs have a slack channel - #govuk-2ndline.
By posting in that channel you can get their attention. This channel can be used for general queries too so do
indicate in your message that a problem is time critical.

It is also possible to "Run a Play" in the context of an ongoing incident page in PagerDuty. This will automatically call the RE engineer on duty both in- and out-of-hours.

## If you need to handover a long-standing incident

If this is in-hours: An Site Reliabilty Engineer from the RE GOV.UK team should take over the incident lead role. A 2nd line GOV.UK engineer will continue the comms lead role.
If this is out-of-hours: The primary GOV.UK engineer should be the incident lead. The secondary GOV.UK engineer should be the comms lead.

There is no longer an RE GOV.UK out of hours rota. GOV.UK engineers on the in-hours and out of hours rotas should have all access and documentation required to address any issues.

## If a problem is not urgent

If the issue you've identified seems like a non-urgent story you can add it the
[GOV.UK 2nd Line][2nd-line-trello] trello board in the "Proposed stories for
Platform Health" column. Platform Health will then decide whether to raise this
with RE, and manage the ticket through its life cycle, or to resolve this
problem themselves.

[2nd-line-trello]: https://trello.com/b/M7UzqXpk/govuk-2nd-line

## Raising a Zendesk ticket with Reliability Engineering

The official way to communicate with Reliability Engineering is through Zendesk
tickets.

To raise a ticket:

1. [Create a new ticket on Zendesk][new-zendesk-ticket]
1. Enter yourself as the requester
1. Set assignee to "3rd Line--GDS Reliability Engineering"
1. Add the 2nd Line Delivery Manager as a CC recipient
1. Fill in and submit ticket
1. Monitor and contribute to the ticket until it is resolved

[new-zendesk-ticket]: https://govuk.zendesk.com/agent/tickets/new/1

## Understanding what Reliability Engineering can assist with

There is a broad explanation of the different areas of support in GOV.UK in
[who do I ask for support?](/manual/who-do-i-ask-for-support.html).

More specificially to GOV.UK these are things that fall under the
responsibility of Reliability Engineering (RE):

- [GOV.UK Puppet](https://github.com/alphagov/govuk-puppet) - RE are
  responsible for maintenance and evolution, but as GOV.UK merge changes they
  can too be responsible for problems
- Upgrading software packages that are end-of-life/have security issues/no
  longer fit for purpose
- Running and maintaining the
  [Terraform configurations](https://github.com/alphagov/govuk-aws/) for AWS;
- Backup software such as Duplicity
- Maintaining the mirror configuration
- Keeping the CI environment running - GOV.UK are responsible for job
  configuration
- [Fabric scripts](https://github.com/alphagov/fabric-scripts)
