---
title: Scale your app
weight: 44
layout: multipage_layout
---

# Scale your app

If user demand on your app increases, you must increase the resources available to your app. This is also known as scaling your app.

## Scaling your app

1. Determine if you need to update your app's `values.yaml` or enviroment yaml file, for example - [`values-integration.yaml`](https://github.com/alphagov/govuk-helm-charts/blob/main/charts/app-config/values-integration.yaml)
2. Change your app's configuration by [following the guidance](#what-you-can-scale) below
3. Commit this change

When you merge the pull request, the changed configuration file will be [automatically synced by the Argo CD tool](/manage-app/access-ci-cd/#deploying-a-release-of-a-gov-uk-app).

You should be aware of:

- how your app interacts with other apps
- what effect scaling your app would have on the other apps

For example, if you increase your frontend app's number of instances or pods, you may also need to increase the number of instances of any backend apps that support your frontend.

## What you can scale

You can scale your app vertically or horizontally.

### Vertically scaling your app

You should have at least 3 replicas of each pod type of your app running in the GOV.UK production or staging environments.

This means greater reliability because the 3 replicas would cover the 3 AWS availability zones.

To vertically scale your app, change the following replicas:

- `replicaCount`, the number of running instances or pods of your app
- `workerReplicaCount`, the number of worker instances that, if enabled, run alongside your app within the pod (optional as it does not apply to all apps)

### Horizontally scaling your app

You can horizontally scale your app by changing the request and limit value for the following resources:

- number of virtual CPU cores
- amount of virtual memory
- size of memory pages for Linux workloads

For more information on these resources, see the [Kubernetes documentation on pod and container resource management requests and limits](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#requests-and-limits).

You can scale these resources for the following resource categories:

- `appResources`, the resources that your app uses
- `workerResources`, if enabled, the resources your worker nodes use
- `jobResources`, if enabled, the resources your jobs use to upload assets
- `nginxResources`, the resources the NGINX proxy uses

Most of the time, you should only need to scale the `appResources` and `workerResources` (if enabled). However, you may sometimes need to scale the other resources as well.

## How scaling your app affects platform resources

The cluster will automatically scale up in response to demand from application workloads, subject to some overall limits.

Very large increases to resource requests or replica counts could run into those limits or have other implications.

[GOV.UK Platform Engineering team](/contact-platform-engineering-team.html) can help advise you on how best to meet your scalability needs. Please don't hesitate to get it touch if you're at all unsure.
