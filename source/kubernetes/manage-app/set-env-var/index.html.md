---
title: Set environment variables for your app
weight: 43
layout: multipage_layout
---

# Set or change an environment variable for your app

## Update an ordinary (non-secret) environment variable

To update the value of an ordinary environment variable, raise a PR to change the value.

### Per-app environment variables

Per-app environment variables are defined using Helm values for each environment:

- [values-integration.yaml](https://github.com/alphagov/govuk-helm-charts/blob/main/charts/app-config/values-integration.yaml)
- [values-staging.yaml](https://github.com/alphagov/govuk-helm-charts/blob/main/charts/app-config/values-staging.yaml)
- [values-production.yaml](https://github.com/alphagov/govuk-helm-charts/blob/main/charts/app-config/values-production.yaml)

Changes to Helm values will be rolled out automatically by Argo CD within a few minutes of merging the PR.

### Global environment variables

Global environment variables are defined in a [ConfigMap Helm template](https://github.com/alphagov/govuk-helm-charts/blob/main/charts/app-config/templates/env-configmap.yaml). These environment variables are set for all GOV.UK apps, [for example in their Deployment manifests](https://github.com/alphagov/govuk-helm-charts/blob/604440c/charts/generic-govuk-app/templates/deployment.yaml#L72-L74).

Changes to the ConfigMap require a rollout (rolling restart) of the affected apps in order to take effect. To do this for one or more specific apps:

```sh
k rollout restart deploy/foo-app deploy/bar-app ...
```

Or for all apps:

```sh
k rollout restart deploy
```

You can watch the progress of the rollout(s) using the Argo CD web UI or using `kubectl`:

```sh
k rollout status deploy
```

## Update an environment variable from a Secrets Manager secret

An environment variable can take its value from an AWS Secrets Manager secret.

The flow of information is: Secrets Manager secret -> [External Secrets Operator](https://external-secrets.io/) (configured by an ExternalSecret k8s object) -> Kubernetes `Secret` object (created/updated by External Secrets Operator) -> `valueFrom` reference on the app's `Pod` spec.

To create a new secret, see [Add secrets to your app](/manage-app/manage-secrets/).

For now, apps are not automatically restarted when external (that is, Secrets Manager) secrets change.

To update an existing secret:

1. Edit the JSON value of the secret in [Secrets Manager](https://eu-west-1.console.aws.amazon.com/secretsmanager/listsecrets?region=eu-west-1). You can also do this [via the `aws` command line tool](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/secretsmanager/put-secret-value.html#examples).

2. Delete the corresponding Kubernetes secret in order to force an update. You can do this via the Argo CD web UI or via `kubectl`. If you prefer, you can wait for External Secrets Operator to pull the new value automatically. It polls once per hour, independently per secret.

    ```sh
    k delete secret foo-app-api-key
    ```

3. Do a rolling restart of the affected app:

    ```sh
    k rollout restart deploy/foo-app
    k rollout status !$
    ```

    You can also use the Argo CD web UI to see the progress of the rollout and the health of the app's pods.
