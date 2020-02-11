---
owner_slack: "#govuk-developers"
title: Create a Concourse pipeline
section: Infrastructure
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2020-01-13
review_in: 3 months
---

## Create a new pipeline

You can use the [repo mirror pipeline](https://github.com/alphagov/govuk-repo-mirror/blob/master/concourse.yml) as an example - it uses GitHub, Slack and a bash script. Pivotal also provide a lot of [example pipelines](https://github.com/pivotalservices/concourse-pipeline-samples).

## Apply a pipeline

Whenever a pipeline YAML is created or changed, it needs to be applied for the changes to take effect.

To apply a pipeline:

1. If this is your first time using Concourse, download the `fly` CLI by clicking the appropriate OS logo at the bottom right corner of the [team page](https://cd.gds-reliability.engineering/teams/govuk-tools) and move it to somewhere in your `$PATH`
1. Set a target for the team you want to login to: `fly login -c https://cd.gds-reliability.engineering -n govuk-tools -t cd-govuk-tools`
1. Navigate to the folder that contains the pipeline config YAML file
1. Run `fly -t cd-govuk-tools set-pipeline -p [pipeline name] -c [pipeline config YAML file name]`
1. Visit the provided URL to log in
1. Double-check the diff to ensure you're happy with what is about to be applied
1. Enter `y` to make the changes
