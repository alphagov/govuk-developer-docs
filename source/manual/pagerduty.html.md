---
owner_slack: "#govuk-2ndline"
title: PagerDuty
section: 2nd line
type: learn
layout: manual_layout
parent: "/manual.html"
---

Some alerts are urgent enough to warrant immediate attention, such as parts of the site becoming
unavailable or large quantities of error pages being served. We use [PagerDuty](https://governmentdigitalservice.pagerduty.com)
to escalate to these people (in order):

1. Primary Engineer
2. Secondary Engineer
3. Programme Team member (might not be technical)

It is the responsibility of the people above to make sure their details are up to date in PagerDuty
and that they're correctly scheduled in.

When an alert that triggers PagerDuty goes off, someone on the escalation schedule must acknowledge
them, otherwise they will be escalated further. NB, 2nd line shadowers are not required to be on PagerDuty.

## PagerDuty drill

Every week we test PagerDuty to make sure it can phone to alert us to
any issues. This happens every Wednesday morning at 10am UTC.

Cron creates a file on disk. Icinga raises a critical alert when that
file exists with an Icinga contact group set so that PagerDuty is
notified. After a short amount of time, cron will remove the file to
resolve the alert. The [code that does this is in
Puppet](https://github.com/alphagov/govuk-puppet/blob/master/modules/monitoring/manifests/pagerduty_drill.pp).

You don't need to take any action for this alert. The primary in-office
2nd line should escalate the call to the secondary who should escalate
it to "escalations" to ensure that phone redirection is working. The
person on "escalations" will resolve the PagerDuty alert to prevent
anyone else being phoned.

### Triggering the drill manually

> **Note**: The drill runs within the AWS environment while we migrate
> our apps to AWS. If you need to trigger the drill manually, make sure
> you're logged in to the AWS monitoring instance.

To trigger the drill manually, follow these steps:

1. SSH onto the monitoring box:

```shell
$ gds govuk connect -e production ssh aws/monitoring
```

2. Generate the file that the Icinga monitor looks for which triggers the alert:

```shell
$ sudo touch /var/run/pagerduty_drill
```

3. Delete the file once the test drill is triggered:

```shell
sudo rm pagerduty_drill
```
