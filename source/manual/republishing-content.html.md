---
owner_slack: "#govuk-2ndline"
title: Republish content
section: Publishing
layout: manual_layout
parent: "/manual.html"
---

Sometimes it may be necessary to republish content to make it show up on the
website. This process varies per app.

## Whitehall

If the document is in Whitehall, there is a Rake task you can run.

[`publishing_api:republish_document[slug]`](https://deploy.blue.production.govuk.digital/job/run-rake-task/parambuild/?TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=publishing_api:republish_document[slug])

For organisations, run:

[`publishing_api:republish_organisation[slug]`](https://deploy.blue.production.govuk.digital/job/run-rake-task/parambuild/?TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=publishing_api:republish_organisation[slug])
