---
title: Get information about your app
weight: 40.5
layout: multipage_layout
---

# Get information about your app

You can get information about your app, your app deployment, and the pods and containers in your app.

Most of the following examples use the Kubernetes command-line tool, `kubectl`.

## Choose and set a namespace

All the GOV.UK applications are in the `apps` namespace. You can avoid having to specify this (`-n apps`) in every `kubectl` command by setting `apps` as your default namespace:

`kubectl config set-context --current --namespace=apps`

## Get a list of all deployed apps in a namespace

To get a list of all deployed apps, run:

```sh
kubectl -n apps get deployments
```

## Describe an app deployment

To describe an app deployment, run:

```sh
kubectl -n <namespace> describe deployment <deployment>
```

The output includes information like the pod template, the containers, and the environment variables.

## List all pods in an app

To list all pods running in an app, run:

```sh
kubectl -n <namespace> get pods
```

## Describe a pod

To describe a pod in an app, run:

```sh
kubectl -n <namespace> describe pod <pod>
```

The output includes information on everything that Kubernetes uses to run the pod, for example:

- pod image
- pod host
- resource limits
- readiness checks
- environment variables

## View app logs

To view the logs of all running containers in a specific pod, run:

```sh
kubectl -n <namespace> logs <pod>
```

To view the logs of a specific container for a pod, run:

```sh
kubectl -n <namespace> logs <pod> -c <container>
```

To view the logs for all containers in a given app deployment, run:

```sh
kubectl logs -n apps deploy/<deployment> <container>
```

You can also view logs in [Logit](https://logit.io/).

1. Access Logit by following the [Reliability Engineering documentation on getting started with Logit](https://reliability-engineering.cloudapps.digital/logging.html#get-started-with-logit).
1. In the Logit dashboard, find the EKS stack you want to view the logs for. For example __GOV.UK INTEGRATION EKS__.
1. Select __LAUNCH KIBANA__ in the appropriate EKS stack.

You can filter the logs in Logit by app, pod, container and other parameters.

## View Kubernetes events

An event is any action that Kubernetes takes. For example, starting a container in a pod.

Viewing Kubernetes events is helpful for debugging an app.

To see Kubernetes events for a namespace, run:

```sh
kubectl -n <namespace> get events
```

To get events for a specific Kubernetes resource, run:

```sh
kubectl -n apps get events --field-selector=involvedObject.name=<resource>
```

For example, to get events for the pod `publisher-7795bd698-v6bfc`, run:

```sh
kubectl -n apps get events --field-selector=involvedObject.name=publisher-7795bd698-v6bfc
```

## Further information

For more information on `kubectl`, see the [Kubernetes kubectl documentation](https://kubernetes.io/docs/reference/kubectl/).

For more information on Logit, see the [Reliability Engineering documentation on logging](https://reliability-engineering.cloudapps.digital/logging.html#logging).
