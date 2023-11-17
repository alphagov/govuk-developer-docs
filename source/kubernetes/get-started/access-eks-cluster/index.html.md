---
title: Access an EKS cluster
weight: 22
layout: multipage_layout
---

# Access a GOV.UK EKS cluster

There are 3 GOV.UK clusters: integration, staging and production. These correspond to the integration, staging and production GOV.UK environments, which belong to the integration, staging and production AWS accounts respectively.

## Prerequisites

This document assumes that you have already followed the steps in [Get started developing on GOV.UK](https://docs.publishing.service.gov.uk/manual/get-started.html).

## Obtain AWS credentials for your role in the cluster's AWS account

1. Choose the [AWS IAM role](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html) that you will use to access the cluster:

    - `admin`: has read-write access to everything in the cluster, including secrets
    - `poweruser`: has read-write access to everything in the `apps` namespace, but cannot view or modify secrets
    - `readonly`: can read everything in the `apps` namespace, except for secrets

1. Obtain AWS credentials using `gds-cli` for the desired GOV.UK environment and role:

  ```sh
  eval $(gds aws govuk-<govuk-environment>-<role> -e --art 8h)
  export AWS_REGION=eu-west-1
  ```

  where:
  - `<govuk-environment>` is `integration`, `staging`, or `production`
  - `<role>` is `admin`, `poweruser`, or `readonly`

## Access a cluster for the first time

1. If it's your first time accessing the cluster through kubectl, add the `govuk` cluster to your kubectl configuration in `~/.kube/config`:

    ```sh
    aws eks update-kubeconfig --name govuk
    ```

1. To make it easier to switch between clusters, namespaces or users, you can rename the new context to match the name of the environment:

    Edit the `name` field of the last context in `~/.kube/config`. For example, for the staging environment you could set `name` to `govuk-staging`.

    See the [Kubernetes documentation on configuring access to multiple clusters](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/) for more information.

1. Check that you can access the cluster:

    ```sh
    kubectl config use-context <govuk-environment>
    kubectl get deploy/frontend
    ```

    You should see output similar to:

    ```
    NAME       READY   UP-TO-DATE   AVAILABLE   AGE
    frontend   2/2     2            2           399d
    ```

## Access a cluster that you have accessed before

To switch to a cluster that you have previously configured in `~/.kube/config` as above:

1. Obtain AWS credentials using `gds-cli` for the desired GOV.UK environment and role:

     ```sh
     eval $(gds aws govuk-<govuk-environment>-<role> -e --art 8h)
     export AWS_REGION=eu-west-1
     ```

    where:
    - `<govuk-environment>` is `integration`, `staging`, or `production`
    - `<role>` is `admin`, `poweruser`, or `readonly`

1. Switch to the corresponding kubectl context:

     ```sh
     kubectl config use-context <govuk-environment>
     ```

    You can list the available contexts by running:

     ```sh
     kubectl config get-contexts
     ```
