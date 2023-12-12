---
title: Add secrets to your app
weight: 48
layout: multipage_layout
---

# Add secrets to your app

You can add new [secrets](https://kubernetes.io/docs/concepts/configuration/secret/) to your app on the GOV.UK Kubernetes platform.

Before you create a secret, check whether you need to use a secret or if you should use another method instead, such as [AWS Identity and Access Management (IAM)](https://aws.amazon.com/iam/).

If you decide that you need to use a secret, check if that secret already exists in the [AWS Secrets Manager](https://eu-west-1.console.aws.amazon.com/secretsmanager/listsecrets?region=eu-west-1). If the secret does exist, use this secret instead of duplicating it.

If the secret does not already exist, you need to create it. To create a secret, you must:

- [have access to AWS](https://docs.publishing.service.gov.uk/manual/get-started.html#8-get-aws-access)
- create the secret in [AWS Secrets Manager](https://docs.aws.amazon.com/secretsmanager/)
- define an [`ExternalSecret`](https://external-secrets.io/latest/api-externalsecret/) in Kubernetes
- use the resulting Kubernetes secret inside the app

The Kubernetes `ExternalSecret` defines the mapping between the AWS Secrets Manager secret and the Kubernetes secret inside your app.

The Kubernetes secret itself is the sensitive information that this process stores, manages and retrieves.

## Creating the secret in AWS Secrets Manager

You can create 2 types of secret in AWS Secrets Manager:

- an [AWS managed database](https://docs.aws.amazon.com/secretsmanager/latest/userguide/reference_secret_json_structure.html) secret
- a non-database secret

### Creating an AWS managed database secret

1. Open the [AWS Secrets Manager console](https://eu-west-1.console.aws.amazon.com/secretsmanager/listsecrets?region=eu-west-1). You will need to sign in if you have not already.

    You must create the secret in the 3 AWS accounts for integration, staging and production.

1. Select __Store a new secret__.

1. Select the appropriate secret type, for example __Credentials for Amazon RDS database__.

1. Enter the __Username__ and __Password__ for the database and select __Next__.

1. Select the database that you want to connect to and select __Next__.

1. Review the secret and then select __Store__.

1. Repeat this process for all 3 accounts.

### Creating a non-database secret

1. Open the [AWS Secrets Manager console](https://eu-west-1.console.aws.amazon.com/secretsmanager/listsecrets?region=eu-west-1). You will need to sign in if you have not already.

    You must create the secret in the 3 AWS accounts for integration, staging and production.

1. Select __Store a new secret__.

1. Select the __Other type of secret__ secret type, enter the secret __Key__ and __Value__, and then select __Next__.
    - __Key__ is a unique identifier for the secret
    - __Value__ is the secret you want to store

1. Enter the __Secret name__. You should also enter a __Description__.

    The description should describe what the secret is used for and where to get the secret value.

1. Add a __Tag__. Enter `added-manually` into the __Key__ field and `true` into the __Value__ field, and select __Next__.

1. Make sure __Automatic rotation__ is not enabled and select __Next__.

1. Review the secret and then select __Store__.

1. Repeat this process for all 3 accounts.

## Defining an `ExternalSecret` in Kubernetes

The Kubernetes `ExternalSecret` defines the mapping between the AWS Secrets Manager secret and the Kubernetes secret inside your app.

1. Go to the [`external-secrets` chart in the `govuk-helm-charts` repo](https://github.com/alphagov/govuk-helm-charts/tree/main/charts/external-secrets/templates/).

1. Select your app's folder, or create the folder if necessary.

1. Create a new `.yaml` file with a descriptive name.

    You should follow the same naming conventions as existing `.yaml` files:
    - use lowercase
    - put hyphens between words
    - do not include the app name

1. Define the `ExternalSecret`, using the following format:

    ```yaml
    apiVersion: external-secrets.io/v1beta1
    kind: ExternalSecret
    metadata:
      name: <APPNAME-SECRETNAME>
      labels:
        {{- include "external-secrets.labels" . | nindent 4 }}
      annotations:
        kubernetes.io/description: >
          <DESCRIPTION>
    spec:
      refreshInterval: {{ .Values.externalSecrets.refreshInterval }}
      secretStoreRef:
        name: aws-secretsmanager
        kind: ClusterSecretStore
      target:
        name: <APPNAME-SECRETNAME>
      dataFrom:
        - extract:
            key: govuk/<APPNAME>/<SECRETNAME>
    ```

    Where `<APPNAME>` is the name of the app and `<SECRETNAME>` is the name of the secret.

    Make sure the `<DESCRIPTION>` is consistent with the description you created in the AWS Secrets Manager. If the `ExternalSecret` uses `dataFrom.extract`, then the description should also document the fields expected in the YAML structure.

    For example, to create a secret for the Elections API for the [GOV.UK Frontend app](https://github.com/alphagov/govuk-frontend), use the following format:

    ```yaml
    apiVersion: external-secrets.io/v1beta1
    kind: ExternalSecret
    metadata:
      name: frontend-elections-api
      labels:
        {{- include "external-secrets.labels" . | nindent 4 }}
      annotations:
        kubernetes.io/description: >
          Credentials used by Frontend to access external Elections API service. Field names are "key" for the API key and "url" for the endpoint URL of the Elections API.
    spec:
      refreshInterval: {{ .Values.externalSecrets.refreshInterval }}
      secretStoreRef:
        name: aws-secretsmanager
        kind: ClusterSecretStore
      target:
        name: frontend-elections-api
      dataFrom:
        - extract:
            key: govuk/frontend/elections-api
    ```

1. Save the `.yaml` file and merge the change.

1. Check the Argo CD dashboard for the following environments to find out whether you successfully changed the `external-secrets` chart:
    - [integration](https://argo.eks.integration.govuk.digital/applications/external-secrets)
    - [staging](https://argo.eks.staging.govuk.digital/applications/external-secrets)
    - [production](https://argo.eks.production.govuk.digital/applications/external-secrets)

## Use the Kubernetes secret inside the app

You have:

- created the secret in AWS Secrets Manager
- defined the Kubernetes `ExternalSecret`, which maps the AWS Secrets Manager secret to the Kubernetes secret inside the app

Now you can use the Kubernetes secret inside the app referring to it in the app's Helm values.

1. Go to the [`app-config` chart](https://github.com/alphagov/govuk-helm-charts/tree/main/charts/app-config).

1. Select the `values-<ENVIRONMENT>.yaml` file that you want. For example, select the `values-integration.yaml` for the integration environment.

1. In this `.yaml` file, find the app that you are adding a secret to.

1. Add a `secretKeyRef` to the app's `extraEnv`. This depends on:
    - what type of secret you selected in the AWS Secrets Manager (managed database or non-database)
    - how you defined the mapping in the Kubernetes `ExternalSecret`

    For example, to define a non-database secret, you would use the following format or something similar:

    ```yaml
    - name: <ENV_VAR_NAME>
      valueFrom:
        secretKeyRef:
          name: <APPNAME-SECRETNAME>
          key: <KEY>
    ```

    The `<ENV_VAR_NAME>` is the name of the environment variable whose value you want to be set to the value from the secret.

    The `<APPNAME-SECRETNAME>` in this file must match the `<APPNAME-SECRETNAME>` in the `.yaml` template in the [`external-secrets` chart](https://github.com/alphagov/govuk-helm-charts/tree/main/charts/external-secrets/templates/).

    The `<KEY>` must match the __Key__ in the AWS Secrets Manager secret.

1. Save the `.yaml` file and merge the change.

    If you are not sure how to define the secret in the `.yaml` file, ask [Platform Engineering team](/contact-platform-engineering-team.html) and we'll help you.

## Supporting information

The GOV.UK Kubernetes platform uses the [External Secrets Operator](https://external-secrets.io/) to manage secrets.

The operator reads information from external APIs and automatically injects the information values into a Kubernetes secret.

For more information, see the:

- [External Secrets Operator documentation](https://external-secrets.io/)
- [External Secrets Operator GitHub repository](https://github.com/external-secrets/external-secrets)
