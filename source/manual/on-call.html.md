---
owner_slack: "#govuk-2ndline-tech"
title: Out of hours support (on-call)
section: 2nd line
layout: manual_layout
type: learn
parent: "/manual.html"
---

> See [So, you're having an incident]!
>
> This page is for before you go on call to prep for incident handling.

GOV.UK developers are part of an on-call rota to keep GOV.UK running at night, on
the weekends and on public holidays.

Developers are drafted on the on-call rota after:

- they have completed 2 shadow 2nd line shifts
- they have completed 2 in-hours Secondary 2nd line shifts

They will be automatically opted into the rota the same time they join the Primary 2nd line rota.
If a developer is unable to be rota'd on-call, then they need to request to opt
out by contacting their tech leads. This will only be granted if they have a strong
reason be exempt (e.g. health issues, caring responsibilities).

## On call checklist

You should do these things before going on call so you're prepared.

1. Have the numbers of other people on your shift saved in your phone. This
   includes whoever is on [Escalations](https://governmentdigitalservice.pagerduty.com/schedules#PCK3XB2).
   Get these numbers from PagerDuty.
1. Make sure you know [how to contact the rest of SMT](https://drive.google.com/drive/search?q=%22smt%20escalations%20rota%22), if the on-call SMT is unavailable.
1. Ensure you have an up to date local copy of the [Developer Docs][docs] repository and that you can build it.
1. Make sure you can [access AWS][] (using the web console and the `aws` CLI)
1. Make sure you can [access GCP][] (using the web console and the `gcloud` CLI)
1. Make sure you can VPN to the office or disaster recovery location.
1. Ensure your PagerDuty [alert settings](https://support.pagerduty.com/docs/user-profile#notification-rules) will wake you if you're called. You might want to install the [PagerDuty App](https://www.pagerduty.com/features/mobile-incident-management/) on your phone and [send a test notification](https://support.pagerduty.com/docs/notification-troubleshooting#send-a-test-notification).
1. Ensure you can [decrypt secrets][govuk-secrets] with your GPG setup.
1. Ensure you have single-sign-on set up for GOV.UK PaaS ([instructions on setting up single-sign-on](https://docs.cloud.service.gov.uk/get_started.html#use-single-sign-on))
1. Ensure you can access the `govuk_development` organisation in GOV.UK PaaS
   from the command line ([instructions for setting up the cloud foundry command line](https://docs.cloud.service.gov.uk/get_started.html#set-up-the-cloud-foundry-command-line)).
1. Read these documents:
    - [So, you're having an incident](/manual/incident-what-to-do.html)
    - [Falling back to the static mirror](/manual/fall-back-to-mirror.html)
    - [Non-emergency global banner](/manual/global-banner.html)

The steps above are outlined in the [On call template Trello card](https://trello.com/c/mK6p8hH4/977-on-call-checklist), which developers should drill when given [Production Admin access](/manual/rules-for-getting-production-access.html#when-you-get-production-admin-access). Developers should speak to the 2nd line tech lead(s)
if they have any issues with the above steps.

You may also want to set to be notified for every new message in the [#govuk-incident](https://gds.slack.com/archives/CAH9L36LR) Slack channel, but this is strictly optional. People should not expect to be able to contact you on Slack during your shift. You can change your Slack notification settings by clicking “Change notifications” and selecting “All new messages”.

## Things that may result in you being contacted

### Automated monitoring

We use [PagerDuty](/manual/pagerduty.html)
for automated monitoring. You can update your [notification rules](https://support.pagerduty.com/docs/user-profile#notification-rules)
in your PagerDuty account to notify you however you want (phone call, SMS, email,
push notification). There are 2 ways that this might contact you:

#### Icinga alerts

Any Icinga checks that use `govuk_urgent_priority` will cause PagerDuty to be notified:

- [Travel advice emails not going out](/manual/alerts/email-alerts-travel-medical.html)
- [Overdue publications in Whitehall](/manual/alerts/whitehall-scheduled-publishing.html#overdue-publications-in-whitehall)
- [Scheduled publications in Whitehall not queued](/manual/alerts/whitehall-scheduled-publishing.html#scheduled-publications-in-whitehall-not-queued)
- [High nginx 5xx rate for www-origin on cache machines](/manual/alerts/high-nginx-5xx-rate.html)

   You can get the most up to date list of these by searching the Puppet repo for [govuk_urgent_priority](https://github.com/alphagov/govuk-puppet/search?q=govuk_urgent_priority).

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

You might be asked to [update the homepage promotion slots](/repos/frontend/update-homepage-promotion-slots.html)
to highlight important information on GOV.UK.

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

## On call charter

- Be available to be phoned in the evenings and at weekends
- Be able to be online to start investigating a problem within half an hour
  of being notified about it
- Don't worry if you're not able to answer the phone immediately - that's
  why we have more than one person on-call
- Nobody is expected to understand every part of GOV.UK - you don't need to
  know how to fix every issue on your own
- Logs are not as important as being available - if you need to lose some logs
  in order to bring the site back up, that's probably a good trade-off to make
- Get paid. Make sure you submit your [payment claim form][] after your shift.
  Payment rates can be found on the [GDS Wiki](https://sites.google.com/a/digital.cabinet-office.gov.uk/gds/how-to-guides/out-of-hours-allowance).

[So, you're having an incident]: /manual/incident-what-to-do.html
[docs]: https://github.com/alphagov/govuk-developer-docs/
[govuk-secrets]: https://github.com/alphagov/govuk-secrets/
[vcloud]: connect-to-vcloud-director.html
[payment claim form]: https://forms.gle/yvPoANwrsHz8SrL4A
[access AWS]: /manual/get-started.html#sign-in-to-aws
[access GCP]: /manual/google-cloud-platform-gcp.html
