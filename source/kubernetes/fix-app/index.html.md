---
title: Fix your app
weight: 51
layout: multipage_layout
---

# Fix your app

Generally, the reasons why an app has functional or performance issues belong to the following categories:

- the app's configuration is wrong
- the app does not have enough resources allocated
- the app does not have access to required AWS services
- the GOV.UK Kubernetes cluster is not working properly

The following content summarises how to find issues in each of these categories.

## Fixing an app's configuration

Almost all GOV.UK apps are configured through environment variables. These environment variables are:

- stored either as plain text or in a [Kubernetes secret](https://kubernetes.io/docs/concepts/configuration/secret/)
- located in the `values-<ENVIRONMENT>.yaml` file or the `templates/env-configmap.yaml` template in the [`govuk-helm-charts` repo](https://github.com/alphagov/govuk-helm-charts)

For example, the [`values-integration.yaml` file](https://github.com/alphagov/govuk-helm-charts/blob/main/charts/app-config/values-integration.yaml) contains the environment variables for the integration environment.

To check you have set up your app's environment variables correctly, run the following in the command line:

```sh
kubectl -n apps exec deploy/<APPNAME> -c app -- env
```

To change a plain text environment variable, edit the value in the `values-<ENVIRONMENT>.yaml` file.

To change a Kubernetes secret, see the [Add secrets to your app documentation](/manage-app/manage-secrets).

When you change a Kubernetes secret, run the following in the command line to restart your app so that the change takes effect:

```sh
kubectl -n apps rollout restart deploy/<APPNAME>
```

## Allocating more resources to an app

An app might become unresponsive if its CPU usage far exceeds its limit. An app's container or pod can crash or be evicted if it exceeds its memory limit.

To check why a container or pod has crashed, run `describe pods` in the command line:

```sh
kubectl -n apps describe pods -l=app=<APPNAME>
```

If the pod or container crashes because of a lack of resources, you should [scale your app's resources](/manage-app/scale-app/).

You can monitor the pod resource usage of an app in the `General/Kubernetes/Compute Resources/Pod` Grafana dashboard for the appropriate environment.

For example, you can monitor the [Grafana dashboard for the GOV.UK integration environment](https://grafana.eks.integration.govuk.digital/).

For more information on Grafana, see the [Grafana developer documentation](https://docs.publishing.service.gov.uk/manual/grafana.html).

## Giving an app access to required AWS services

Some apps need access to other AWS services to work, but those AWS services are protected at a network level by [security groups](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html).

To fix this issue, you must make sure the security groups of these services are open to the [Kubernetes worker nodes](https://kubernetes.io/docs/concepts/architecture/nodes/) where the app is running.

To open the security groups to the worker nodes, make terraform changes to the [`security.tf` file in the `govuk-infrastructure` repo](https://github.com/alphagov/govuk-infrastructure/blob/main/terraform/deployments/govuk-publishing-infrastructure/security.tf).

Use this [example pull request in the `govuk-infrastructure` repo](https://github.com/alphagov/govuk-infrastructure/pull/584/files) as a guide to making the necessary changes.

Once you have made these changes, apply them by [deploying the `cluster-infrastructure` module](/manage-app/create-new-env/#2-deploy-the-cluster-infrastructure-module).

## If you suspect a problem with the cluster itself

An app may face issues if the cluster has a problem. Possible issues you might encounter include:

- insufficient capacity in the cluster to schedule the required number of replicas of the apps, for example if a "stockout" in EC2 is preventing cluster-autoscaler from starting new nodes
- a configuration problem with the cluster due to some recent change
- a problem with a controller which might prevent an app's actual configuration from converging with its specified configuration

If you suspect a problem with the cluster, [contact Platform Engineering team](/contact-platform-engineering-team.html) to ask for help.

## General debugging

### Getting logs for your apps

To get logs for your apps, follow the [viewing app logs documentation](/manage-app/get-app-info/#view-app-logs).

### Creating a shell inside a running container

If you cannot diagnose an issue by looking at the app logs, you can create a shell to run commands inside a running app container.

Run the following in the command line:

```
kubectl -n <NAMESPACE> exec -it <POD> sh -c <CONTAINER>
```

If you do not specify the container, the command creates a shell inside the first container in the app manifest.

For more information, see the [Kubernetes documentation on getting a shell to a running container](https://kubernetes.io/docs/tasks/debug-application-cluster/get-shell-running-container/).

### Port-forwarding to a pod

You can make a port available on your local machine to send commands directly to the app.

This command works on a pod level rather than a container level, as everything in a pod has the same IP address.

For example, to forward port `5000` on `localhost` to port `5001` in a pod, run:

```
kubectl -n <namespace> port-forward <pod> 5000:5001
```

You can find the pod port in the app configuration.

### Following a troubleshooting guide

To help diagnose issues, follow this [visual guide on troubleshooting Kubernetes deployments](https://learnk8s.io/troubleshooting-deployments).
