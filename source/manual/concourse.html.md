---
owner_slack: "#govuk-2ndline"
title: Concourse
section: Infrastructure
layout: manual_layout
type: learn
parent: "/manual.html"
last_reviewed_on: 2019-02-06
review_in: 3 months
---

Concourse is a continuous integration and continuous deployment system similar to Jenkins.

The Reliability Engineering team runs a [hosted Concourse](https://cd.gds-reliability.engineering/) service for all GDS teams.

Concourse is built on the concept of pipelines. Each pipeline can be compared to a collection of related Jenkins jobs. Pipelines consist of multiple jobs and resources. Jobs are collections of commands that are run, and are stateless since they are run inside disposable Docker containers. All state needs to be stored and read from resources, which may be a git repository, an AWS S3 bucket or another storage medium. Triggers allow changes to resources to start a job, and jobs can trigger other jobs.

> **Note**
>
> To log in to Concourse, you need to be a member of the GOV.UK Production GitHub team

## Teams

GOV.UK currently has one team named [govuk-tools](https://cd.gds-reliability.engineering/teams/govuk-tools).

## Pipelines

GOV.UK currently has two pipelines named [info](https://cd.gds-reliability.engineering/teams/govuk-tools/pipelines/info) and [operations](https://cd.gds-reliability.engineering/teams/govuk-tools/pipelines/operations).

### The operations pipeline

We currently use the `operations` pipeline to [mirror all GOV.UK GitHub repositories to AWS CodeCommit](repository-mirroring.html).

### The info pipeline

The `info` pipeline is a meta pipeline. Its main use is as a method to store secrets that can then be used in other pipelines. For example, the repository mirroring job uses GitHub and AWS credentials that are stored as secrets using this method.

In order to add or change secrets:

1. If this is your first time using Concourse, download the `fly` CLI by clicking the appropriate OS logo at the bottom right corner of the [team page](https://cd.gds-reliability.engineering/teams/govuk-tools) and move it to somewhere in your `$PATH`
2. Go to the [info pipeline](https://cd.gds-reliability.engineering/teams/govuk-tools/pipelines/info)
3. Click the [show available pipeline variables](https://cd.gds-reliability.engineering/teams/govuk-tools/pipelines/info/jobs/show-available-pipeline-variables) job
4. In the top right corner, click the plus button - this starts a new build of the job
5. After a few seconds, you'll see console output in the `hijack-me-to-add-secrets` section
6. The console output will give instructions about how to connect to the temporary Docker container that has been created and add or change secrets
