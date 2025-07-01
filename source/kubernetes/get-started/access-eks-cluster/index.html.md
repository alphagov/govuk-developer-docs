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
    - `readonly`: has read-only access to AWS and the Kubernetes `apps` and `datagovuk` namespaces. In AWS, access to
     secrets and objects in S3 is not granted.
    - `developer`: has read-write access to most things in the `apps` and `datagovuk` namespaces, and can read the value
      of secrets with the `2ndline/` or `govuk/` prefixes. It cannot modify the secrets in any way.
    - `fulladmin`: has read-write "cluster-admin" access to everything in the cluster, across all namespaces, including secrets
    - `platformengineer`: also has read-write "cluster-admin access to everything in the cluster, across all namespaces, including secrets, but can be used by Platform Engineers on a regular basis without requiring an approval process

1. Obtain AWS credentials using `gds-cli` for the desired GOV.UK environment and role:

     ```sh
     eval $(gds aws govuk-<govuk-environment>-<role> -e --art 8h)
     export AWS_REGION=eu-west-1
     ```

    where:
    - `<govuk-environment>` is `integration`, `staging`, or `production`
    - `<role>` is `developer`, or `fulladmin`

## Note: About using the correct role

You should always assume the correct role for the job. By default, you should use the `readonly` role because it will give you access to all the information you need, without elevated privileges. If your task will require you to restart a pod or deployment, for example, you can use the `developer` role. Platform Engineers may use the `platformengineer` role if they need to perform actions in the EKS cluster that require "Cluster Admin" permissions but don't need Admin access to other AWS services.

Only "Platform Engineer" and "Production Admin" users can assume the `fulladmin` role, and should only do so if they have proven the `developer` or `platformengineer` roles are insufficient. Usage of the `fulladmin` role is monitored and may cause an alert to be raised in the future.

## Access a cluster for the first time

1. If it's your first time accessing the cluster through kubectl, add the `govuk` cluster to your kubectl configuration in `~/.kube/config`:

    ```sh
    aws eks update-kubeconfig --name govuk
    ```

1. To make it easier to switch between clusters, namespaces or users, you can rename the new context to match the name of the environment:

    Edit the `name` field of the last context in `~/.kube/config`. For example, for the staging environment you could set `name` to `govuk-staging`.

    See the [Kubernetes documentation on configuring access to multiple clusters](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/) for more information.

1. Set the current context:

    ```sh
    kubectl config use-context <govuk-environment>
    ```

    Where `govuk-environment` is the name of the context from step 2.

1. Set the [default namespace](/kubernetes/manage-app/get-app-info/#choose-and-set-a-namespace)

    ```sh
    kubectl config set-context --current --namespace=apps
    ```

1. Check that you can access the cluster:

    ```sh
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
    - `<role>` is `readonly`, `developer`, `fulladmin` or `platformengineer`

1. Switch to the corresponding kubectl context:

     ```sh
     kubectl config use-context <govuk-environment>
     ```

    You can list the available contexts by running:

     ```sh
     kubectl config get-contexts
     ```

## Working with multiple clusters at once

If you are working between multiple clusters, you may choose to use the GDS CLI and Kubectl commands like this:

```sh
gds aws govuk-[environment]-developer -- kubectl --context govuk-[environment] -n apps get pods
```

With this, you won't need to keep exporting and juggling different AWS credentials when swapping back and forth between environments or clusters.
