---
owner_slack: "#govuk-developers"
title: How to disable or re-enable an app in EKS
layout: multipage_layout
---

## Pre-requisites

* An app configured in [govuk-helm-charts app-config chart](https://github.com/alphagov/govuk-helm-charts/tree/main/charts/app-config)
* Any [end to end tests](/repos/govuk-e2e-tests.html) configured for your app ***MUST*** be disabled first (by adding a `@not-<env>` tag to each test. See [an example pull request disabling govuk-chat e2e tests in production](https://github.com/alphagov/govuk-e2e-tests/pull/308), otherwise your app will block all other apps being deployed.

## Disabling an app

In the `values-<environment>.yaml` file in the app-config chart, for your app you can set `helmValues.appEnabled: false`, and to also disable the workers you can set
`helmValues.workers.enabled: false`

For example, if your app is `collections-publisher` you can alter your config as follows:

```
  govukApplications:
    - name: collections-publisher
      helmValues:
+       appEnabled: false
        arch: arm64
        appResources:
          limits:
            cpu: 1
            memory: 1Gi
          requests:
            cpu: 10m
            memory: 400Mi
        dbMigrationEnabled: true
        workers:
+         enabled: false
```

If the app has horizontal pod autoscaling configured you also need to disable each of the pod autoscaling rules you have set up.
Your app will have a `podAutoscaling` section in the `helmValues` section. You need to set `enabled: false` for each rule. For example:

```
   - name: collections-publisher
     helmValues:
       ...SNIP...
       podAutoscaling:
         - name: collections-publisher
+          enabled: false
           ...SNIP...
         - name: collections-publisher-worker
+          enabled: false
           ...SNIP...
```

When these changes are deployed by ArgoCD, the deployment and the workers will be deleted and your app will be offline, any pod autoscaling will be disabled.

## Re-enabling an app

Re-enabling the app is a simple reverse of disabling. You can either delete the `enabled` and `appEnabled` entries (which all default to `true`), or you can set them explicitly to true.

When these changes are deployed by ArgoCD, the deployment and the workers will be recreated and your app will be online again.
