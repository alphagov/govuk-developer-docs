---
owner_slack: "#govuk-2ndline-tech"
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
and that they're correctly scheduled in. You can [add your rota to Google calendar](#add-your-pagerduty-rota-to-google-calendar).

When an alert that triggers PagerDuty goes off, someone on the escalation schedule must acknowledge
them, otherwise they will be escalated further. NB, Technical 2nd Line shadowers are not required to be on PagerDuty.

## Creating a schedule override

There are times where developers need to make rota swaps or cover Technical 2nd Line last minute.
See the [Pagerduty documentation on how to schedule an override](https://support.pagerduty.com/docs/edit-schedules#create-overrides).

## PagerDuty drill

Every week we test PagerDuty to make sure it can phone to alert us to
any issues. This happens every Wednesday morning at 10am BST.

Prometheus is currently firing a constant `Watchdog` alert, which fires all the time so that
developers can see the that prometheus is integrated with alertmanager. In the
[alertmanager configs](https://github.com/alphagov/govuk-infrastructure/blob/main/terraform/deployments/cluster-services/templates/alertmanager-config.tpl#L79-L85)
the pagerduty drill is set up to trigger when the the clocks hit a specified time frame, between 10am to 10:03am BST every Wednesday.

You don't need to take any action for this alert. The primary in-office
Technical 2nd Line developer should escalate the call to the secondary who should escalate
it to "escalations" to ensure that phone redirection is working. The
person on "escalations" will resolve the PagerDuty alert to prevent
anyone else being phoned.

### Triggering the drill manually

To trigger the drill manually, follow these steps:

1. Ask someone in the #platform-engineering team in order to run the pagerduty drill.

1. Exec onto the alertmanager box after logging onto the production cluster:

    ```shell
    $ kubectl exec -it alertmanager-kube-prometheus-stack-alertmanager-0  -n monitoring -- sh
    ```

1. Create the pagerduty drill alert, update the end datetime field to be about 5 minutes from when you create the alert before creating the alert:

    ```shell
    $ amtool --alertmanager.url=http://localhost:9093 alert add --end <end of alert datetime in the form: 2023-11-03T15:59:00-00:00> alertname="PagerDuty test drill. Developers: escalate this alert. SMT: resolve this alert." severity='page'
    ```

1. Query the alerts to ensure that it is being triggered:

    ```shell
    $ amtool --alertmanager.url=http://localhost:9093 alert query 'alertname=PagerDuty test drill. Developers: escalate this alert. SMT: resolve'
    ```

### Add your Pagerduty rota to Google calendar

You can sync your Pagerduty with Google Calendar so you can see your Technical 2nd Line and
on-call shifts in one place.

1. Go to https://governmentdigitalservice.pagerduty.com/my-on-call/month

1. On the left side, click "Export Calendar", right click on "WebCal Feed" and copy
   the link

1. In Google Calendar, under "other calendars" click the plus symbol and add "From URL"
