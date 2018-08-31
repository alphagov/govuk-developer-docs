---
owner_slack: "#govuk-2ndline"
title: PagerDuty drill
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2018-08-31
review_in: 6 months
---

Every week we test PagerDuty to make sure it can phone to alert us to
any issues.

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
