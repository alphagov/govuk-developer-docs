---
title: Set security restrictions for your app
weight: 47
layout: multipage_layout
---

# Set security restrictions for your app

Our current workloads in our Kubernetes clusters conform to the [restricted profile](https://kubernetes.io/docs/concepts/security/pod-security-standards/#restricted) of pod security standards (PSS).
A pod that fails to meet this criteria will error on creation:

```
Warning: would violate PodSecurity "restricted:latest":
allowPrivilegeEscalation != false (container "nginx" must set securityContext.allowPrivilegeEscalation=false),
unrestricted capabilities (container "nginx" must set securityContext.capabilities.drop=["ALL"]),
runAsNonRoot != true (pod or container "nginx" must set securityContext.runAsNonRoot=true),
seccompProfile (pod or container "nginx" must set securityContext.seccompProfile.type to "RuntimeDefault" or "Localhost")
deployment.apps/nginx created
```

To fix this add the appropriate key-value pairs.

The [generic-govuk-app](https://github.com/alphagov/govuk-helm-charts/blob/main/charts/generic-govuk-app/templates/deployment.yaml) is an example of a deployment that conforms to the restricted profile of PSS.
