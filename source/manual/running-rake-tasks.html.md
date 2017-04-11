---
title: Run a rake task
section: Deployment
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/2nd-line/running-rake-tasks.md"
important: true
---



> **This page was imported from [the opsmanual on github.gds](https://github.gds/gds/opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.gds/gds/opsmanual/tree/master/2nd-line/running-rake-tasks.md)


# Run a rake task

There is a Jenkins job that can be used to run any rake task:

-   Integration:
    <https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/>
-   Staging:
    <https://deploy.staging.publishing.service.gov.uk/job/run-rake-task/>
-   Production:
    <https://deploy.publishing.service.gov.uk/job/run-rake-task/>

Jenkins jobs are also linkable. For example:

<https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=content-tagger&MACHINE=backend-1.backend&RAKE_TASK=routes>
