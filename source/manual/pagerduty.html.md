---
owner_slack: "#govuk-2ndline-tech"
title: PagerDuty
section: 2nd line
type: learn
layout: manual_layout
parent: "/manual.html"
---

# PagerDuty

Some alerts are urgent enough to warrant immediate attention, such as parts of the site becoming
unavailable or large quantities of error pages being served. We use [PagerDuty](https://governmentdigitalservice.pagerduty.com)
to escalate to these people (in order):

1. Primary Engineer
2. Secondary Engineer
3. Programme Team member (might not be technical)

It is the responsibility of the people above to make sure their details are up to date in PagerDuty
and that they're correctly scheduled in. You can [add your rota to Google calendar](#add-your-pagerduty-rota-to-google-calendar).

When an alert that triggers PagerDuty goes off, someone on the escalation schedule must acknowledge
them, otherwise they will be escalated further. NB, Technical 2nd Line shadowers are not required to be on PagerDuty.

## Creating a schedule override

There are times where developers need to make rota swaps or cover Technical 2nd Line last minute.
See the [Pagerduty documentation on how to schedule an override](https://support.pagerduty.com/docs/edit-schedules#create-overrides).

## PagerDuty drill

Every week we test PagerDuty to make sure it can phone to alert us to
any issues. This happens every Wednesday morning at 10am UTC.

Cron creates a file on disk. Icinga raises a critical alert when that
file exists with an Icinga contact group set so that PagerDuty is
notified. After a short amount of time, cron will remove the file to
resolve the alert. The [code that does this is in
Puppet](https://github.com/alphagov/govuk-puppet/blob/master/modules/monitoring/manifests/pagerduty_drill.pp).

You don't need to take any action for this alert. The primary in-office
Technical 2nd Line developer should escalate the call to the secondary who should escalate
it to "escalations" to ensure that phone redirection is working. The
person on "escalations" will resolve the PagerDuty alert to prevent
anyone else being phoned.

### Triggering the drill manually

To trigger the drill manually, follow these steps:

1. SSH onto the monitoring box:

    ```shell
    $ gds govuk connect -e production ssh aws/monitoring
    ```

1. Generate the file that the Icinga monitor looks for which triggers the alert:

    ```shell
    $ sudo touch /var/run/pagerduty_drill
    ```

1. Delete the file once the test drill is triggered:

    ```shell
    sudo rm /var/run/pagerduty_drill
    ```

### Add your Pagerduty rota to Google calendar

You can sync your Pagerduty with Google Calendar so you can see your Technical 2nd Line and
on-call shifts in one place.

1. Go to https://governmentdigitalservice.pagerduty.com/my-on-call/month

1. On the left side, click "Export Calendar", right click on "WebCal Feed" and copy
   the link

1. In Google Calendar, under "other calendars" click the plus symbol and add "From URL"
