---
title: Access an EKS cluster
weight: 22
layout: multipage_layout
---

# Access a GOV.UK EKS cluster

There are 3 GOV.UK clusters: integration, staging and production. These correspond to the integration, staging and production GOV.UK environments, which belong to the integration, staging and production AWS accounts respectively.

## Prerequisites

This document assumes that you have already followed the steps in [Get started developing on GOV.UK](https://docs.publishing.service.gov.uk/manual/get-started.html).

## Set up all three GOV.UK EKS clusters for the first time

You'll need to do the following three times: one for each environment. Swap `govuk-environment` as appropriate.

1. Assume a role in the environment:

```
export AWS_REGION=eu-west-1
eval $(gds aws govuk-<govuk-environment>-readonly -e --art 8h)
```

1. Add this environment's `govuk` cluster to your kubectl configuration in `~/.kube/config`, and name it (e.g. `--alias govuk-integration` or `--alias integration`):

    ```sh
    aws eks update-kubeconfig --name govuk --alias govuk-<govuk-environment>
    ```

1. Set the current context:

    ```sh
    kubectl config use-context <alias>
    ```

    Where `alias` is the name of the context you chose in the step above.

1. Set the [default namespace](/kubernetes/manage-app/get-app-info/#choose-and-set-a-namespace) of the context:

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

Now repeat for the other two environments.

## Access a GOV.UK EKS cluster that you have configured already

To switch to a cluster that you have previously configured in `~/.kube/config` as above:

1. Obtain AWS credentials using `gds-cli` for the desired GOV.UK environment and [role](#choosing-the-correct-role-for-accessing-the-cluster):

     ```sh
     eval $(gds aws govuk-<govuk-environment>-<role> -e --art 8h)
     export AWS_REGION=eu-west-1
     ```

1. Switch to the corresponding kubectl context:

     ```sh
     kubectl config use-context <govuk-environment>
     ```

    You can list the available contexts by running:

     ```sh
     kubectl config get-contexts
     ```

## Choosing the correct role for accessing the cluster

The following [AWS IAM roles](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html) can be used to access a GOV.UK EKS cluster:

- `readonly`: has read-only access to AWS and the Kubernetes `apps` and `datagovuk` namespaces. In AWS, access to secrets and objects in S3 is not granted.
- `developer`: has read-write access to most things in the `apps` and `datagovuk` namespaces, and can read the value of secrets with the `2ndline/` or `govuk/` prefixes. It cannot modify the secrets in any way.
- `fulladmin`: has read-write "cluster-admin" access to everything in the cluster, across all namespaces, including secrets
- `platformengineer`: also has read-write "cluster-admin access to everything in the cluster, across all namespaces, including secrets, but can be used by Platform Engineers on a regular basis without requiring an approval process

You should always assume the correct role for the job. By default, you should use the `readonly` role because it will give you access to all the information you need, without elevated privileges. If your task will require you to restart a pod or deployment, for example, you can use the `developer` role. Platform Engineers may use the `platformengineer` role if they need to perform actions in the EKS cluster that require "Cluster Admin" permissions but don't need Admin access to other AWS services.

Only "Platform Engineer" and "Production Admin" users can assume the `fulladmin` role, and should only do so if they have proven the `developer` or `platformengineer` roles are insufficient. Usage of the `fulladmin` role is monitored and may cause an alert to be raised in the future.

## Working with multiple clusters at once

If you are working between multiple clusters, you may choose to use the GDS CLI and Kubectl commands like this:

```sh
gds aws govuk-[environment]-developer -- kubectl --context govuk-[environment] -n apps get pods
```

With this, you won't need to keep exporting and juggling different AWS credentials when swapping back and forth between environments or clusters.
