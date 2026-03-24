---
owner_slack: "#datagovuk-technical"
title: 'data.gov.uk: high traffic rate alert'
section: data.gov.uk
layout: manual_layout
parent: "/manual.html"
---

This alert fires when the origin request rate to data.gov.uk exceeds **44.6 req/s**
sustained for 5 minutes. This threshold is 80% of the peak capacity (55.8 req/s)
established by load testing with 100 virtual users on the staging environment
(March 2026).

## Understanding the alert

The alert expression is:

```promql
sum(rate(fastly_rt_origin_fetches_total{service_name=~".*data.gov.uk"}[5m])) > 44.6
```

This measures origin requests — requests that reached the data.gov.uk infrastructure
after the Fastly CDN. Cached responses (homepage, static assets) do not count.
A sustained rate above 44.6 req/s means the remaining 20% headroom before the
load-tested limit is being consumed and the site may be approaching saturation.

The load test baseline for reference:

| Metric | Value |
|---|---|
| Peak load tested | 100 virtual users |
| Peak throughput | 55.8 req/s |
| Error rate at peak | 0.00% |
| Find replicas (tested config) | 3 × 4Gi, RAILS_MAX_THREADS=16 |

## Impact

At this traffic level the site may still be healthy — the alert is early warning.
If traffic continues to grow towards 55+ req/s without scaling, you can expect:

- Find (Rails/Puma) pod latency to increase as Puma thread pools fill up
- Potential pod OOMKills if traffic generates large Ruby heap allocations
- 504 Gateway Timeout errors at the ALB if pods become unresponsive

## Checking the current state

### 1. Check Grafana

Open the [data.gov.uk app requests dashboard](https://grafana.eks.production.govuk.digital/d/app-requests/app3a-request-rates-errors-durations?orgId=1&refresh=1m&var-namespace=datagovuk&var-app=All&var-error_status=All)
and confirm:

- Is the request rate genuinely elevated, or is this a brief spike?
- Are error rates (4xx/5xx) increasing alongside the traffic?
- Is the rate still climbing, or has it plateaued?

### 2. Check pod health

```bash
gds aws govuk-production-dguengineer -- \
  kubectl get pods -n datagovuk -l app=datagovuk-find
```

Look for pods in `CrashLoopBackOff`, `OOMKilled` (Exit Code 137), or showing a high
restart count. If pods are already crashing, scale up immediately before investigating
further.

### 3. Check current replica count

```bash
gds aws govuk-production-dguengineer -- \
  kubectl get deployment -n datagovuk datagovuk-find \
  -o jsonpath='{.spec.replicas}'
```

Normal baseline: Find = 3 replicas.

## Scaling up to handle +10 req/s

The primary scaling lever is **Find replica count**. Adding one replica distributes
load across an additional Puma instance, adding roughly 18 req/s of headroom.

### Step 1: Increase Find replicas (3 → 4)

Edit `charts/app-of-apps/values-production.yaml` in the `govuk-dgu-charts` repository:

```yaml
datagovukHelmValues:
  find:
    replicaCount: 4   # increased from 3
```

Create a PR, get it reviewed, and merge to main. ArgoCD will automatically roll
out the change within a few minutes.

### Step 2: Verify the rollout

```bash
gds aws govuk-production-dguengineer -- \
  kubectl rollout status deployment/datagovuk-find -n datagovuk
```

Once rollout is complete, monitor the Grafana dashboard for 10–15 minutes to
confirm:

- Request rate is being handled without increasing error rates
- No new pod restarts or OOMKills
- p(95) response time for Find endpoints remains healthy

### Additional option: increase Puma thread count

If pod health issues appear (liveness probe failures, Puma thread pool exhaustion)
rather than raw pod count being the constraint, also set:

```yaml
datagovukHelmValues:
  find:
    config:
      railsMaxThreads: "16"   # default is 5
```

This was required during load testing at 100 VUs. Include it alongside the replica
increase if you are seeing probe failures under load. Note: higher thread counts
increase per-pod memory usage — verify pods stay within the 4Gi limit after deploying.

## Scaling back to normal

Once the `DataGovUkHighTrafficRate` alert has resolved and traffic has returned to
normal levels (below 44.6 req/s for at least 30 minutes), revert to baseline sizing
to release cluster resources.

Revert `charts/app-of-apps/values-production.yaml` to the baseline:

```yaml
datagovukHelmValues:
  find:
    replicaCount: 3   # back to baseline
    # remove railsMaxThreads if it was added
```

Create a PR with the description "Revert data.gov.uk scaling after high traffic
alert resolved", merge to main, and verify the rollout completes without errors.

Check that the alert does not re-fire within 15 minutes of scaling back.

## Baseline production configuration (for reference)

| Component | Setting | Baseline value |
|---|---|---|
| Find replicas | `find.replicaCount` | 3 |
| Find memory limit | `find.appResources.limits.memory` | 4Gi |
| Find memory request | `find.appResources.requests.memory` | 2Gi |

These values are defined in
`charts/app-of-apps/values-production.yaml` in the `govuk-dgu-charts` repository.
