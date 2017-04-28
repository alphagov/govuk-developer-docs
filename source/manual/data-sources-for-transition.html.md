---
owner_slack: '#navigation'
title: Data Sources for Transition
section: Transition
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/2nd-line/applications/bouncer-and-transition.html"
last_reviewed_on: 2017-05-03
review_in: 6 months
---

# Data sources for Transition

Site configuration is automatically imported on an hourly basis via
[deploy.publishing](https://deploy.publishing.service.gov.uk/job/Transition_load_site_config/) from
[transition-config](https://github.com/alphagov/transition-config).

Pre-transition traffic data is imported from
[pre-transition-stats](https://github.com/alphagov/pre-transition-stats),
based on logs provided by transitioning organisations. This was updated
periodically by hand, but this has come to an end.

Traffic data is automatically imported once an hour from
[transition-stats](https://github.com/alphagov/transition-stats). This
import puts a high load on the database. CDN logs for the "Production Bouncer"
Fastly service are streamed to transition-logs.govuk.service.gov.uk in the CI
environment and processed there by cron job and pushed to the GitHub repository.
