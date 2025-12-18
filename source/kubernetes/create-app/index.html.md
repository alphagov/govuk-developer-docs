---
title: Create a new application on the GOV.UK Kubernetes Platform
weight: 20
layout: multipage_layout
---

# Create a new application

## Assumptions

This guide assumes the following:

- You have an approved ADR or RFC document for the new application
- You have completed all the steps in the ["get started" guide][get-started] of the developer docs
- You are deploying an application named `example` (make sure to replace this with your
  application name in all steps as needed)

## Create a new GOV.UK repository for your application

Follow the steps in the ["Configure a new GOV.UK repository" guide][new-repo].

This should have set up your application, and pushed your source code to a Github repository under the `alphagov` organisation with the `govuk` and `container` labels applied

## Set up Sentry for your application

You will need to set up Sentry for your app by adding it to the [Sentry terraform file](https://github.com/alphagov/govuk-infrastructure/blob/main/terraform/deployments/sentry/locals.tf)

## Set up CI for your application

1. [Allow your application to be built as a Docker image](#allow-your-application-to-be-built-as-a-docker-image)
1. [Add GitHub actions workflows to your app](#add-gitHub-actions-workflows)
1. Create a [release](https://github.com/alphagov/search-api-v2-beta-features/releases) of your app. You’ll need to manually create the first release so that it can be picked up by the GitHub actions.

### Allow your application to be built as a Docker image

Add a [Dockerfile](https://github.com/alphagov/search-api-v2-beta-features/blob/main/Dockerfile) to your app. This is different to setting up govuk-docker. This Dockerfile allows CI to build your app.

If your application is written in Ruby, this should normally be based on the [GOV.UK Ruby Images][images]. This should do everything necessary to create a
standalone image for your application.

> **Note**
> The best way to establish what you need to do is to find an existing GOV.UK application similar to
> yours, and adapt its `Dockerfile`.

### Add GitHub Actions workflows

You will need to add (at least) the following workflows:

- `CI` (to test your application)
- `release` (to create new releases and version tags)
- `deploy` (to build/push an image and trigger deployment by updating image tags)

Example workflows [here](https://github.com/alphagov/search-api-v2-beta-features/tree/4bffd3bdd6ef6d41f27434ad167515637e0e1675/.github/workflows)

Your Continuous Integration (CI) workflow will depend on the linting and testing needs of your
application, but will act as a dependency for further workflows to block deployment in case of
failure.

For the `release` and `deploy` workflows, you can copy the workflow definitions from an existing
GOV.UK application (in `.github/workflows`).

## Deploy app to environments

Start with Integration

1. [Add image tag file to govuk-helm-charts](#add-image-tag-files-to-govuk-helm-charts) for integration
    - Set your initial image_tag value to match the version number of your release. Do not use “latest”, this will result in issues with your application pulling in updates.
1. [Add secrets in AWS Secrets Manager](#add-initial-secrets-to-aws-secrets-manager)
1. [Add app to app-config chart values](#add-app-to-app-config-chart-values) in [integration](https://github.com/alphagov/govuk-helm-charts/blob/main/charts/app-config/values-integration.yaml)
1. Add a [CNAME record](https://github.com/alphagov/govuk-infrastructure/pull/3289/files) for your application in the Integration environment
1. [Check that your app builds correctly in Argo CD](#validate-your-deployment)

Once the app builds successfully, follow the Deploy steps for [Staging](https://github.com/alphagov/govuk-helm-charts/blob/main/charts/app-config/values-staging.yaml) and [Production](https://github.com/alphagov/govuk-helm-charts/blob/main/charts/app-config/values-production.yaml).

Set `promote_deployment: true` if you want automatic promotions to higher environments.

### Add image tag files to `govuk-helm-charts`

[GOV.UK Helm Charts](https://github.com/alphagov/govuk-helm-charts) uses image tag files to keep track of the image tag deployed into each environment, as well as the [deployment configuration](https://docs.publishing.service.gov.uk/manual/deployments.html#deployment-configuration). Add an initial image tag file named after your application into the `image-tags` folder for each of the four environments, i.e. `charts/app-config/image-tags/{test,integration,staging/production}/example`:

```
image_tag: latest
automatic_deploys_enabled: true
promote_deployment: false
```

### Add initial secrets to AWS Secrets Manager

#### Rails

Rails applications use `SECRET_KEY_BASE`. [Rails](https://guides.rubyonrails.org/command_line.html#bin-rails-secret) allows you to generate these
using `rails secret`. This must be manually added as a key/value pair to the `govuk/common/rails-secret-key-base` secret in all three environments.

#### Sentry

In order to set up Sentry for your app, you will need a _DSN_ from the Sentry UI.

- Go to `Settings -> Projects`
- Select your project (e.g. `account-api`)
- Select `Settings -> Client Keys (DSN)`

This must be manually added as a key/value pair to the `govuk/common/sentry` secret in all three environments.

### Add app to `app-config` chart values

Start off by adding your app to the environment by adding it to the array of application
Helm chart values in `charts/app-config/values-{environment}.yaml`. This can be as simple as:

```yml
- name: example
```

This will use the [generic-govuk-app][generic-app] Helm chart to set up your application. You can
find the default values in `values.yaml` in the chart folder, and amend your configuration's
`helmValues` value to override them.

For example, if your app needs a `RETICULATE_SPLINES` environment variable set to "1" in a given
environment, your integration configuration could look like this:

```yml
- name: example
  helmValues:
    extraEnv:
      - name: RETICULATE_SPLINES
        value: 1
```

There are [configuration options](https://github.com/alphagov/govuk-helm-charts/blob/main/charts/generic-govuk-app/values.yaml)
available for a wide range of different needs your application may have, from mounting volumes to disabling the default asset upload.

#### Validate your deployment

You can now trigger your Deploy GitHub action to push an image to AWS ECS, and visit [Integration
Argo CD][argo]. After a short wait, your new application will be available to find on the
dashboard.

## Congratulations!

You've deployed an application to the Kubernetes platform!

[argo]: https://argo.eks.integration.govuk.digital/applications
[generic-app]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/generic-govuk-app/
[get-started]: /manual/get-started.html
[new-repo]: /manual/github-new-repo.html
[images]: https://github.com/alphagov/govuk-ruby-images
