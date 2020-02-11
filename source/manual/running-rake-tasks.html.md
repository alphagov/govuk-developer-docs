---
owner_slack: "#govuk-developers"
title: Run a rake task
section: Deployment
layout: manual_layout
parent: "/manual.html"
important: true
last_reviewed_on: 2019-07-03
review_in: 12 months
---

There is a Jenkins job that can be used to run any rake task:

-   Integration:
    <https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/>
-   Staging (Carrenza):
    <https://deploy.staging.publishing.service.gov.uk/job/run-rake-task/>
-   Staging (AWS):
    <https://deploy.blue.staging.govuk.digital/job/run-rake-task/>
-   Production (Carrenza):
    <https://deploy.publishing.service.gov.uk/job/run-rake-task/>
-   Production (AWS):
    <https://deploy.blue.production.govuk.digital/job/run-rake-task/>

Jenkins jobs are also linkable. For example:

<https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=content-tagger&MACHINE_CLASS=backend-1.backend&RAKE_TASK=routes>
