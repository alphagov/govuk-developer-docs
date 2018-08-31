---
owner_slack: "#govuk-2ndline"
title: Nginx high conn writing -- upstream indicator Check
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2018-08-31
review_in: 6 months
---

### What is the 'Nginx high conn writing -- upstream indicator' check?

-   If you see this alert it may be that we are having or about to have
    an outage -- this is an early warning check.
-   This check is there to flag up potential problems occurring upstream
    -- a service not returning fast enough so we have the set write
    connecting building up. This was a pattern spotted in a number of
    recent outages as at April 2013.
-   outage documentation:
    <https://docs.google.com/a/digital.cabinet-office.gov.uk/document/d/12vOWq9DQWsPJDEnv2ZZpr8hOAAMGeNux1j1vvdlznd0/edit?usp=sharing>

### Other useful information

-   Checks are specifically on the Nginx frontend boxes as that is the
    closest place to the problem we can monitor and avoids the false
    positives that checking the load balancers might give us.
-   The warning and alert levels for outages have been set low
    to be useful flags of what might be happening, but
    not so low that we get too many false positives.
-   Ideally we would monitor at the rack/unicorn level,
    which would give us more accurate information, but don't currently
    have that ability, hence this check.
