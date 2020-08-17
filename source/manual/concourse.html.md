---
owner_slack: "#govuk-developers"
title: Concourse
section: Infrastructure
layout: manual_layout
type: learn
parent: "/manual.html"
---

Concourse is a continuous integration and continuous deployment system similar to Jenkins.

The Reliability Engineering team runs a [hosted Concourse](https://cd.gds-reliability.engineering/) service for all GDS teams.

Concourse is built on the concept of pipelines. Each pipeline can be compared to a collection of related Jenkins jobs. Pipelines consist of multiple jobs and resources. Jobs are collections of commands that are run, and are stateless since they are run inside disposable Docker containers. All state needs to be stored and read from resources, which may be a git repository, an AWS S3 bucket or another storage medium. Triggers allow changes to resources to start a job, and jobs can trigger other jobs.

## Teams

GOV.UK currently has one team named [govuk-tools](https://cd.gds-reliability.engineering/teams/govuk-tools).

To view pipelines within this Concourse team, you need to be a member of the GOV.UK GitHub team.
To change pipelines within this Concourse team, you need to be a member of the GOV.UK Production GitHub team.

## Pipelines

### What pipelines do we currently have?

#### The coronavirus forms pipelines

More information about these can be found [on the docs page for the forms](/manual/covid-19-services.html#deployment).

#### The operations pipeline

We currently use the `operations` pipeline to [mirror all GOV.UK GitHub repositories to AWS CodeCommit](repository-mirroring.html).

#### The info pipeline

The `info` pipeline is a meta pipeline. Its main use is as a method to store secrets that can then be used in other pipelines. For example, the repository mirroring job uses GitHub and AWS credentials that are stored as secrets using this method. How to add and remove secrets is documented [in the Reliability Engineering manual](https://reliability-engineering.cloudapps.digital/continuous-deployment.html#secrets).

### Creating new pipelines

The above pipelines serve as good examples for how to do continuous deployment and scheduled tasks with Concourse.

Whenever a pipeline YAML is created or changed, it needs to be applied for the changes to take effect.

Some of our Concourse pipelines use the beta Concourse "self-update" feature that runs a task whenever a change to the pipeline YAML is merged to master. For others, like the [repo mirroring job](/manual/repository-mirroring.html), or if you're writing a new Concourse pipeline, you have to run `fly set-pipeline` manually:

1. If this is your first time using Concourse, download the `fly` CLI by clicking the appropriate OS logo at the bottom right corner of the [team page](https://cd.gds-reliability.engineering/teams/govuk-tools) and move it to somewhere in your `$PATH`. If that doesn't download an executable file, try `brew cask install fly`.
1. Set a target for the team you want to login to: `fly login -c https://cd.gds-reliability.engineering -n govuk-tools -t cd-govuk-tools`
1. Navigate to the folder that contains the pipeline config YAML file
1. Run `fly -t cd-govuk-tools set-pipeline -p [pipeline name] -c [pipeline config YAML file name]`
1. Visit the provided URL to log in
1. Double-check the diff to ensure you're happy with what is about to be applied
1. Enter `y` to make the changes

GDS Reliability Engineering provide [further documentation][big-concourse-docs]. More information on working with Concourse and the Fly CLI can be found in [the official documentation][concourse-docs].

[big-concourse]: https://cd.gds-reliability.engineering/
[big-concourse-docs]: https://reliability-engineering.cloudapps.digital/continuous-deployment.html#getting-started-with-concourse
[concourse-docs]: https://concourse-ci.org/fly.html
[mirror-repos]: /manual/repository-mirroring.html
