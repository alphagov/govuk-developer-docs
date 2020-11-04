---
owner_slack: "#govuk-2ndline"
title: Change in-hours time period for daylight savings
section: 2nd line
layout: manual_layout
parent: "/manual.html"
---

We call people for different things in-hours and out-of-hours.  The
Icinga configuration doesn't appear to accept a timezone, so we can't
set the end of day to 17:30 Europe/London time.  This means the
threshold needs manually changing.

Here are two examples:

- [Going from BST to UTC](https://github.com/alphagov/govuk-puppet/commit/1f9c585d9d2968fbf456bd88165cefe7cbb97337)
- [Going from UTC to BST](https://github.com/alphagov/govuk-puppet/commit/f30976df346af65bfb9bb46cdc5b2f59ccb4e4df)
