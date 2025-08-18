---
title: Control App healthchecks and kubernetes probes
weight: 49
layout: multipage_layout
---

# Healthchecks

Kubernetes will run various probes against your app to decide:

1. Whether the app has started
2. Whether the app should be served traffic
3. Whether your app should be restarted (by terminating the pod, and starting
   it again)

By default all of these checks are run against the `/healthcheck/live`
endpoint.

You can control which endpoints kubernetes will hit for each check.

See the section [Kubernetes Probes](#kubernetes-probes) later on this page for
a description of how the probes work, and how they will affect your app.

## Choosing a different healthcheck endpoint

If you wish to use a different endpoint for any of the types of [Kubernetes
Probes](#kubernetes-probes) you can do so as follows:

In [the app-config Helm chart in
govuk-helm-charts](https://github.com/alphagov/govuk-helm-charts/tree/main/charts/app-config),
in `values-<environment>.yaml` you can add the configuration key
`kubernetesProbeEndpoints` into the helmValues of your applications
configuration:

```
kubernetesProbeEndpoints:
    startupProbe: "/healthcheck/ready"
    livenessProbe: "/healthcheck/live"
    readinessProbe: "/healthcheck/foo"
```

You do not need to add all 3 and could override just one. For example in [pull
request #3406](https://github.com/alphagov/govuk-helm-charts/pull/3406/) the
configuration for static, and draft-static, was updated in integrtion so that
the configuration of them looked as follows and used `/healthcheck/ready` as a
startupProbe only (leaving the liveness and readiness probes as the default
`/healthcheck/live`:

```
  - name: static
    helmValues:
      arch: arm64
      appResources:
        ...SNIP...
      ingress:
        ...SNIP...
      kubernetesProbeEndpoints:
        startupProbe: "/healthcheck/ready"
```

## Kubernernetes Probes

When kubernetes executes a Pod, it will perform 3 types of [Kubernetes
Probes](https://kubernetes.io/docs/concepts/configuration/liveness-readiness-startup-probes/#startup-probe).

### Startup Probe

As soon as the pod launches kubernetes will start querying the startup probe.

It will continue querying this probe until the probe passes, or all retries
have been exhausted.

If the probe passes kubernetes will consider the pod to have started up and
will not run any more startup probes, it will then start running both liveness
and readiness provbes.

If the startup probe continues to fail past all configured retries then the pod
will be terminated. If the pod is part of a deployment/replica set/stateful
set/daemmon set then a new one will be started and the whole process will begin
again.

### Readiness Probe

Once the startup probe has completed kubernetes will being to run readiness
probes, it will do this forever until the pod is terminated.

If the readiness probe is passing then kubernetes will consider the pod able to
accept traffic and will serve traffic to it.

If the readiness probe is failing then kuberentes will no longer serve traffic
to it.

There is one exception to this, since we use EKS with AWS Application Load
Balancers, if all pods within a service are not ready, then traffic will be
served round robin to all the unhealthy pods.

### Liveness Probe

Once the startup probe has completed kubernetes will being to run liveness
probes, it will do this forever until the pod is terminated.

If the liveness probe is passing then kubernetes will do nothing further.

If the liveness probe is failing, after retries are exhausted kubernetes will
terminate the pod. If the pod is part of a deployment/replica set/stateful
set/daemmon set then a new one will be started and the whole process will begin
again.

### Probe lifecycle

<details><summary>Mermaidjs diagram source</summary>

SVG generated with mermaid cli:

<code>npx --package=@mermaid-js/mermaid-cli --  mmdc -i mermaid.yaml -o kubernetes-pod-lifecycle.svg -w 760</code>

<pre>
<code>
stateDiagram-v2
  podStarted : Pod Started
  startupResponse: HTTP Response Code
  startupRetryCount: Number of retries
  startupPassed: Startup Probe Passed
  startupFailed: Startup Probe Failed
  livenessResponse: HTTP Response Code
  livenessRetryCount: Number of retries
  livenessPassed: Liveness Probe Passed
  livenessFailed: Liveness Probe Failed
  readinessResponse: HTTP Response Code
  readinessRetryCount: Number of Retries
  readinessPassed: Readiness Probe Passed
  readinessFailed: Readiness Probe Failed
  notReady: Stop serving traffic
  ready: Serve traffic
  terminatePod: Terminate Pod

  [*] --> podStarted

  podStarted --> startupProbe

  state Startup {
    state startupProbeResult <<choice>>

    startupProbe --> startupResponse

    startupResponse --> startupProbeResult
    startupProbeResult --> startupPassed: 200-399
    startupProbeResult --> startupFailed: 400+

    state startupProbeRetries <<choice>>

    startupFailed --> startupRetryCount

    startupRetryCount --> startupProbeRetries
    startupProbeRetries --> startupProbe: retries < failureThreshold
  }

  startupPassed --> livenessProbe
  startupPassed --> readinessProbe

  state Liveness {
    state livenessProbeResult <<choice>>

    livenessProbe --> livenessResponse

    livenessResponse --> livenessProbeResult
    livenessProbeResult --> livenessPassed: 200-399
    livenessProbeResult --> livenessFailed: 400+

    livenessPassed --> livenessProbe

    state livenessProbeRetries <<choice>>

    livenessFailed --> livenessRetryCount
    livenessRetryCount --> livenessProbeRetries
    livenessProbeRetries --> livenessProbe: retries < failureThreshold
  }

  state Readiness {
    state readinessProbeResult <<choice>>

    readinessProbe --> readinessResponse

    readinessResponse --> readinessProbeResult
    readinessProbeResult --> readinessPassed: 200-399
    readinessProbeResult --> readinessFailed: 400+

    state readinessProbeRetries <<choice>>

    readinessFailed --> readinessRetryCount

    readinessRetryCount --> readinessProbeRetries
    readinessProbeRetries --> notReady: retries >= failureThreshold
    readinessProbeRetries --> readinessProbe: retries < failureThreshold
    notReady --> readinessProbe

    readinessPassed --> ready
    ready --> readinessProbe
  }

  startupProbeRetries --> terminatePod: retries >= failureThreshold
  livenessProbeRetries --> terminatePod: retries >= failureThreshold

  terminatePod --> [*]
</code>
</pre>
</details>

![Kubernetes Pod Lifecycle as described above](/images/kubernetes-pod-lifecycle.svg)

</pre>
