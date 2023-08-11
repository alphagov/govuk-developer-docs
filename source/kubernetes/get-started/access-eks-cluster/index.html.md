---
title: Access EKS cluster
weight: 22
last_reviewed_on: 2022-02-01
review_in: 6 months
---

# Access EKS cluster

You must access the GOV.UK Kubernetes platform [Elastic Kubernetes Service cluster](https://kubernetes.io/docs/concepts/overview/components/) to use the platform.

To access the cluster, you must have:

- [installed gds-cli](https://docs.publishing.service.gov.uk/manual/get-started.html#3-install-gds-command-line-tools)
- [obtained access to AWS](https://docs.publishing.service.gov.uk/manual/get-started.html#7-get-aws-access)
- [accessed AWS](https://docs.publishing.service.gov.uk/manual/get-started.html#8-access-aws-for-the-first-time) using `gds-cli`

You must select a role and environment to make sure you gain access to the right cluster.

## Select a role and environment

An [AWS Identity and Access Management (IAM) role](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html) is an IAM identity that has specific permissions.

You must select one of the following roles to access the cluster:

- admin
- poweruser
- readonly

The admin role:

- has read-write access to a specific cluster in a specific environment
- can view everything in that cluster including secrets

The poweruser role:

- has read-write access to a specific namespace in a specific cluster in a specific environment
- can view everything in that namespace excluding secrets

The readonly role:

- has readonly access to a specific cluster in a specific environment
- can view everything in that cluster excluding secrets

1. Open the `gds-cli`.

1. Run the following to export the AWS credentials for the appropriate GOV.UK environment and role:

  ```sh
  eval $(gds aws govuk-<govuk-environment>-<role> -e --art 8h)
  export AWS_REGION=eu-west-1
  ```
  where:
  - `<govuk-environment>` is the GOV.UK environment that you want to get credentials for and will be `test`, `integration`, `staging`, or `production`
  - `<role>` is the appropriate role and will be `admin`, `poweruser` or `readonly`

## Test your access

1. If it's your first time accessing the cluster through kubectl, add the `govuk` cluster to your kubectl configuration in `~/.kube/config`:

    ```sh
    aws eks update-kubeconfig --name govuk
    ```

1. To make it easier to switch between clusters, namespaces or users, edit your kubectl configuration (usually located at `~/.kube/config`) and rename the new context with a more human readable context name.

    To do this, edit the `name` field of the last context in the kubectl configuration. For example, you can set the `name` to `<govuk-environment>`.

    See the [Kubernetes documentation on configuring access to multiple clusters](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/) for more information.

1. To check that you have access to the cluster, run:

    ```sh
    kubectl config use-context <govuk-environment>
    kubectl cluster-info
    ```

    If you have access, you should get information about the GOV.UK EKS cluster control plane, like in the following example:

    ```sh
    Kubernetes control plane is https://{GOVUK_CLUSTER_ADDRESS}.{AWS_REGION}.eks.amazonaws.com
    ```

## Switching clusters

To switch clusters:

1. Run the export AWS credentials command in the `gds-cli`, selecting the appropriate GOV.UK environment and role:

     ```sh
     eval $(gds aws govuk-<govuk-environment>-<role> -e --art 8h)
     export AWS_REGION=eu-west-1
     ```
    where:
    - `<govuk-environment>` is the GOV.UK environment that you want to get credentials for and will be `test`, `integration`, `staging`, or `production`
    - `<role>` is the appropriate role and will be `admin`, `poweruser` or `readonly`

1. Switch to the correct kubectl context:

     ```sh
     kubectl config use-context <govuk-environment>
     ```

    You can get a list of context by running:

     ```sh
     kubectl config get-contexts
     ```
