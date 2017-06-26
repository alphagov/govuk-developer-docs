---
owner_slack: "#2ndline"
title: Run a rake task
section: Deployment
layout: manual_layout
parent: "/manual.html"
important: true
last_reviewed_on: 2017-06-22
review_in: 12 months
---

There is a Jenkins job that can be used to run any rake task:

-   Integration:
    <https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/>
-   Staging:
    <https://deploy.staging.publishing.service.gov.uk/job/run-rake-task/>
-   Production:
    <https://deploy.publishing.service.gov.uk/job/run-rake-task/>

Jenkins jobs are also linkable. For example:

<https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=content-tagger&MACHINE=backend-1.backend&RAKE_TASK=routes>
