---
owner_slack: "#2ndline"
title: Write an incident report
parent: "/manual.html"
layout: manual_layout
section: Incidents
last_reviewed_on: 2018-04-11
review_in: 2 months
---

This page contains guidance about how to fill in an incident report.

You can find the [incident report template][tpl] on Google Drive.

[tpl]: https://docs.google.com/document/d/1cMJP2p_PlDalJEcpS6TbXjZgUwdm9gd1rFrhUXa6uh4/edit

## Info

Report title: YYYY-MM-DD: Name of incident

Date:  YYYY-MM-DD

Time: Include when the incident started and when it ended. Always use local time, e.g. 10:20 - 15:00

Service/application: Detail the service or application that was affected

Severity: [Was it a P1, P2, or P3 incident?](https://gov-uk.atlassian.net/wiki/spaces/PLOPS/pages/64487471/Incident+severity+levels)

Incident lead: Please don't leave this blank. The incident lead has a few post-incident responsibilities so we require a named person.

Comms lead: Please don't leave this blank.

## Overview

This section contains a brief, executive summary of the issue, so that people can see what the incident was at a glance. It should not contain detailed analysis, just the high level summary of the incident.

### Good example

> A widespread disc failure cased an outage of most of GOV.UK machines and connectivity. This was picked up by monitoring and the GOV.UK on-call engineers failed over to the mirrors while the disc issue was resolved.

### Bad example

> At 15:36, Jonathan received an envelope from an unnamed source. When Jonathan was in the server room, he opened the envelope and found that it contained several kilograms of glitter, which was sucked into the machines via their intake fans. This caused a widespread disc failure which resulted in a full GOV.UK outage. Marie was paged and called Susan to inform her of the issue. Susan called Ian while Marie failed over to the mirrors.

## User impact

Clearly state what the user impact of this issue was using stats from systems like Google analytics, Kibana or Fastly. There can be discrepancies in stats, so mention where the numbers came from and why there’s a discrepancy (if you know). Describe what users would have seen during the incident. If publishers were impacted, describe what systems were affected and for how long.

This is so that anyone reading the report understands the scale of the impact to users.

### Good example

> Google Analytics reports that we served 248,000 404 errors and 56,000 5xx errors from 10:40 - 10:50, which represents 19% of our traffic for that period. From 10:50, when the site failed over to the mirrors, the 404 and 5xx errors drop off completely meaning that users weren’t seeing any more errors, but editors didn’t have access to publishing tools. Full service was restored at 15:37.

### Bad example

> During the incident, users saw 404 pages. Once the site failed over to the mirrors, full service was restored.

## Timeline

All times should be in local time, unless otherwise stated.

This section establishes a timeline of events. It’s fine to use it as a WIP section and make notes for tidying up later. The final version should contain only the facts of the incident, the decisions made and the actions taken.

Do:

- Summarise actions/decisions
- Convert times to local time
- Include relevant links
- Include when alerts were sent and received
- When additional people were called in to help
- Include red herrings and wrong turns

Don’t:

- Paste IM conversations
- Include anything not relevant to the incident
