---
title: GOV.UK Kubernetes cluster documentation for developers
weight: 1
layout: multipage_layout
---

# GOV.UK Kubernetes cluster documentation for developers

Use this documentation to find out how to:

- start using the GOV.UK Kubernetes clusters
- manage your GOV.UK app on Kubernetes

## Introduction

The GOV.UK website and content management system (known internally as the publishing platform) are hosted on [Kubernetes](https://kubernetes.io/) clusters on Amazon Web Services (AWS), using [Elastic Kubernetes Service](https://aws.amazon.com/eks/) (EKS).

Kubernetes is a widely-used, open-source [container orchestration system](https://cloud.google.com/discover/what-is-container-orchestration) for managing containerised workloads such as GOV.UK's.

Kubernetes is designed for automation and emphasises [declarative configuration](https://github.com/kubernetes/design-proposals-archive/blob/main/architecture/declarative-application-management.md#declarative-configuration) and [immutable infrastructure](https://thenewstack.io/a-brief-look-at-immutable-infrastructure-and-why-it-is-such-a-quest/). It provides mechanisms for:

- efficiently and automatically fitting workloads into available compute resources
- resilient, "self-healing" deployments
- service discovery and load balancing
- automated rollouts and rollbacks
- quotas and isolation of compute resources between workloads
- authentication, authorisation and audit logging
- secrets and configuration management
- managing persistent storage

See the official [Kubernetes overview documentation](https://kubernetes.io/docs/concepts/overview/what-is-kubernetes/) for more information about Kubernetes.
