---
owner_slack: "#govuk-developers"
title: GOV.UK Technical On-Call Support
section: Incident management
layout: manual_layout
type: learn
parent: "/manual.html"
---

> In a hurry? You may be looking for [So, you're having an incident][]!

GOV.UK developers are part of an [on-call rota](https://docs.google.com/spreadsheets/d/1OTVm_k6MDdCFN1EFzrKXWu4iIPI7uR9mssI8AMwn7lU/edit) to keep GOV.UK running 24/7. Engineers are enrolled onto the in-hours rota first, then onto the out-of-hours rota once they've built up enough experience (see [Rules for Primary, Secondary and On Call](#rules-for-primary-secondary-and-on-call)).

[So, you're having an incident]: /manual/incident-what-to-do.html

## On call charter

- Attend the Monday morning handover, centered around the [GOV.UK Technical On-Call Trello board](https://trello.com/b/M7UzqXpk)
- Prepare for your shift by following the steps in the [On-call Trello card template](https://trello.com/c/mK6p8hH4/977-on-call-checklist) (you'll be given your own card at the beginning of your shift)
- Be available to be phoned during your allocated shift
- Be able to be online to start investigating a problem within half an hour
  of being notified about it
- Don't worry if you're not able to answer the phone immediately - that's
  why we have more than one person on-call
- Nobody is expected to understand every part of GOV.UK - you don't need to
  know how to fix every issue on your own
- Logs are not as important as being available - if you need to lose some logs
  in order to bring the site back up, that's probably a good trade-off to make
- Get paid. Make sure you submit your [payment claim form][] after your shift.
  Payment rates can be found on the [GDS Wiki][].

[GDS Wiki]: https://sites.google.com/a/digital.cabinet-office.gov.uk/gds/how-to-guides/out-of-hours-allowance
[payment claim form]: https://forms.gle/yvPoANwrsHz8SrL4A

## Rules for Primary, Secondary and On Call

[Production Admin access](/manual/rules-for-getting-production-access.html) is a pre-requisite for joining the on-call rota.

Folks start out as a Secondary on the in-hours shift. After two shifts as a Secondary, they'll start to fill the Primary in-hours role, with some exceptions (see [role specific policies](#role-specific-policies)).

At this point they'll also start filling the out-of-hours on-call rota, as a Primary. After a couple of Primary out-of-hours on-call shifts, they'll start taking the out-of-hours on-call Secondary shifts. The thinking behind them starting out as Primary is that engineers who are new to on-call should be paged first and escalate to the Secondary, for the experience.

### Role specific policies

Backend developers and SREs are all expected to be on the in-hours and on-call rota, unless their head of community agrees that they have reason to opt out.

Frontend developers are expected to be on the in-hours rota, unless their head of community agrees that they have reason to opt out. They are _not_ expected to be on the on-call rota. Junior technologists and technologist apprentices are also expected to take part in the in-hours rota and not the on-call rota.

A junior technologist can be a secondary, but won't be a primary.

There is no expectation for technologist apprentices to do technical on-call shifts, but if they are confident, they can (at their Line Manager's discretion) go through the process to get Production Admin access, at which point they can request to be added to the secondary role (in-hours).

## Shift swaps, working patterns and sickness

If you need to swap your shift, it’s your responsibility to ensure that adequate cover is in place.

- If you need cover for a day or two, arrange a swap for those days with another developer. Please ensure delivery managers are aware of this.
- If you need a whole shift swap, arrange this with another developer from your team.

For either of the above, let the Technical On-Call delivery manager know, so that they can update the schedule on PagerDuty.

If you cannot make your shift because you’re ill, message the delivery manager and #govuk-technical-on-call Slack channel.

If your working patterns are not compatible with a 9.30am-5.30pm shift, let the Technical On-Call team know so they can find extra support.

If you do not work a 5-day week, please talk to your delivery manager to arrange cover with another developer on your team.

### Away days and all-staff events

Before attending an all-staff event, team away-day or any other event that could keep you away from your laptop for long periods at a time: try to swap your shift with someone who is _not_ attending ([see above](#shift-swaps-working-patterns-and-sickness)).

Otherwise, attending such events is allowed provided you are able to regularly check Slack (e.g. on an hourly basis) and are prepared to drop what you're doing and work on anything urgent that comes in. You must also be contactable by phone so that you can quickly respond to PagerDuty alerts.

## Things that may result in you being contacted

### Automated monitoring

We use [PagerDuty](/manual/pagerduty.html)
for automated monitoring. You can update your [notification rules](https://support.pagerduty.com/docs/user-profile#notification-rules)
in your PagerDuty account to notify you however you want (phone call, SMS, email,
push notification). We carry out a [Pagerduty drill](/manual/pagerduty.html#pagerduty-drill) every Monday morning at 10am UTC (11am BST).

There are 2 reasons that PagerDuty might contact you:

#### Alertmanager alerts

Any checks that use `severity: page` will cause PagerDuty to be notified:

- [Travel Advice or Drug and Medical Device emails not going out](/manual/alerts/email-alerts-travel-medical.html)
- [Overdue publications in Whitehall](/manual/alerts/whitehall-scheduled-publishing.html#overdue-publications-in-whitehall)
- [Scheduled publications in Whitehall not queued](/manual/alerts/whitehall-scheduled-publishing.html#scheduled-publications-in-whitehall-not-queued)
- [High error ratio for requests to Router](/manual/alerts/RouterErrorRatioTooHigh.html)
- Low disk space on Redis instances

   You can get the most up to date list of these by [searching the govuk-helm-charts repo for `severity: page`](https://github.com/search?q=repo%3Aalphagov%2Fgovuk-helm-charts%20severity%3A%20page).

#### Pingdom alerts

We have downtime checks configured in Pingdom which notify Pagerduty directly rather
than using GOV.UK's internal monitoring. They are all configured in Pingdom to:

- be considered down after 30 seconds
- a check interval of 1 min
- send an alert after 5 mins

They are useful when network access to all machines running GOV.UK is down. These
are set up for key parts of the website such as:

- [Assets](/manual/assets.html) (assets.publishing.service.gov.uk)
- [Bouncer canary](/manual/pingdom-bouncer-canary-check.html)
- [GOV.UK homepage](/manual/alerts/pingdom-homepage-check.html)
- [S3 mirror](/manual/alerts/mirror-sync.html#impact) (London) and S3 Mirror Replica (Ireland)
- [data.gov.uk](/manual/data-gov-uk-monitoring.html)

### Phone calls from people

Senior members of GOV.UK may phone you if they’ve been contacted by other parts
of government. These phone calls will generally come from the group that is on the
rota for the ‘Escalations’ contact number.

### Emergency publishing

The GOV.UK on-call escalations contact will call you to carry this out.  See the
[deploy an emergency banner doc](/manual/emergency-publishing.html)
for more information.

### Updating the homepage

You might be asked to [update the homepage promotion slots](/repos/frontend/update-homepage-promotion-slots.html) to highlight important information on GOV.UK.

## Responding to being contacted

### Automated monitoring

If you're available to investigate the problem, acknowledge the alert in
PagerDuty to prevent the next person being phoned.

Try to diagnose what the problem is. If you're comfortable that you understand
the problem there's no need to escalate to the next person. If you're not sure
you completely understand what's going on, it's better to escalate the alert
in PagerDuty.

If you escalate a problem, stay online to support the other person and to
increase your understanding of what's going on. If a problem is escalated
to you, explain what you're doing to the person who escalated to you.

If the technical people on-call don't understand what's going on, the final
escalation will be to a senior member of GOV.UK who can make a decision about
how serious the problem is and contact other people on GOV.UK if required.

### Phone calls from people

If you're phoned by somebody who works on GOV.UK it's likely that this is because:

- There's a serious issue with the site which somebody else in government has noticed
- Government has decided to do [emergency publishing](/manual/emergency-publishing.html)

There's a separate process for urgent changes to content which doesn't require technical
support (assuming everything is working).
