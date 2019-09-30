---
owner_slack: "#govuk-2ndline"
title: Add a secret to a Concourse pipeline
section: Infrastructure
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-09-30
review_in: 3 months
---

To use secrets (such as passwords or keys) in a Concourse pipeline, they need to be added to the `info` pipeline.

To add or change secrets:

1. If this is your first time using Concourse, download the `fly` CLI by clicking the appropriate OS logo at the bottom right corner of the [team page](https://cd.gds-reliability.engineering/teams/govuk-tools) and move it to somewhere in your `$PATH`
2. Go to the [info pipeline](https://cd.gds-reliability.engineering/teams/govuk-tools/pipelines/info)
3. Click the [show available pipeline variables](https://cd.gds-reliability.engineering/teams/govuk-tools/pipelines/info/jobs/show-available-pipeline-variables) job
4. In the top right corner, click the plus button - this starts a new build of the job
5. After a few seconds, you'll see console output in the `hijack-me-to-add-secrets` section
6. The console output will give instructions about how to connect to the temporary Docker container that has been created and add or change secrets

Once the secret is in the `info` pipeline, it can be used in pipeline config YAML files using the double bracket notation (for example, `((name-of-secret-here))`).
