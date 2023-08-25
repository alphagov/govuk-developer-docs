---
title: Update an application's environment configuration
weight: 20
layout: multipage_layout
---

# Update an application's environment configuration

This tutorial aims to guide you through the process of updating an applications configuration in the govuk-helm-charts repository. You will be updating the configuration of an example test app, deploy and verify your changes.

The govuk-helm-chart repository contains configuration for how an app is deployed into an environment, for example CPU and memory allocation for pods, environment variable values, health check configuration etc.

1. Update the example test app configuration

    1. Clone the [govuk-helm-charts repository](https://github.com/alphagov/govuk-helm-charts.git).
    1. Create a new branch to add your changes.
    1. Locate the `govuk-replatform-test-app` values in [govuk-helm-charts repository](https://github.com/alphagov/govuk-helm-charts/tree/main/charts/app-config/values-integration.yaml).
    (Please note that `app-config/ci/integration-values.yml` is symlinked to `values-integration.yaml`, you just need to make changes in one of the files.)
    1. Add your `ENV_MESSAGE_<your name>` environment variable value with your own message.

1. Deploying the changes to the app

    Create the pull request (PR) on your branch. Your changes will get posted automatically to the #govuk-platform-engineering Slack channel for review by a member of the team. After your PR has been approved and passed status checks you can merge your PR.

1. See the changes in [Argo CD](https://argoproj.github.io/cd/) (a tool to help manage app deployments)

    You should be able to see your changes in the [manifest within Argo](https://argo.eks.integration.govuk.digital/applications/govuk-replatform-test-app?view=tree&orphaned=false&resource=&node=argoproj.io%2FApplication%2Fcluster-services%2Fgovuk-replatform-test-app%2F0&tab=manifest)

1. See your message from the environment variable in the example test app

    Navigate to the [test app](https://govuk-replatform-test-app.eks.integration.govuk.digital/?status=200) to see the `ENV_MESSAGE` as part of the page output, you have now successfully deployed the change to the GOV.UK Kubernetes integration cluster.

1. Tidy up your `ENV_MESSAGE`

    Revert your PR to tidy up the codebase. After your PR has been approved and passed status checks you can merge your PR to undo your changes.
