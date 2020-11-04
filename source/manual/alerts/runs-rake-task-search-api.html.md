---
owner_slack: "#govuk-2ndline"
title: Runs a rake task on Search API that generates the sitemap files
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

At 2:30am every day, a [Jenkins job][jenkins] runs a rake task on search-api
to generate sitemap files for GOV.UK.

Occasionally the task fails. This can happen if there is low memory available
at the time of the rake task run, which can happen if other out-of-hours
processes are happening at the same time (machine learning, for example).

If the check fails:

- Inspect the [console logs for the rake task][jenkins].
- Escalate to the team responsible for [search-api](/apps/search-api.html).
- It is safe to re-run the rake task to make the alert go away.
  You may see some 'high load' alerts while the task is running.

[jenkins]: https://deploy.blue.production.govuk.digital/job/search_generate_sitemaps/
