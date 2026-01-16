---
title: Autoscaling with HPA
weight: 45
layout: multipage_layout
---

# Autoscaling with Horizontal Pod Autoscalers (HPA)

The GOV.UK platforms support **automatic** scaling via Kubernetes Horizontal Pod
Autoscalers. HPAs adjust the replica count of a Deployment (or StatefulSet) in
response to live metrics such as CPU utilisation or queue length, keeping your
service responsive without over-provisioning.

---

## 1. How HPA works on GOV.UK

| Metric type        | Source component                 | API group exposed to HPA              |
|--------------------|----------------------------------|---------------------------------------|
| **CPU / memory**   | `metrics-server`                 | `metrics.k8s.io` *(built-in)*         |
| **Custom**         | `prometheus-adapter`             | `external.metrics.k8s.io`             |

* The adapter is already deployed in **integration** and will soon be promoted to staging and production (ADR [#13](https://github.com/alphagov/govuk-infrastructure/blob/main/docs/architecture/decisions/0013-expose-external-metrics-for-hpa.md)).  
* A minimal rule set exposes the Sidekiq backlog metric as `ai_sidekiq_queue_backlog`.

---

## 2. When to use HPA

| Use HPA when …                           | Do **not** use HPA when …                |
|-----------------------------------------|------------------------------------------|
| traffic or work volume is bursty         | load is stable and predictable           |
| latency or queue size must stay low      | replica count regulated externally (e.g. cron jobs) |
| metric is available in Prometheus        | the metric is absent or too noisy        |

---

## 3. Prerequisites

1. **Your app runs as a Deployment** (most GOV.UK apps do).  
2. The metric you need is exposed in Prometheus **with a `namespace` label**.  
   *If the metric is missing, talk to Platform Engineering about adding a scrape job or
   a new adapter rule.*

---

## 4. Creating an HPA

Add a Kubernetes manifest under your app’s chart (for example
`charts/<app-name>/templates/hpa.yaml`).  You can parameterise the values via
Helm if you prefer, but a static YAML is fine.

### 4.1 CPU-based HPA (built-in metric)

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: {{ include "<app>.fullname" . }}      # helm helper
  namespace: apps
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: {{ include "<app>.name" . }}
  minReplicas: 3
  maxReplicas: 10
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization   # %
          averageUtilization: 70
````

### 4.2 Sidekiq backlog HPA (external metric)

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: govuk-chat-worker-hpa
  namespace: apps
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: govuk-chat-worker
  minReplicas: 2
  maxReplicas: 20
  metrics:
    - type: External
      external:
        metric:
          name: ai_sidekiq_queue_backlog     # exposed by the adapter
        target:
          type: AverageValue
          averageValue: 5                    # desired backlog per pod
```

*Tips*

* Start conservatively (e.g. `maxReplicas` ≤ double current replicas).
* Use `AverageValue` for queue length; `Utilization` for percentages.
* In integration you can experiment freely; staging/production require a
  change PR and Platform Eng review.

---

## 5. Deploy and verify

```bash
kubectl describe hpa -n apps govuk-chat-worker-hpa
watch kubectl get hpa -n apps
```

You should see `CURRENT / TARGET` values and the replica count changing when
load is applied.

*If the HPA status says “failed to get metric”*:

1. Confirm the metric appears:
   `kubectl get --raw /apis/external.metrics.k8s.io/v1beta1 | jq .`
2. Check the adapter logs in `monitoring` namespace for parsing errors.

---

## 6. Best practice

* Keep `minReplicas` ≥ 3 in production (one per AZ).
* Always cap growth (`maxReplicas`) to protect downstream services.
* Document any new external metric rule in your app’s README.
* Add alerting if autoscaling is critical to SLOs (e.g. backlog stays high for

  > 5 minutes).

---

## 7. Further reading

* Kubernetes docs: [Horizontal Pod Autoscaler](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/)
* ADR #42 – decision to adopt Prometheus Adapter
* Existing *Scale your app* page for manual replica/resource changes
