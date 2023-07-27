---
owner_slack: "#govuk-pubworkflow-dev"
title: content-publisher government-data check not ok
section: Icinga alerts
layout: manual_layout
parent: "/manual.html"
---

This means that Content Publisher is having trouble updating the data it holds on current and previous governments. Ordinarily it reloads this data from the Publishing API every fifteen minutes and seeing this error means it hasn't happened in at least 6 hours. After 24 hours the cache of government data will clear and the app will stop working as expected. The following suggestions should help to isolate the problem.

- Check [Sentry][] for any recent errors that indicate reasons the job is failing
- Ensure there aren't alerts indicating the Content Publisher sidekiq process isn't running
- Run `PopulateBulkDataJob.perform_now` manually in the [Content Publisher console][console] to see if issues occur. [Link to job][data job]

[Sentry]: [https://sentry.io/organizations/govuk/issues/?project=1242052]
[data job]: [https://github.com/alphagov/content-publisher/blob/main/app/jobs/populate_bulk_data_job.rb]
[console]: [/manual/get-ssh-access.html#running-a-console]
