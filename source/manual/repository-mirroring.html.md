---
owner_slack: "#govuk-developers"
title: Repository mirroring
section: GitHub
layout: manual_layout
type: learn
parent: "/manual.html"
---

We mirror all non-archived GitHub repositories tagged with `govuk` to AWS CodeCommit (in the Tools environment, `eu-west-2`) every 2 hours using a ['Mirror GitHub repositories' Jenkins job](https://deploy.integration.publishing.service.gov.uk/job/Mirror_Github_Repositories/). The job is [configured in govuk-puppet](https://github.com/alphagov/govuk-puppet/pull/11631/files) and the [govuk-repo-mirror repository](https://github.com/alphagov/govuk-repo-mirror).

The backups allow us to continue [deploying if GitHub is unavailable](github-unavailable.html). They also give us a private place to develop fixes for security vulnerabilities before they are deployed.
