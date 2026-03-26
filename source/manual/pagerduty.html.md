---
owner_slack: "#govuk-developers"
title: PagerDuty
section: Monitoring and alerting
type: learn
layout: manual_layout
parent: "/manual.html"
---

Some alerts are urgent enough to warrant immediate attention, such as parts of the site becoming
unavailable or large quantities of error pages being served. We use [PagerDuty](https://governmentdigitalservice.pagerduty.com)
to escalate to these people (in order):

1. Primary Engineer
2. Secondary Engineer
3. GOV.UK Senior Management Team member (might not be technical)

It's the responsibility of the people above to make sure their details are up to date in PagerDuty
and that they're correctly scheduled in. You can [add your rota to Google calendar](#add-your-pagerduty-rota-to-google-calendar).

When an alert that triggers PagerDuty goes off, someone on the escalation schedule must acknowledge it, otherwise it will be escalated further.

## Setting up and using Pagerduty while on-call

These are general instructions, which may vary depending on your mobile device.
It’s your responsibility to ensure you can receive calls from Pagerduty while on-call, including setting it to bypass any DoNotDisturb features on your phone.

> It’s highly recommended to use the Pagerduty app on your work mobile device (you will not be able to use it on personal devices due to login restrictions). See [Pagerduty's instructions for setting up the app](https://support.pagerduty.com/main/docs/mobile-app-settings). Using the mobile app makes it easier to ensure that incident notifications make it through to you.

You can send a test notification by accessing your profile by clicking your picture in Pagerduty, then on the Contact Information tab, then clicking any of the `test` buttons.

If you decide not to use the mobile app, or don’t have a work mobile device, you'll need to:

- [Download the Pagerduty vcard](https://support.pagerduty.com/main/docs/notification-phone-numbers) and add it to your phone contacts. You should download this periodically because the number used by Pagerduty can change
- Follow the instructions for your mobile device to allow that contact to bypass DoNotDisturb features ([Android](https://support.google.com/android/answer/9069335?hl=en-GB#zippy=%2Cset-what-to-block-or-who-can-interrupt-you)/[Iphone](https://support.apple.com/en-gb/105112)). Those may be set automatically based on a schedule so do check.

## Creating a schedule override in Pagerduty

See the [Pagerduty documentation on how to schedule an override](https://support.pagerduty.com/docs/edit-schedules#create-overrides) if you need to make a rota swap or cover for someone at the last minute.

## PagerDuty drill

We test PagerDuty weekly to make sure it can alert us. This happens [every Monday morning at 10am UTC (11am BST)](https://github.com/alphagov/govuk-infrastructure/blob/main/terraform/deployments/cluster-services/templates/alertmanager-config.tpl#L79-L85).

The primary in-hours technical on-call developer should escalate the call to the secondary, who should then escalate it to "SMT escalations". The person on "SMT escalations" should resolve the PagerDuty alert to prevent anyone else being phoned.

Prometheus fires a constant `Watchdog` alert, so that developers can see that prometheus is integrated with alertmanager.

### Triggering the drill manually

To trigger the drill manually, follow these steps:

1. Ask someone in the #platform-engineering team to run the Pagerduty drill.

1. Exec onto the alertmanager box after logging onto the production cluster:

    ```shell
    $ kubectl exec -it alertmanager-kube-prometheus-stack-alertmanager-0  -n monitoring -- sh
    ```

1. Create the Pagerduty drill alert, update the end datetime field to be about 5 minutes from when you create the alert:

    ```shell
    $ amtool --alertmanager.url=http://localhost:9093 alert add --end <end of alert datetime in the form: 2023-11-03T15:59:00-00:00> alertname="PagerDuty test drill. Developers: escalate this alert. SMT: resolve this alert." severity='page'
    ```

1. Query the alerts to ensure that it is being triggered:

    ```shell
    $ amtool --alertmanager.url=http://localhost:9093 alert query 'alertname=PagerDuty test drill. Developers: escalate this alert. SMT: resolve'
    ```

### Add your Pagerduty rota to Google calendar

You can sync your Pagerduty with Google Calendar so you can see your
on-call shifts in one place.

1. Go to https://governmentdigitalservice.pagerduty.com/my-on-call/month

1. On the left side, click "Export Calendar", right click on "WebCal Feed" and copy
   the link

1. In Google Calendar, under "other calendars" click the plus symbol and add "From URL"
