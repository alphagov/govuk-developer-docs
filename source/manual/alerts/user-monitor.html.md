---
owner_slack: "#govuk-2ndline"
title: Check that correct users have access
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2019-08-08
review_in: 6 months
---

This alert is triggered by the [User monitor][] task. This task [runs a script][rev] that verifies only the correct users have access to things like GitHub.

## Investigating issues

When the check fails, look at the console logs for the monitor task:

<https://deploy.publishing.service.gov.uk/job/user-monitor>

[User monitor]: https://deploy.publishing.service.gov.uk/job/user-monitor
[rev]: https://github.com/alphagov/govuk-user-reviewer

When a new person joins, they are added on GitHub, but they still have to open a number of PRs to give themselves access elsewhere (ex: in `govuk-puppet`).
If they're new, they might not have gotten to that yet so you should check with them before attempting to remove their access.

## Resolving issues

The list of users and their privileges which the [User monitor][] task compares with the status quo is maintained in the [`govuk-user-reviewer`][rev] repository. If you have verified that a user has rightfully been granted access, you can request them or their team lead to adjust the data in the repo accordingly.
