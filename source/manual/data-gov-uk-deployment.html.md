---
owner_slack: "#govuk-platform-health"
title: Deployments for data.gov.uk
section: data.gov.uk
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-09-06
review_in: 6 months
---
[publish]: apps/datagovuk_publish
[find]: apps/datagovuk_find
[publish-ci]: https://travis-ci.org/alphagov/datagovuk_publish/
[find-ci]: https://travis-ci.org/alphagov/datagovuk_find
[heroku]: https://docs.publishing.service.gov.uk/manual/review-apps.html#header
[publish-heroku]: https://dashboard.heroku.com/pipelines/7fb4c1c1-618e-42da-ba71-1cb0beb6c5c8
[find-heroku]: https://dashboard.heroku.com/pipelines/0ca23219-ac0e-4d6c-9d5f-40829c6209db
[paas]: https://docs.cloud.service.gov.uk/#set-up-command-line
[staging]: http://test.data.gov.uk
[cf-docs]: https://docs.cloudfoundry.org

## Continuous Integration

Travis is configured for both [Publish (CI)][publish-ci] and [Find (CI)][find-ci] according to `.travis.yml` file in each repo. Each PR request should automatically build a [Heroku Review App][heroku], which can be accessed from the PR page on GitHub.

## Heroku Integration Environment

Heroku has a pipeline for each of [Publish][publish-heroku] and [Find][find-heroku], with each app set to run in its 'integration' environment. Each pipeline has a permanent instance of the app, providing a common instance of Elasticsearch for us by the [Find] PR apps.

Each repo has a `Procfile` and an `app.json` file, which help to specify how the app is deployed. The environment variables ('Config Vars') are then set via the website, both for the permanent app instance, and the review app template.

## PaaS Staging and Production Environment

[Publish] and [Find] are provisioned on [GOV.UK PaaS][paas]. Each app repo contains a set of manifests that specify the container settings for when it's deployed. You can deploy an app manually as follows.

```
## run once to install the plugin
cf add-plugin-repo CF-Community https://plugins.cloudfoundry.org
cf install-plugin autopilot -r CF-Community -f

## manually deploy the publish app
cf zero-downtime-push publish-data-beta-staging -f staging-app-manifest.yml
cf zero-downtime-push publish-data-beta-staging-worker -f staging-worker-manifest.yml
```

Merging code into master triggers a deployment to the '[staging]' environment, but you can also do this manually as follows. A production deployment is triggered when a new GitHub release is created for the app.

For more advanced uses of the PaaS that are not covered in the PaaS internal documentation (e.g. provisioning an app using a buildpack that is not Ruby or Java), refer to the [Cloud Foundry documentation][cf-docs].
