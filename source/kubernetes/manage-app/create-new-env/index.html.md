---
title: Create a new environment
weight: 49
layout: multipage_layout
---

> 🚧 This document is outdated and untested. 🚧
>
> If you are thinking about creating an additional GOV.UK Kubernetes cluster, please get in touch with [#govuk-platform-engineering team] and we'll be happy to help you to achieve your goals.

# Create a new environment

To create a new environment, you must:

- create a new AWS account
- create secrets for the new environment
- create a new empty environment
- deploy the Terraform modules
- check the environment is working

## Create a new AWS account

To create a new AWS account, you will need to speak to the GDS Engineering Enablement team and obtain access to the private repo with the AWS Account Terraform - once done, instructions on how to create an AWS account are in the relevant repository.

## Create secrets for the new environment

Copy the secrets from an existing environment, for example by running [the `copy_sm_secrets.py` transfer script](https://gist.github.com/theseanything/1bb8add0077d3a2f5d979c12c6b9f140) with the following aws-cli profile names:

- `--src-profile`, the existing environment to copy the secrets from
- `--dst-profile`, the new environment to copy the secrets to

You can edit the copied secrets for the new environment using the AWS console for Secrets Manager.

## Deploy the Terraform modules

Deploy the Terraform root modules in order. You need to make sure you are using the correct Terraform Workspace for the environment you are working in - if you've just created a new environment and new AWS account, you will need to make sure you create the Terraform Workspace for each of the modules you are working with, e.g.

- cluster-infrastructure-`<ENVIRONMENT>`
- cluster-services-`<ENVIRONMENT>`
- ecr-`<ENVIRONMENT>`
- tfc-aws-config-`<ENVIRONMENT>`
- vpc-`<ENVIRONMENT>`

Replace `<ENVIRONMENT>` with the name of your environment. You must also ensure that the credentials/variables are created and set correctly for each of the modules to run.

### 1. Deploy the `ecr` module

[Amazon Elastic Container Registry (ECR)](https://docs.aws.amazon.com/AmazonECR/latest/userguide/what-is-ecr.html) stores [container images](https://kubernetes.io/docs/concepts/containers/images/) for the GOV.UK Kubernetes platform.

The [`ecr` module](https://github.com/alphagov/govuk-infrastructure/tree/main/terraform/deployments/ecr) creates the ECR for the new environment.

1. In the command line, go to the `govuk-infrastructure/terraform/deployments/ecr/` folder on your local machine.

1. Run the following to deploy the `ecr` module:

    ```
    gds aws govuk-<ENVIRONMENT>-admin -- \
      terraform init -backend-config <ENVIRONMENT>.backend -reconfigure -upgrade

    gds aws govuk-<ENVIRONMENT>-admin -- \
      terraform apply -var-file ../variables/<ENVIRONMENT>/ecr.tfvars
    ```

    `<ENVIRONMENT>` is the environment type you defined in the earlier step.

### 2. Deploy the `cluster-infrastructure` module

The [`cluster-infrastructure` module](https://github.com/alphagov/govuk-infrastructure/tree/main/terraform/deployments/cluster-infrastructure) creates the AWS resources for the GOV.UK Kubernetes platform [Elastic Kubernetes Service (EKS) cluster](https://kubernetes.io/docs/concepts/overview/components/).

1. In the command line, go to `govuk-infrastructure/terraform/deployments/cluster-infrastructure/` on your local machine.

1. Run the following to create the AWS resources for the EKS cluster:

    ```
    gds aws govuk-<ENVIRONMENT>-admin -- \
      terraform init -backend-config <ENVIRONMENT>.backend -reconfigure -upgrade

    gds aws govuk-<ENVIRONMENT>-admin -- \
      terraform apply
    ```

    `<ENVIRONMENT>` is the environment type you defined in the earlier step.

#### Delete the `aws-auth` configmap

Creating the AWS resources for the EKS cluster also creates a default `aws-auth` configmap.

This configmap does not work with the GOV.UK Kubernetes configuration. You must delete the configmap for the new environment to work.

Run the following to delete the `aws-auth` configmap:

```
gds aws govuk-${ENV?}-admin -- aws eks update-kubeconfig --name govuk && kubectl -n kube-system delete cm aws-auth
```

### 3. Deploy the `govuk-publishing-infrastructure` module

The [`govuk-publishing-infrastructure` module](https://github.com/alphagov/govuk-infrastructure/tree/main/terraform/deployments/govuk-publishing-infrastructure) creates and manages AWS resources for the GOV.UK apps where we are not yet able to manage those resources using Kubernetes.

1. In the command line, go to `govuk-infrastructure/terraform/deployments/govuk-publishing-infrastructure/` on your local machine.

1. Run the following to deploy the `govuk-publishing-infrastructure` module:

    ```
    gds aws govuk-<ENVIRONMENT>-admin -- \
      terraform init -backend-config <ENVIRONMENT>.backend -reconfigure -upgrade

    gds aws govuk-<ENVIRONMENT>-admin -- \
      terraform apply
    ```

    `<ENVIRONMENT>` is the environment type you defined in the earlier step.

### 4. Deploy the `cluster-services` module

The [`cluster-services` module](https://github.com/alphagov/govuk-infrastructure/blob/main/terraform/deployments/cluster-services) deploys the [services that enable GOV.UK](https://github.com/alphagov/govuk-infrastructure/tree/main/terraform/deployments/cluster-services) into the cluster.

1. In the command line, go to `govuk-infrastructure/terraform/deployments/cluster-services/` on your local machine.

1. Run the following to deploy the `cluster-services` module:

    ```
    gds aws govuk-<ENVIRONMENT>-admin -- \
      terraform init -backend-config <ENVIRONMENT>.backend -reconfigure -upgrade

    gds aws govuk-<ENVIRONMENT>-admin -- \
      terraform apply
    ```

    `<ENVIRONMENT>` is the environment type you defined in the earlier step.

## Check the environment is working

You should now have successfully created a new environment on the GOV.UK Kubernetes platform.

To check the environment is working, go to the new environment URL endpoint at `https://www.eks.<ENVIRONMENT>.govuk.digital`. For example, the endpoint for a new production environment is `https://www.eks.production.govuk.digital`.

You must be in the office or on the VPN to access this endpoint.

If the environment URL endpoint is not behaving as expected or shows an error, contact [#govuk-platform-engineering team].

## Setting access permissions

You may want to ensure that the correct engineers have access to the account/environment you have just set up. You can check and configure this in the [govuk-user-reviewer](https://github.com/alphagov/govuk-user-reviewer) (internal) repository.

If a user requires credentials, you should ensure they first have a "GDS Users" AWS user created prior to granting them roles via the `govuk-user-reviewer` repository above. There is a [self-service portal](https://gds-request-an-aws-account.cloudapps.digital/) to do this.

## Supporting information

When you create the new environment, the process will also create an instance of the [Kubescape tool](https://github.com/armosec/kubescape) to track vulnerabilities and other metrics.

See the [Kubescape user hub](https://hub.armosec.io/docs/welcome-to-kubescape-user-hub) for more information.

See also the [Kubernetes conceptual overview documentation](https://kubernetes.io/docs/concepts/overview/what-is-kubernetes/) for more information on Kubernetes overall.

[#govuk-platform-engineering team]: /contact-platform-engineering-team.html
