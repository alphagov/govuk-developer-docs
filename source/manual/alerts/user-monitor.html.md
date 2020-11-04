---
owner_slack: "#govuk-2ndline"
title: Check that correct users have access
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

This alert is triggered by the [User Monitor Jenkins job][user-monitor-job]. This task [runs a script][repo] that verifies only the correct users have access to things like GitHub.

## Investigating issues

When the check fails, look at the console logs for the monitor task
[in the AWS Production Jenkins][user-monitor-job].

When a new person joins, they are added on GitHub, but they still have to open a number of PRs to give themselves access elsewhere (ex: in `govuk-puppet`).
If they're new, they might not have gotten to that yet so you should check with them before attempting to remove their access.

## Resolving issues

The list of users and their privileges which the [user monitor][user-monitor-job] task compares with the status quo is maintained in the [`alphagov/govuk-user-reviewer`][repo] repository. If you have verified that a user has rightfully been granted access, you can request them or their team lead to adjust the data in the repo accordingly.

[user-monitor-job]: https://deploy.blue.production.govuk.digital/job/user-monitor
[repo]: https://github.com/alphagov/govuk-user-reviewer
