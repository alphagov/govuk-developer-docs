---
owner_slack: "#govuk-2ndline"
title: Republish content
section: Publishing
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-01-24
review_in: 6 months
---

Sometimes it may be necessary to republish content to make it show up on the
website. This process varies per app.

## Whitehall

If the document is in Whitehall, there is a Rake task you can run.

[`publishing_api:republish_document[slug]`](https://deploy.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=publishing_api:republish_document[slug])
