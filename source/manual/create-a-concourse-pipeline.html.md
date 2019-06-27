---
owner_slack: "#govuk-2ndline"
title: Create a Concourse pipeline
section: Infrastructure
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-06-27
review_in: 3 months
---

## Create a new pipeline

You can use the [repo mirror pipeline](https://github.com/alphagov/govuk-repo-mirror/blob/master/concourse.yml) as an example - it uses GitHub, Slack and a bash script. Pivotal also provides a lot of [example pipelines](https://github.com/pivotalservices/concourse-pipeline-samples).

## Apply a pipeline

Whenever a pipeline YAML is created or changed, it needs to be applied for the changes to take effect.

To apply a pipeline:

1. If this is your first time using Concourse, download the `fly` CLI by clicking the appropriate OS logo at the bottom right corner of the [team page](https://cd.gds-reliability.engineering/teams/govuk-tools) and move it to somewhere in your `$PATH`
2. Navigate to the folder that contains the pipeline config YAML file
3. Run `fly -t cd-govuk-tools set-pipeline -p [pipeline name] -c [pipeline config YAML file name]`
4. Visit the provided URL to log in
5. Double-check the diff to ensure you're happy with what is about to be applied
6. Enter `y` to make the changes
