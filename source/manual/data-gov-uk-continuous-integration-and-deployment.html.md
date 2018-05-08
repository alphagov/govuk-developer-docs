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
[common-tasks]: manual/data-gov-uk-common-tasks

## Continuous integration

Travis is integrated in both [Find Data][find] and [Publish Data][publish] repositories so that when pushing to any branch or when a PR is created, `rake` is run. As a result, PRs cannot be merged unless tests pass.  You can find the `.travis.yml` file for each app in their respective repositories.

## Making Heroku Review Apps

A Heroku review app is created for each PR opened and remains active while the PR is open. This is provided using the [GOV.UK Heroku](https://docs.publishing.service.gov.uk/manual/review-apps.html#header) account.

Each Find PR app is linked to a master Heroku Elasticsearch addon, while each Publish PR app has it's own isolated ES addon for testing against.

There is also a permanent instance of [Publish](https://datagovuk-publish.herokuapp.com/) and [Find](https://datagovuk-find.herokuapp.com/) running code on the master branches, which serve as a kind of integration environment (including GOV.UK Signon).

GOV.UK Signon, Zendesk support tickets and Sentry are disabled for Heroku apps, with the default user for [Publish Data][publish] being assigned to the GDS organisation.

## Deploying Find Data and Publish Data

Deployment of the [Find Data][find] and [Publish Data][publish] applications to integration and staging is done automatically when the master branch is modified.

Each app repo has a manifest file to set the environment variables and link to PaaS services. The manifests are used by the deploy scripts, which use cloudfoundry’s autopilot module.

See [Common tasks][common-tasks] for how to deploy to production.

## Deploying Publish Data Worker

Publish Data is in fact two apps: the web app itself and `publish-data-worker`. Both apps share the same code in the [Publish Data repo][publish] but run off different manifest files in the repo.

In the Publish Data app the manifest file runs the default rails server command, but in the worker app manifest `bundle exec sidekiq` is run instead.

## Reindexing Elasticsearch

Populating the Elasticsearch service is done via a rake task in [Publish Data][publish]. It creates a new index, imports data from Elasticsearch, and changes the `datasets-[env]` alias to point to the new index.

Since [Find Data][find] connects to Elasticsearch through that alias, the switchover to the new index is instant. This method is detailed in [Elasticsearch’s documentation on zero-downtime](https://www.elastic.co/guide/en/elasticsearch/guide/current/index-aliases.html#index-aliases).
