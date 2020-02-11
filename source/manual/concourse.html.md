---
owner_slack: "#govuk-developers"
title: Concourse
section: Infrastructure
layout: manual_layout
type: learn
parent: "/manual.html"
last_reviewed_on: 2020-01-13
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

### The info pipeline

The `info` pipeline is a meta pipeline. Its main use is as a method to store secrets that can then be used in other pipelines. For example, the repository mirroring job uses GitHub and AWS credentials that are stored as secrets using this method. How to add and remove secrets is documented [in the Reliability Engineering manual](https://reliability-engineering.cloudapps.digital/continuous-deployment.html#secrets).
