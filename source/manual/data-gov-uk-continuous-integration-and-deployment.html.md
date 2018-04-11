---
owner_slack: "#datagovuk-tech"
title: Continuous integration and deployment
section: data.gov.uk
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-04-30
review_in: 3 months
---
[publish]: apps/datagovuk_find
[find]: apps/datagovuk_find

## Continuous integration

Travis is integrated in both [Find Data][find] and [Publish Data][publish] repositories so that when pushing to any branch or when a PR is created, rspec tests are run. As a result, PRs cannot be merged unless tests pass.  You can find the `travis.yml` file for each app in their respective repositories. Below are the Travis settings pages for each application:

* Find Data [Travis settings page](https://travis-ci.org/alphagov/datagovuk_find/settings)
* Publish Data [Travis settings page](https://travis-ci.org/alphagov/datagovuk_publish/settings)

## Deploying Find Data and Publish Data

Deployment of the [Find Data][find] and [Publish Data][publish] applications is done automatically when the master branch is modified.

Each application has different manifest files to set the environment variables and link to the services for PaaS, which can be found in their respective repositories. These manifests are used by the zero-downtime deploy scripts using cloudfoundry’s autopilot module.  See below on how use those scripts to deploy applications by hand.

On both [Find Data][find] and [Publish Data][publish], pushing a tag to GitHub called `v[number].[number].[number]` (e.g. `v1.2.1`) remote triggers a deployment to production by running the `deploy.sh` script. This is defined in the Travis configuration file in each repo. Make sure you use [semantic versioning](https://semver.org/) for tags.

More documentation is available at [Using Travis CI to deploy to Cloud Foundry](http://cruft.io/posts/using-travis-ci-to-deploy-to-cloud-foundry/).

The [Find Data][find] repository is linked to a Heroku account which generates apps for each PR opened. URLs looks like `https://find-data-pr-331.herokuapp.com/` and the app remains active while the PR is open. Speak to a member of the data.gov.uk team to get the account’s credentials.

## Deploying Publish Data Worker

While the [above](#deploying-find-data-and-publish-data) applies to both [Find Data][find] and [Publish Data][publish], Publish Data is in fact two apps; Publish Data itself and `publish-data-worker`. Both app share the same code in the [Publish Data repo][publish] but run off different manifest files in the repo. In the Publish Data app the manifest file runs the default rails server command, but in the worker app manifest `bundle exec sidekiq` is run instead.

You can monitor Sidekiq jobs for the worker here: [https://publish-data-beta-staging.cloudapps.digital/sidekiq/]().

The release tag method described [above](#deploying-find-data-and-publish-data) deploys both apps in this repository. See the relevant section in the [Find Data][find] `travis.yml`.
