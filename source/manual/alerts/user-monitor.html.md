---
owner_slack: "#2ndline"
title: Check that correct users have access
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2017-05-25
review_in: 6 months
---

This alert triggers is triggered by the [User monitor][] task. This task [runs a script][rev] that verifies that only the correct users have access to certain things like GitHub .

## Investigating issues

When the check fails, look at the console logs for the monitor task:

<https://deploy.publishing.service.gov.uk/job/user-monitor>

[User monitor]: https://deploy.publishing.service.gov.uk/job/user-monitor
[rev]: https://github.com/alphagov/govuk-user-reviewer
