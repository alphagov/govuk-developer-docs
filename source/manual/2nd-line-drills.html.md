---
owner_slack: "#govuk-2ndline-tech"
title: 2nd line drills
parent: "/manual.html"
layout: manual_layout
section: 2nd line
type: learn
---

There are a number of areas that are important to drill on 2nd line. This is to make developers familiar with the process, as well as to validate that the drill steps continue to work.

## Drill an end to end incident

Decide on a hypothetical incident scenario, e.g. "GOV.UK is down".
Walk through the [incident management guidance](/manual/incident-management-guidance.html).
Use common sense when following the steps (i.e. don't actually publish an incident to Statuspage or email stakeholders).

## Deploy from AWS CodeCommit when Github is unavailable

Choose an app and decide on an old release tag or branch to deploy.
Follow the [Deploying from AWS CodeCommit](/manual/github-unavailable.html#deploying-from-aws-codecommit) instructions in the Integration or Staging environment.

## Run a Terraform `plan`

Follow the [Deploy Terraform](/manual/deploying-terraform.html) instructions, picking a project at random.
You can run this in any environment, as you're only running `plan` - not `apply` - so shouldn't be making any changes.

## Update homepage promotion slots

Follow the [Update homepage promotion slots](/repos/frontend/update-homepage-promotion-slots.html) instructions, using an appropriate image and text.
Do this on Integration or Staging.

## Use a restored database in an app

Follow the [Restore an RDS instance via the AWS CLI](/manual/howto-backup-and-restore-in-aws-rds.html#restore-an-rds-instance-via-the-aws-cli) instructions for an app of your choice, on Integration or Staging.

## Force failover to GOV.UK mirror and Emergency publishing using the GOV.UK mirror

1. Warn in `#govuk-2ndline-tech` that you're about to do this, as it will lead to a spike in alerts and will also break continuous deployment for a while (due to Smokey failures).
1. Follow the [Forcing failover to the GOV.UK mirrors](/manual/fall-back-to-mirror.html#forcing-failover-to-the-gov-uk-mirrors) instructions on Integration or Staging.
1. To verify that it worked, visit a page at random and [purge the page from cache](/manual/purge-cache.html). Reload the page, to see the 'mirrored' version of the content. NB: you wouldn't do this in a real incident, as we'd want to serve Fastly's cached version for as long as possible.
1. Undo your changes to have Nginx handling requests again.

## Drill logging into accounts

Make sure you can log into the following accounts:

1. Your individual Fastly account
1. Your individual Statuspage account
1. Your individual Logit account
1. [Shared Heroku account](/manual/heroku.html)
1. [Shared CKAN account](/manual/data-gov-uk-2nd-line.html)
1. [Shared Rubygems account](/manual/publishing-a-ruby-gem.html)
1. [Shared NPM account](https://github.com/alphagov/govuk-secrets/tree/main/pass/2ndline/npm)

## Drill how to communicate when Slack is down

Ensure you know how to communicate with your 2nd line colleagues if Slack is unavailable.
See "[If Slack is unavailable](https://docs.google.com/document/d/144y8c2Ly-kG3JQkRitpBSIN3DrxLnPSmLDezEZRMGi4/edit#heading=h.15tbsnb0xhwp)" for details.

## Drill scaling up number of workers

In preparation for a spike in traffic, you can increase the number of unicorn workers for an app.
See [established connections exceeded](/manual/alerts/established-connections-exceed.html) for details.

Pick an application and drill scaling up the number of workers - see [example](https://github.com/alphagov/govuk-puppet/pull/11194).

You can create a branch of `govuk-puppet` and deploy that branch to Integration to see the unicorn worker change take effect. Delete the branch and re-deploy the latest release of Puppet when you're done.

## Drill enabling a code freeze

Choose a continuously-deployed app where you can make a meaningful change to the default branch, e.g. fixing a typo, or merging a Dependabot PR.

Either before merging the change, or part way through the continuous deployment process, follow the instructions for [implementing a deploy freeze](/manual/development-pipeline.html#check-for-or-implement-a-deploy-freeze) for that app.

Follow the deployment pipeline in Jenkins. Confirm that no further environment deployments are triggered. For example, if you implemented the deploy freeze just after the app was deployed to Staging, confirm that the app was then not automatically deployed to Production.

Remove the code freeze, then manually push the changes to all remaining environments so that they're in sync.
