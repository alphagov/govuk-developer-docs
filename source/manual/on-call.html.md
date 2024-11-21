---
owner_slack: "#govuk-developers"
title: On-call support
section: 2nd line
layout: manual_layout
type: learn
parent: "/manual.html"
---

> In a hurry? You may be looking for [So, you're having an incident][]!

GOV.UK developers are part of an on-call rota to keep GOV.UK running 24/7. Engineers are enrolled onto the in-hours rota first, then onto the out-of-hours rota once they've built up enough experience (see [Rules for Primary, Secondary and On Call][]).

[So, you're having an incident]: /manual/incident-what-to-do.html
[Rules for Primary, Secondary and On Call]: /manual/2nd-line.html#rules-for-primary-secondary-and-on-call

## On call charter

- Prepare for your shift by following the steps in the [On-call Trello card template](https://trello.com/c/mK6p8hH4/977-on-call-checklist)
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

## Things that may result in you being contacted

### Automated monitoring

We use [PagerDuty](/manual/pagerduty.html)
for automated monitoring. You can update your [notification rules](https://support.pagerduty.com/docs/user-profile#notification-rules)
in your PagerDuty account to notify you however you want (phone call, SMS, email,
push notification). There are 2 ways that this might contact you:

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
