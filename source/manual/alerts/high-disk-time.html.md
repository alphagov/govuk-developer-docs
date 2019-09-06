---
owner_slack: "#govuk-2ndline"
title: High disk time
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2019-09-05
review_in: 6 months
---

This alert tells us that reads and/or writes to disk are taking longer
than expected. In most cases this is only informational; you may not
need to take any action, but it may explain the cause for other alerts.

For example if you're loading lots of data into a database and it's slow
because the disk is struggling to keep up then you may also see alerts
for replication lag or slow request times for applications that use the
same database server. You may want to stop loading data and resume at a
quieter time of day.

If you see this alert fire for many machines in the same environment, or
even across multiple environments, then our cloud provider may be at
fault. Even if it's not yet causing other alerts it may be worth
checking their status pages, talking to other projects that use that
provider, or contacting their support.
