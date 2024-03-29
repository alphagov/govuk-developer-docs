---
owner_slack: "#govuk-2ndline-tech"
title: Zendesk
parent: "/manual.html"
layout: manual_layout
section: 2nd line
type: learn
---

Technical 2nd Line Zendesk tickets are technical errors reported by our users, including government publishers.

## Get started

See the [Zendesk best practice slidedeck](https://docs.google.com/presentation/d/1iUbD-_uWyaNMeNj9h7Zvo9g2GWvRarg9kUh7pd0u32M/edit#slide=id.g134fafb13dc_0_0) for an overview and tour of the service.

[Create an account][zendesk-create-account], then ask a fellow 2nd liner to assign a new ticket to
`2nd/3rd Line--Zendesk Administration` asking to give you "GDS Resolver Agent" access to `2nd Line--GOV.UK Alerts and Issues`.

When you're logged in, you should be looking at the [`2nd Line--GOV.UK Alerts and Issues` queue][zendesk-queue].

## Useful views and searches

* [Tickets assigned to "2nd Line - GOV.UK Alerts and Issues"](https://govuk.zendesk.com/agent/filters/30791708)
* As above, but [filtered subset of just "New" and "Open" tickets](https://govuk.zendesk.com/agent/search/1?copy&type=ticket&q=group%3A2nd%20Line%20-%20GOV.UK%20Alerts%20and%20Issues%20status%3Cpending)
* [Tickets you have commented on](https://govuk.zendesk.com/agent/search/1?type=ticket&q=commenter%3Ame)
* Read the [Zendesk documentation](https://support.zendesk.com/hc/en-us/articles/4408835086106-Using-Zendesk-Support-advanced-search) for advanced search options

## Priorities

Work on 'High' priority tickets first - these will have been triaged by Technical 2nd Line already, so should be
relevant and actionable - and start with the oldest by date. If external assistance from outside 2nd
line is required, assign them on the ticket and move on to the next ticket (keeping the ticket in the
2nd line queue).

'Low' priority tickets are for tickets that are `on-hold` and are not being actively worked on.

New tickets are 'Normal' priority by default and require triaging (i.e. a developer reading and categorising
it).

## Triaging a ticket

If you have any doubts as to the legitimacy or urgency of a ticket, it should be deferred to the delivery manager or Technical 2nd Line tech lead.

Once you've established that a ticket is legitimate, you should follow [the process in this diagram][zendesk-triage-diagram].

In all cases, Technical 2nd Line will respond to the ticket, even if it is simply a note to the user saying that
you've passed their request to the relevant team.

> If you are unsure which group to triage a ticket to, you can reassign to
`2nd/3rd Line--Zendesk Administration`, and they can help route the ticket to the
appropriate place.

Below are some of the groups we often triage tickets to:

* Product requests - `3rd Line--GOV.UK Product Requests`
* Content support - `2nd Line--GOV.UK Content Triage, Gov't`
* GDPR and Privacy enquiries - `3rd Line--GDS Privacy`
* Licensing - `1st Line--Licensing Support`
* Security issues - `3rd Line--Cyber Security`
* Spam - `2nd Line--User Support Escalation`
* Signon issues - `3rd line--GOV.UK Content Training and Accounts`

If the ticket's subject is not descriptive of the problem (e.g. `Named contact`) then update this prior
to triaging or working on the ticket.

## Passing to another government department or service team

Sometimes a ticket relates to a service run by another government department. To transfer the ticket:

* click on Apply macro
* select Inside government > Pass through
* select the relevant department or service

### Service Level Agreements

GOV.UK have committed to a minimum service level agreement for Technical 2nd Line.

* 80% of tickets get a first reply to the ticket within 2 working days
* 80% of general enquiries (public tickets) resolved within 5 working days
* 70% of department tickets are closed within 5 working days

If the volume of Zendesk tickets is overwhelming, talk to the delivery manager or Technical 2nd Line tech lead
for assistance.

## Picking up a ticket

Click the "take it" link under "Assignee", followed by "Submit as Open", to formally undertake a ticket.
If you know you cannot solve a ticket immediately, fill in a "Public reply" to the requester to let them
know you’re looking into it.

You can use Internal Notes to keep a log of actions you've taken so far: this can make it easier for other
staff to pick up where you left off if you're unable to solve the ticket yourself.

If you run a rake task or execute code directly on a console, include a copy of the commands you ran as an
internal note on the ticket. This makes it easier to see what has already been done if a user replies to a
ticket that has previously been worked on.

> Please note that departments can see internal notes, so don’t write anything you wouldn’t say to someone
> publicly.

If you need more information from the user, fill in the "Public reply" as appropriate and click "Submit as Pending".

## data.gov.uk tickets

Read [Common Technical 2nd Line tasks for data.gov.uk](/manual/data-gov-uk-2nd-line.html), which outlines
some of the common data.gov.uk (DGU) tickets that come in and how to fix them.
For more thorny issues, respond to the user that you are passing this on for further
review and assign to the `3rd Line--GOV.UK Product Requests` Zendesk group.

## DNS delegation tickets

[Read our DNS documentation](/manual/dns.html) to find out more about these requests and how to action them.

## Automated requests from Amazon ACM or AWS Certificate Manager

Please refer to the [SRE interruptible documentation](https://docs.google.com/document/d/1QzxwlN9-HoewVlyrOhFRZYc1S0zX-pd97igY8__ZLAo/edit#heading=h.91quw0ws3zim).

## Closing a ticket

Once you've resolved a ticket, click "Submit as Solved". You do not need to wait for user confirmation to
close the ticket.

## Tickets left pending without a response

Note that if a ticket has been pending a response for 5 or more days with no response from the
requester, you can submit it as solved with a message telling them why and that if they still need help they
can get in touch. Do this by clicking the "Apply macro" button at the bottom of the ticket screen, and
choosing the "GOV.UK 2nd line tech: pending for 5+ days" option.

[zendesk-create-account]: https://govuk.zendesk.com/auth/v2/login/registration?auth_origin=3194076%2Cfalse%2Ctrue&amp;brand_id=3194076&amp;return_to=https%3A%2F%2Fgovuk.zendesk.com%2Fhc%2Fen-us&amp;theme=hc
[zendesk-queue]: https://govuk.zendesk.com/agent/filters/30791708
[zendesk-triage-diagram]: https://docs.google.com/presentation/d/1EotoM2CVtqlnx54Qz5bP7OyIx5c9ji_GptUuymHkBrc/edit
