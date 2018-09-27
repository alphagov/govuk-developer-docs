---
owner_slack: "#govuk-platform-health"
title: Backups for data.gov.uk
section: data.gov.uk
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-09-27
review_in: 6 months
---

## Local backups

Backups of the local PostgreSQL database are made every day and stored in `/media/hulk/backup` on the server. The last few daily backups are kept, after which the retention period decreases to one backup per month.

## Bytemark backups

As part of their managed service, Bytemark takes daily offsite backups of the whole server, which are kept for 7 days, after which time the last 4 monthly backups are kept.

Access to these backups is via a Bytemark support ticket. Contact the Platform Health team who have named contacts set up with Bytemark for support requests.
