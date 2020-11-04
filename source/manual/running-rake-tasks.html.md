---
owner_slack: "#govuk-developers"
title: Run a rake task
section: Deployment
layout: manual_layout
parent: "/manual.html"
important: true
---

There is a Jenkins job that can be used to run any rake task:

- Integration:
  <https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/>
- Staging:
  <https://deploy.blue.staging.govuk.digital/job/run-rake-task/>
- Production:
  <https://deploy.blue.production.govuk.digital/job/run-rake-task/>

Jenkins jobs are also linkable. For example:

<https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=content-tagger&MACHINE_CLASS=backend-1.backend&RAKE_TASK=routes>
