---
title: Kubernetes/EKS cheatsheet
layout: multipage_layout
weight: 5
---

# Kubernetes/EKS cheatsheet for GOV.UK developers

This page lists some example commands for interacting with the GOV.UK
Kubernetes clusters.

See <https://kubernetes.io/docs/reference/kubectl/quick-reference/> for a more
general quick-reference guide.

## Prerequisites

1. You need to have completed [Access an EKS
   cluster](get-started/access-eks-cluster/) from the [get started
   guide](get-started/). If you skimmed those instructions, make sure you have
   configured your shell:

    ```sh
    export AWS_REGION=eu-west-1
    alias k=kubectl
    ```

1. Obtain credentials to access the cluster. Use an IAM role with sufficient permissions:
    - `-readonly` roles can view logs and configuration
    - `-poweruser` roles can run Rake tasks or open a shell
    - `-administrator` roles can modify base cluster services (you should not
      normally need this)

    For example:

    ```sh
    # Obtain IAM credentials for the AWS account (integration, staging, production).
    eval $(gds aws govuk-integration-poweruser -e --art 8h)

    # Select the corresponding kubectl context. `k config get-contexts` lists them.
    k config use-context integration

    # Use the `apps` namespace by default. You only need to do this the first
    # time you use each cluster.
    k config set-context --current --namespace=apps
    ```

## Common tasks

### View recent logs for an app

From one pod, chosen arbitrarily:

```sh
k logs deploy/account-api
```

From all pods:

```sh
k logs -l app=account-api
```

### Open a Rails console

```sh
k exec -it deploy/router-api -- rails c
```

### Open a shell in an app container

```sh
k exec -it deploy/government-frontend -- bash
```

### Open a shell on Router

```sh
k exec -it deploy/router -c nginx
```

### List the available Rake tasks for an app

```sh
k exec deploy/email-alert-api -- rake -T
```

### Run a Rake task

```sh
k exec deploy/email-alert-api -- \
  rake 'support:view_emails[your.email@digital.cabinet-office.gov.uk]'
```

See [Run a Rake task on EKS](/manual/running-rake-tasks.html#run-a-rake-task-on-eks).

## App releases and rollouts / deployments

- The [Release app](https://release.publishing.service.gov.uk/applications)
  shows what's deployed where.
- Deployment automation is via [Argo
  CD](https://argo.eks.integration.govuk.digital/applications). Post-deploy
  smoke tests run via [Argo
  Workflows](https://argo-workflows.eks.integration.govuk.digital/workflows/apps?limit=100).
- To deploy a branch or manually promote a release:
    1. Go to the app's repo in GitHub.
    1. Choose **Actions**.
    1. Choose **Deploy** from the left-hand column.
    1. Click **Run workflow**.
    1. Leave the **Use workflow from** dropdown set to `main`, unless you are
       testing a change to the workflow itself.
    1. Under **Commit, tag or branch name to deploy**, enter the branch or
       release tag.

## Smokey test logs

Argo Workflows keeps logs only for failed workflow tasks.

The Smokey cronjob keeps the last 3 successes and the last 3 failures.

## Dashboards

Dashboards are on [Grafana](https://grafana.eks.production.govuk.digital/).

You can see Sidekiq queue lengths on the [Sidekiq Grafana
dashboard](https://grafana.eks.production.govuk.digital/d/sidekiq-queues).
