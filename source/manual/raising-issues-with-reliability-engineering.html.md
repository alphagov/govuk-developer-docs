---
owner_slack: "#govuk-2ndline"
title: Raising issues with Reliability Engineering
parent: "/manual.html"
layout: manual_layout
section: 2nd line
last_reviewed_on: 2019-01-29
review_in: 3 months
---

Reliability Engineering are a programme in GDS, they are responsible for the
infrastructure that most GDS software runs on and the underlying network
configuration. They also provide shared software services used by
various GDS programmes such as logging and monitoring tools.

When on 2nd line you may experience an issue with GOV.UK that requires asking
Reliability Engineering for assistance.

There are [Reliability Engineering docs](https://reliability-engineering.cloudapps.digital/) for users of their systems. There are also [other Reliability Engineering docs](https://re-team-manual.cloudapps.digital/) for use by the team, these may contain more technical details.

## If you require urgent assistance

Reliability Engineering have a Slack channel - #reliability-eng - and they
have an assigned interruptible person. By posting in that channel you can get
their attention. This channel can be used for general queries too so do
indicate in your message that a problem is time critical.

Failing slack communication you can also walk over to Reliability Engineering
desks and talk to the interruptible person directly - they are currently on
the 6th floor near bank 27-28.

You may be advised to create a
[Zendesk ticket](#raising-a-zendesk-ticket-with-reliability-engineering).

## If a problem is not urgent

You can use the #reliability-eng slack channel for advice. If the issue you've
identified seems like a non-urgent story you can add it the
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
1. Set asignee to "3rd Line--Infrastructure"
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
