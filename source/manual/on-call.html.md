---
owner_slack: "#2ndline"
title: Out of hours support (on-call)
section: Support
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2017-09-21
review_in: 6 months
---

GOV.UK developers and web operations staff are part of an on-call rota
to keep GOV.UK running at night, on the weekends and on public holidays.

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

## On call checklist

You should do these things before going on call so you're prepared.

1. Have the numbers of other people on your shift saved in your phone. This
   includes whoever is on Escalations. Get these numbers from PagerDuty.
2. Ensure you have an up to date local copy of the [Developer Docs][docs] repository
   and that you can build it.
3. Make sure your [`fabric-scripts`][fabric] are up to date.
4. Make sure you can VPN to the office or disaster recovery location.
5. Ensure your PagerDuty alert settings will wake you if you're called. You might want
   to install the [PagerDuty App](https://www.pagerduty.com/features/mobile-incident-management/)
   on your phone.
6. Ensure you can [decrypt secrets][govuk-secrets] with your GPG setup.
7. Ensure you can access [vCloud Director][vcloud] in production.
8. Read these documents:
    - [So, you're having an incident](https://gov-uk.atlassian.net/wiki/spaces/PLOPS/pages/46301531/So+you+re+having+an+incident)
    - [Falling back to the static mirror](/manual/fall-back-to-mirror.html)
    - [Emergency publishing](/manual/emergency-publishing.html)

## Things that may result in you being contacted

### Automated monitoring

We use PagerDuty for automated monitoring. You can set up your PagerDuty account
to notify you however you want (phone call, SMS, email, push notification).
There are 2 ways that this might contact you:

- Any Icinga checks that 'use' `govuk_urgent_priority` will cause
  PagerDuty to be notified. You can get the most up to date list of these
  by searching the Puppet repo for `govuk_urgent_priority`. All urgent priority
  alerts must be linked to a section in the
  [alert documentation](nagios.html).
- There are a couple of checks defined in Pingdom which notify PagerDuty directly rather
  than using GOV.UK's internal monitoring. These are normally for key parts of the website
  like the homepage and site search. They are useful when network access to all the
  machines running GOV.UK is down.

PagerDuty list [the phone numbers that notifications come from][pagerduty-numbers]. The number at the moment is +1 (415) 349-5750.

[pagerduty-numbers]: https://support.pagerduty.com/hc/en-us/articles/202828870-Phone-numbers-notifications-are-sent-from

### Phone calls from people

Senior members of GOV.UK may phone you if they've been contacted by other parts of government.
These phone calls will generally come from the group that is on the rota for the
'Escalations' contact number.

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

[docs]: https://github.com/alphagov/govuk-developer-docs/
[fabric]: https://github.com/alphagov/fabric-scripts/
[govuk-secrets]: https://github.com/alphagov/govuk-secrets/
[vcloud]: https://github.com/alphagov/govuk-legacy-opsmanual/blob/master/infrastructure/howto/connect-carrenza-il2.rst
