---
owner_slack: "#govuk-developers"
title: Deployments
section: Deployment
layout: manual_layout
parent: "/manual.html"
---

GOV.UK applications can be deployed to one of three [environments](/manual/environments.html): Integration, Staging, and Production.

## Overview

Deployments are performed through a CI/CD pipeline powered by GitHub Actions, [Argo CD](https://argo-cd.readthedocs.io/en/stable/), and [Argo Workflows](https://argo-workflows.eks.production.govuk.digital/workflows/apps). Most apps use [continuous deployment](#continuous-deployment) (CD), but manual deployment is also supported.

We use [Helm charts](https://helm.sh/docs/topics/charts/) to define and manage [Kubernetes resources](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) for each app. These are stored in the [`govuk-helm-charts` repo](https://github.com/alphagov/govuk-helm-charts). The source of truth is the image tag configuration for each app in the [`app-config` Helm chart](https://github.com/alphagov/govuk-helm-charts/tree/main/charts/app-config/image-tags).

The [Release app](https://release.publishing.service.gov.uk) shows the currently deployed versions of each app in each environment, including deployment status, deployment notes, and whether a [deployment freeze](#deployment-freezes) is in effect.

## Types of deployment

### Continuous deployment

1. A PR is merged into the main branch and passes CI.
1. GitHub Actions builds a new image and pushes it to GitHub Container Registry.
1. The [`release.yml` shared workflow](https://github.com/alphagov/govuk-infrastructure/blob/main/.github/workflows/release.yml) runs automatically in GitHub Actions and adds a Git tag for the release. Release tags are of the form `v` followed by a sequential number.
1. The [deploy-image Argo Workflow](https://github.com/alphagov/govuk-helm-charts/blob/main/charts/argo-services/templates/workflows/deploy-image/workflow.yaml) is triggered.
1. The image tag in `govuk-helm-charts` is updated and merged into `main`.
1. Argo CD detects the change, syncs the app, and deploys it to Integration.
1. Post-deployment smoke tests run in Integration.
1. If tests pass and promotion is enabled, the app is automatically promoted to Staging and then Production, each followed by smoke tests.

See the [overview of the deployment process](#overview-of-the-deployment-process) for a detailed walkthrough.

### Manual deployment

You can manually deploy an app to any environment by triggering the “Deploy” workflow in GitHub Actions.
Manual deployments are *never* automatically promoted to other environments, even on "continuously deployed" applications.

#### GitHub Web Interface

1. Go to the app's repo → "Actions"
1. Select the "Deploy" workflow
1. Click "Run workflow"
1. Enter `gitRef` and `environment`. `gitRef` can refer to a branch name, release tag, or commit sha.
1. Click "Run workflow"

#### GitHub CLI

```
gh workflow run -R "alphagov/${REPO}" deploy.yml -F environment=${ENVIRONMENT} -F gitRef=${GIT_REF}
```

After triggering a manual deployment:

1. Open the [Argo CD dashboard](https://argo.eks.integration.govuk.digital/applications) for your app/environment.
1. Click “Details” to verify the `ANNOTATIONS` include your commit SHA.
1. [Nudge Argo to sync the changes more quickly](#nudge-argo-to-sync-faster)
1. Confirm the Deployment pod is up-to-date (green tick).

## Deployment rules

- Deploy between 9:30am–5pm (4pm on Fridays).
- If your code includes undeployed changes by other developers, ask them first before deploying their changes.
- Check for [deploy notes in Release](https://release.publishing.service.gov.uk) or an [active code freeze](#deployment-freezes).
- Announce risky deploys in `#govuk-technical-on-call`.

## Deployment freezes

Code freezes block automatic deployment and are applied via changes to `govuk-helm-charts`, by setting `automatic_deploys_enabled: false` on the corresponding app.

Manual deploys are still possible during a freeze, however. To deter accidental manual deployments, you should:

1. Check "Freeze deployments?" in Release to add a visual label.
1. Notify on Slack `#govuk-developers` with `@channel`, and email govuk-tech-members@digital.cabinet-office.gov.uk.
1. Avoid merging PRs during a freeze unless urgent.

## Troubleshooting

### What if my deployment doesn’t reach Production?

1. Check updates in `#govuk-deploy-alerts`.
1. In [Argo Workflows](https://argo-workflows.eks.production.govuk.digital), click “View workflow”. (If you hit a login error, log out/in and retry.)
1. In the Argo Workflow UI, click the failed step → “LOGS.”
1. If it's a flaky test, hit RESUBMIT to retry the workflow.

### Check the Argo CD logs

#### Integration

- Go to [Argo CD Integration](https://argo.eks.integration.govuk.digital/)
- GitHub account must be in the [GOV.UK team](https://github.com/orgs/alphagov/teams/gov-uk)

#### Staging / Production

- [Argo CD Staging](https://argo.eks.staging.govuk.digital/)
- [Argo CD Production](https://argo.eks.production.govuk.digital/)
- Requires [production access](/manual/rules-for-getting-production-access.html)

## Nudge Argo to Sync Faster

Argo periodically polls for changes to image tags. To force a sync:

1. Visit [app-config in Argo](https://argo.eks.integration.govuk.digital/applications/cluster-services/app-config)
1. Click Refresh — this syncs all apps with updated tags.
1. Then navigate to the relevant app in Argo and click "Sync".
1. Wait for all of the Kubernetes resources to have finished promoting.

## Overview of the Deployment Process

This is what happens when a new app version is deployed:

1. **A new commit is pushed to `main`**  
   GitHub Actions CI is triggered automatically on successful merge.

1. **GitHub Actions builds and pushes a new Docker image**  
   - The container is tagged with the Git commit SHA  
   - It’s published to the [GitHub Container Registry (GHCR)](https://ghcr.io)

1. **The [deploy workflow](https://github.com/alphagov/whitehall/actions/workflows/deploy.yml) is triggered**  
   This may happen automatically (continuous deployment) or manually (e.g., via GitHub CLI).

1. **A webhook triggers [Argo Workflows](https://argo-workflows.eks.production.govuk.digital/workflows/apps)**  
   This runs the [`deploy-image`](https://github.com/alphagov/govuk-helm-charts/blob/main/charts/argo-services/templates/workflows/deploy-image/workflow.yaml) workflow.

1. **The `deploy-image` workflow does the following:**
   - Updates the app’s **image tag YAML file** in [`app-config/image-tags`](https://github.com/alphagov/govuk-helm-charts/tree/main/charts/app-config/image-tags)
   - Creates a branch and **automatically merges** it into `main` (no PR raised)
   - Notifies the [Release app](https://release.publishing.service.gov.uk) of the new deployment

1. **[Argo CD](https://argo.eks.integration.govuk.digital/applications) detects the change** and begins a sync:
   - Uses the [App of Apps pattern](https://argo-cd.readthedocs.io/en/stable/operator-manual/declarative-setup/#app-of-apps) via the [`app-config` chart](https://github.com/alphagov/govuk-helm-charts/tree/main/charts/app-config)
   - Re-renders Helm charts for the app and applies the new image tag
   - Triggers a **rolling update** in Kubernetes (zero-downtime if possible)

1. **During sync, Argo CD runs hooks:**
   - **PreSync hook** (if configured): builds frontend assets and uploads to S3 via a Kubernetes Job
   - **Sync hook**: runs database migrations (if defined) using a [Job template](https://github.com/alphagov/govuk-helm-charts/blob/main/charts/generic-govuk-app/templates/dbmigration-job.yaml)  
     > ⚠️ Migrations are **not guaranteed to complete before** new containers start — ensure they are [backward-compatible](/manual/deployment.html#make-database-changes-safe)

1. **After sync, the [post-sync workflow](https://github.com/alphagov/govuk-helm-charts/blob/main/charts/argo-services/templates/workflows/post-sync/workflow.yaml) runs:**
   - Executes [end-to-end smoke tests](https://github.com/alphagov/govuk-e2e-tests)
   - If tests pass and `promote_deployment: true` is set:
     - Triggers the `deploy-image` workflow for the **next environment**
     - This continues environment-by-environment (Integration → Staging → Production)
