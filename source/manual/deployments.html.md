---
owner_slack: "#govuk-developers"
title: Deployments
section: Deployment
layout: manual_layout
parent: "/manual.html"
---

On GOV.UK, all applications are set up for continuous deployment to integration, with the majority also having continuous deployment configured for staging and production.  Additionally, you can manually deploy a git reference (tag, branch, or commit SHA) of an application to any environment.

Continuous integration (CI) is run on new commits on the main branch, usually from merging a pull request. If the commits pass CI, they are automatically deployed to integration. After deployment, a set of smoke tests run in integration to verify that the application still works as expected.

If the smoke tests pass and the application has continuous deployment enabled, the deployment is promoted to staging. In staging another set of smoke tests run, and if they pass, the deployment will be promoted to production.

For applications without continuous deployment enabled, they will need to be manually deployed to staging and production.

The [Release app](https://release.publishing.service.gov.uk/applications) shows the currently deployed versions of each app and whether an app requires manual deployment to later environments.

## Manual deployments

You can manually deploy an application by triggering the "Deploy" GitHub Action workflow for that application’s repository.

This can be done in [GitHub’s web interface](https://docs.github.com/en/actions/managing-workflow-runs/manually-running-a-workflow):

1. Go to the "Actions" page in the application repository
1. Select the "Deploy" workflow from the list of workflows on the left hand side
1. Click "Run workflow"
1. Input the git reference and environment (ignore the "Use workflow from" option)
1. Click "Run workflow"

Or using [GitHub’s CLI](https://cli.github.com/manual/gh_workflow_run):

```bash
gh workflow run -R "alphagov/${REPO}" deploy.yml -F environment=${ENVIRONMENT} -F gitRef=${GIT_REF}
```

Manual deployments are never promoted to other environments.

## Overview of the deployment process

This is an example deploying an application to integration:

1. Developer merges a PR into main branch and it passes [CI](https://github.com/alphagov/whitehall/actions/workflows/ci.yml)
1. Triggers the ["Deploy" workflow](https://github.com/alphagov/whitehall/actions/workflows/deploy.yml) in GitHub Actions
    1. Builds and pushes an image to [AWS Elastic Container Registery (ECR)](https://aws.amazon.com/ecr/) in production
    1. Sends a webhook to [Argo Workflows in production](https://argo-workflows.eks.production.govuk.digital/workflows/apps)
1. Triggers the ["deploy-image" workflow](https://github.com/alphagov/govuk-helm-charts/blob/main/charts/argo-services/templates/workflows/deploy-image/workflow.yaml) in [Argo Workflows in production](https://argo-workflows.eks.production.govuk.digital/workflows/apps)
    1. Updates the image tag reference for integration in [govuk-helm-charts](https://github.com/alphagov/govuk-helm-charts/tree/main/charts/app-config/image-tags) with a new commit
    1. Adds a "deployed-to-<environment>" tag on the image in ECR
    1. Notifies the Release application of the deployment
1. [Argo CD in integration](https://argo.eks.integration.govuk.digital/applications) polls [govuk-helm-charts](https://github.com/alphagov/govuk-helm-charts) and detects updated image tag reference
    1. Triggers sync of the [`app-config`](https://argo.eks.integration.govuk.digital/applications/cluster-services/app-config) ([app-of-apps](https://argo-cd.readthedocs.io/en/stable/operator-manual/cluster-bootstrapping/#app-of-apps-pattern)) application in Argo CD
    1. Updates the Helm values for the deployed [app's Argo CD application resource](https://argo.eks.integration.govuk.digital/applications/cluster-services/whitehall-admin)
    1. Updates the Kubernetes deployment resource with the new image tag
1. Kubernetes does a [rolling update of the pods](https://kubernetes.io/docs/tutorials/kubernetes-basics/update/update-intro/)
1. Argo CD triggers the ["post-sync" workflow](https://github.com/alphagov/govuk-helm-charts/blob/main/charts/argo-services/templates/workflows/post-sync/workflow.yaml) in [Argo Workflows in integration](https://argo-workflows.eks.integration.govuk.digital/workflows/apps)
    1. Runs smoke tests for the app
    1. Checks if deployment should be promoted
    1. If so, sends a webhook to Argo Workflows (in production) to trigger deploy-image for the next environment.

## Troubleshooting

If your release does not make it to production:

1. Updates on status of Argo workflows are posted in #govuk-deploy-alerts.
2. Click on View workflow for your failed deployment.
3. You may be presented with am ugly login error, in which case try logging out, logging in and then clicking the view workflow button again.
4. The argo workflow will display a list of steps. To investigate the reason for failure, click on the failed job, and from the summary panel click on LOGS.
5. If the failure is due to a flakey smokey test, you can hit the RESUBMIT button for the full workflow.
