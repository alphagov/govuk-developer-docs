---
owner_slack: "#govuk-platform-health"
title: Ask for help
parent: "/manual.html"
layout: manual_layout
section: Learning GOV.UK
---

The GOV.UK 2nd Line team (#govuk-2ndline):

- monitors the GOV.UK hosting platform and applications, and works to fix any issues
- calls on experienced members of other teams to assist in incidents
- deploys changes on behalf of teams that don’t have sufficient access
- supports the software and processes that deploy code
- triages technical issues and recommends when to escalate to a site reliability engineer

The GOV.UK developer community (#govuk-developers):

- helps each other with specialised knowledge about specific areas of the platform
- supports each other with issues deploying changes to GOV.UK
- ensures missions are delivered technically in the best and most appropriate way

The GOV.UK Platform Health team (#govuk-platform-health):

- works on long term fixes to the platform
- supports 2nd line by taking on bigger pieces of work that doesn't fit the weekly schedule
- owns the infrastructure, although doesn't necessarily have the expertise to fix issues

The GOV.UK Replatforming team (#govuk-replatforming):

- supports the infrastructure used to run and make changes to GOV.UK
- handles updates to `*.gov.uk` DNS (excluding `*.publishing.service.gov.uk`)
- obtains and renews TLS certificates

The GDS Reliability Engineering team (#reliability-eng):

- maintains centrally-provided services such as Logit and Concourse

If you and your colleagues can’t resolve a technical issue, problem or question, you should escalate it through, in order:

1. The Technical Lead on the team
2. The Lead Developer on the programme
3. The Lead Architect

If 2nd Line instructs you to escalate something to GOV.UK Replatforming, raise a ticket on Zendesk and assign it to the `3rd Line--GDS Reliability Engineering` queue. You should also raise a ticket if the issue is related to an ongoing incident for tracking purposes, but you can speak to the team directly to get it more immediate attention.

If you speak to GOV.UK Replatforming about a process only they know about, they will work with you to document the process for all of GOV.UK.
