---
owner_slack: "#govuk-2ndline-tech"
title: Check that correct users have access
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

# Check that correct users have access

This alert is triggered by the [User Monitor Jenkins job][user-monitor-job]. This task [runs a script][repo] that verifies only the correct users have access to things like GitHub, Sentry, AWS, Fastly and PagerDuty.

## Investigating issues

When the check fails, look at the console logs for the monitor task [in the AWS Production Jenkins][user-monitor-job]. It's usually down to a mismatch between govuk-user-reviewer and GitHub, e.g. someone may have been added to the GOV.UK GitHub team but not added to the user-reviewer.

For GOV.UK tech people, there may still be a number of PRs required to give themselves the necessary access everywhere (e.g. in `govuk-puppet`).
If they're new, they might not have got to that yet so you should check with them before attempting to remove their access.

## Resolving issues

The list of users and their privileges which the [user monitor][user-monitor-job] task compares with the status quo is maintained in the [`alphagov/govuk-user-reviewer`][repo] repository. If you have verified that a user has rightfully been granted access, you can request them or their team lead to adjust the data in the repo accordingly.

[user-monitor-job]: https://deploy.blue.production.govuk.digital/job/user-monitor
[repo]: https://github.com/alphagov/govuk-user-reviewer
