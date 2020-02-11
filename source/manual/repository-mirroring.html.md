---
owner_slack: "#govuk-developers"
title: Repository mirroring
section: GitHub
layout: manual_layout
type: learn
parent: "/manual.html"
last_reviewed_on: 2019-12-09
review_in: 3 months
---

We mirror all GitHub repositories tagged with `govuk` to AWS CodeCommit every 2 hours using a [Concourse pipeline configured in alphagov/govuk-repo-mirror](https://github.com/alphagov/govuk-repo-mirror).

![](/manual/images/concourse-mirror-repos-pipeline.png)

The mirror allows us to continue deploying if GitHub is unavailable, and also gives us a private place to develop fixes for security vulnerabilities before they are deployed.

If GitHub is unavailable, you can still [get access to Jenkins and deploy from AWS CodeCommit](github-unavailable.html).
