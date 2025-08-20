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

An event is any action that Kubernetes takes. For example, starting a pod, pulling an image, a pod crashing.

Viewing Kubernetes events is helpful for debugging an app.

### Via logit

Events are stored in Logit for 14 days in production, and 7 days in other environments. They are stored in an ElasticSearch index with the name prefix of `kubernetes-events-`.

In logit, when viewing Kibana, on the left side of the interface there is a dropdown box which defaults to `filebeat-*`, you should change this to `kubernetes-events-*`, alternatively you can use the links below:

- [Kubernetes Events in Logit for Production](https://kibana.logit.io/s/13d1a0b1-f54f-407b-a4e5-f53ba653fac3/app/data-explorer/discover#?_a=(discover:(columns:!(_source),isDirty:!f,sort:!()),metadata:(indexPattern:'918b7520-6d5c-11f0-a0c2-616481b44018',view:discover))&_g=(filters:!(),refreshInterval:(pause:!t,value:0),time:(from:now-15m,to:now))&_q=(filters:!(),query:(language:lucene,query:'')))
- [Kubernetes Events in Logit for Staging](https://kibana.logit.io/s/b8a10798-a30e-4611-9393-8843d2339dd2/app/data-explorer/discover#?_a=(discover:(columns:!(_source),isDirty:!f,sort:!()),metadata:(indexPattern:'192c7c50-6d5c-11f0-a036-ab90a4a466d2',view:discover))&_g=(filters:!(),refreshInterval:(pause:!t,value:0),time:(from:now-15m,to:now))&_q=(filters:!(),query:(language:lucene,query:'')))
- [Kubernetes Events in Logit for Integration](https://kibana.logit.io/s/42f4d2d5-e9ce-451f-8ffc-cdb25bd624f8/app/data-explorer/discover#?_a=(discover:(columns:!(_source),isDirty:!f,sort:!()),metadata:(indexPattern:fd31bca0-6d28-11f0-aee7-6b9a180d0701,view:discover))&_g=(filters:!(),refreshInterval:(pause:!t,value:0),time:(from:now-15m,to:now))&_q=(filters:!(),query:(language:lucene,query:'')))

Logit supports querying via either the Lucene syntax, or the DQL syntax, to the right of the search box it will show you which you are set to, all the following queries use DQL, to do them in lucene the syntax is `field = value` instead of `field: value`.

To see Kubernetes events for a namespace, search for:

```
involvedObject.namespace: "<namespace>"
```

To get events for a specific Kubernetes resource, search for:

```sh
involvedObject.name: "<resource>"
```

For example, to get events for the pod `publisher-7795bd698-v6bfc`, search for:

```sh
involvedObject.name: "publisher-7795bd698-v6bfc"
```

### Via kubectl (only the last 1 hour)

Logs are available via the cli for only 1 hour, if you wish to see logs older than this you should [view them
using Logit](#via-logit)

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

## View Out of Memory Events

Kubernetes will kill your pod if it consumes more memory than has been allocated to the pod.
You can view pods that have been killed by Kubernetes for running out of memory via the CloudWatch Logs Insights console.

1. Log in to the AWS console
1. Go to [CloudWatch Logs Insights](https://eu-west-1.console.aws.amazon.com/cloudwatch/home?region=eu-west-1#logsV2:logs-insights)
1. Select 'Saved and sample queries', then pick the 'Pods Killed (Out of Memory)' saved query

Querying CloudWatch Logs in this way can be expensive. Try to limit your queries to a day of logs at a time to keep costs down.

## Further information

For more information on `kubectl`, see the [Kubernetes kubectl documentation](https://kubernetes.io/docs/reference/kubectl/).

For more information on Logit, see the [Reliability Engineering documentation on logging](https://reliability-engineering.cloudapps.digital/logging.html#logging).
