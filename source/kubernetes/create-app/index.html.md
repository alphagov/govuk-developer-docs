---
title: Create a new application on the GOV.UK Kubernetes Platform
weight: 20
layout: multipage_layout
---

# Create a new application

## Assumptions

This guide assumes the following:

- You have completed all the steps in the ["get started" guide][get-started] of the developer docs
- You are deploying an application named `example` (make sure to replace this with your
  application name in all steps as needed)
- You have pushed the application source code to a Github repository under the `alphagov`
  organisation with the `govuk` and `container` labels applied (this triggers setup of a number of
  Github Actions secrets from the organisation and permissions required for workflows)
- You have a Sentry project configured for your application (through `govuk-infrastructure`)

## Allow your application to be built as a Docker image

Add a `Dockerfile` to your application. If your application is written in Ruby, this should normally
be based on the [GOV.UK Ruby Images][images]. This should do everything necessary to create a
standalone image for your application.

> **Note**
> The best way to establish what you need to do is to find an existing GOV.UK application similar to
> yours, and adapt its `Dockerfile`.

## Add Github Actions workflows

You will need to add (at least) the following workflows:

- `CI` (to test your application)
- `release` (to create new releases and version tags)
- `deploy` (to build/push an image and trigger deployment by updating image tags)

Your Continuous Integration (CI) workflow will depend on the linting and testing needs of your
application, but will act as a dependency for further workflows to block deployment in case of
failure.

For the `release` and `deploy` workflows, you can copy the workflow definitions from an existing
GOV.UK application (in `.github/workflows`).

## Add image tag files to `govuk-helm-charts`

[GOV.UK Helm Charts](https://github.com/alphagov/govuk-helm-charts) uses image tag files to keep
track of the image tag deployed into each environment. Add an initial image tag file named after
your application into the `image-tags` folder for each of the four environments, i.e.
`charts/app-config/image-tags/{test,integration,staging/production}/example`:

```
image_tag: latest
automatic_deploys_enabled: true
promote_deployment: false
```

## Add initial secrets to AWS Secrets Manager

### Sentry

In order to set up Sentry for your app, you will need a _DSN_ from the Sentry UI. This must be
manually added as a key/value pair to the `govuk/common/sentry` secret in all three environments.

## Add app to `app-config` chart values

### Start with integration

Start off by adding your app to the integration environment by adding it to the array of application
Helm chart values in `charts/app-config/values-integration.yaml`. This can be as simple as:

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

There are configuration options available for a wide range of different needs your application may
have, from mounting volumes to disabling the default asset upload.

### Validate your deployment

You can now trigger your Deploy Github action to push an image to AWS ECS, and visit [Integration
Argo CD][argo]. After a short wait, your new application will be available to find on the
dashboard.

### Continue with the other environments

Repeat the steps above for the other environments' values files (`values-staging.yaml` and
`values-production.yaml`).

## Congratulations!

You've deployed an application to the Kubernetes platform!

[argo]: https://argo.eks.integration.govuk.digital/applications
[generic-app]: https://github.com/alphagov/govuk-helm-charts/blob/main/charts/generic-govuk-app/
[get-started]: /manual/get-started.html
[images]: https://github.com/alphagov/govuk-ruby-images
