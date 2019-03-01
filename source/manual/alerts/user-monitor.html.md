---
owner_slack: "#govuk-2ndline"
title: Check that correct users have access
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2019-01-31
review_in: 6 months
---

This alert is triggered by the [User monitor][] task. This task [runs a script][rev] that verifies only the correct users have access to things like GitHub .

## Investigating issues

When the check fails, look at the console logs for the monitor task:

<https://deploy.publishing.service.gov.uk/job/user-monitor>

[User monitor]: https://deploy.publishing.service.gov.uk/job/user-monitor
[rev]: https://github.com/alphagov/govuk-user-reviewer

When a new person joins, they are added on github, but they still have to open a number of PRs to give themselves access elsewhere (ex: in `govuk-puppet`).
If they're new, they might not have gotten to that yet so you should check with them before attempting to remove their access.  
