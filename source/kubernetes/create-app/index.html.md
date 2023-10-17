---
title: Create a new application on the GOV.UK Kubernetes Platform
weight: 20
layout: multipage_layout
---

# Create a new application on the GOV.UK Kubernetes Platform

Assumption: All access set up

## Assumptions

This guide assumes the following:

- You are deploying an application named `example` (make sure to replace this with your
  application name in all steps as needed)
- You have generated an initial application and pushed it to a Github repository under the
  `alphagov` organisation with the `govuk` label applied (this triggers setup of a number of Github
  Actions secrets from the organisation and permissions required for workflows)
- You have set up the application in [GOV.UK Docker](https://github.com/alphagov/govuk-docker) (not
  covered by this guide) so that others can run it locally (this will also help you gain awareness
  of what environment configuration your application needs, especially if it is an existing
  application rather than a brand new one)
- You have a Sentry project configured for your application (through `govuk-infrastructure`)

## Add Github Actions workflows

### Add CI workflow
This will depend on the linting and testing needs of your application, but will act as a dependency
for further workflows to block deployment in case of failure.

### Add release workflow
Add a workflow invoking the shared release workflow template to `.github/workflows/release.yml`, for
example:

```yml
name: Release

on:
  workflow_dispatch:
  workflow_run:
    workflows: [CI]
    types: [completed]
    branches: [main]

jobs:
  release:
    if: github.event_name == 'workflow_dispatch' || github.event.workflow_run.conclusion == 'success'
    name: Release
    uses: alphagov/govuk-infrastructure/.github/workflows/release.yml@main
    secrets:
      GH_TOKEN: ${{ secrets.GOVUK_CI_GITHUB_API_TOKEN }}
```

> **Note**
> You may need to manually create a `v0` tag (e.g. against the most recent commit) in your
> repository for the `release` workflow to pick up on and start automatically creating releases with
> incremented versions.

### Add deploy workflow
Add a workflow invoking the shared deploy workflow template to `.github/workflows/deploy.yml`, for
example:

```yml
name: Deploy

run-name: Deploy ${{ inputs.gitRef || github.ref_name  }} to ${{ inputs.environment || 'integration' }}

on:
  workflow_dispatch:
    inputs:
      gitRef:
        description: 'Commit, tag or branch name to deploy'
        required: true
        type: string
        default: 'main'
      environment:
        description: 'Environment to deploy to'
        required: true
        type: choice
        options:
        - integration
        - staging
        - production
        default: 'integration'
  release:
    types: [released]

jobs:
  build-and-publish-image:
    if: github.event_name == 'workflow_dispatch' || startsWith(github.ref_name, 'v')
    name: Build and publish image
    uses: alphagov/govuk-infrastructure/.github/workflows/build-and-push-image.yml@main
    with:
      gitRef: ${{ inputs.gitRef || github.ref_name }}
    secrets:
      AWS_ACCESS_KEY_ID: ${{ secrets.AWS_GOVUK_ECR_ACCESS_KEY_ID }}
      AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_GOVUK_ECR_SECRET_ACCESS_KEY }}
  trigger-deploy:
    name: Trigger deploy to ${{ inputs.environment || 'integration' }}
    needs: build-and-publish-image
    uses: alphagov/govuk-infrastructure/.github/workflows/deploy.yml@main
    with:
      imageTag: ${{ needs.build-and-publish-image.outputs.imageTag }}
      environment: ${{ inputs.environment || 'integration' }}
    secrets:
      WEBHOOK_TOKEN: ${{ secrets.GOVUK_ARGO_EVENTS_WEBHOOK_TOKEN }}
      WEBHOOK_URL: ${{ secrets.GOVUK_ARGO_EVENTS_WEBHOOK_URL }}
      GH_TOKEN: ${{ secrets.GOVUK_CI_GITHUB_API_TOKEN }}
```

## Add image tag files to `govuk-helm-charts`

[GOV.UK Helm Charts](https://github.com/alphagov/govuk-helm-charts) uses image tag files to keep
track of the image used for the active deployment in each environment. Add an initial tag file named
after your application into the `image-tags` folder for each of the four environments, i.e.
`charts/app-config/image-tags/{test,integration,staging/production}/example`:

```
image_tag: v1
automatic_deploys_enabled: true
promote_deployment: true
```

## Add initial secrets to AWS Secrets Manager
...

## Add app to `app-config` chart values
Start off by adding your app to the integration environment by adding it to the Helm chart values in
`charts/app-config/values-integration.yaml`. This can be as simple as:

```yml
- name: example
```
