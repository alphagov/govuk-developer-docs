---
owner_slack: "#2ndline"
title: nginx high conn writing -- upstream indicator Check
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_at: 2017-01-06
review_in: 6 months
---

# 'nginx high conn writing -- upstream indicator' Check

### What is the 'nginx high conn writing -- upstream indicator' check?

-   If you see this alert it may be that we are having or about to have
    an outage -- this is an early warning check.
-   This check is there to flag up potential problems occurring upstream
    -- a service not returning fast enough so we have the set write
    connecting building up. This was a pattern spotted in a number of
    recent outages as at April 2013.
-   outage documentation:
    <https://docs.google.com/a/digital.cabinet-office.gov.uk/document/d/12vOWq9DQWsPJDEnv2ZZpr8hOAAMGeNux1j1vvdlznd0/edit?usp=sharing>

### Other useful information

-   Checks are specifically on the nginx frontend boxes as thats the
    closest place to the problem we can monitor and avoids the false
    positives that checking the Load balancers might give us.
-   The warning and alert levels have been selected to fire early in the
    case of outages to be a useful flag of what might be happening, but
    not so low that we get too many false positives.
-   We should really monitor what's going on at the rack/unicorn level
    which would give us more accurate information. We don't currently
    have that ability, hence this check.

