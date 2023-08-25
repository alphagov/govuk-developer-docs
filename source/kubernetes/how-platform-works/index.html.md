---
title: How the platform works
weight: 60
layout: multipage_layout
---

# How the platform works

The GOV.UK Kubernetes platform is an AWS-hosted [Kubernetes](https://kubernetes.io) cluster, using Amazon's [Elastic Kubernetes Service](https://aws.amazon.com/eks/) (EKS).

For information on how Kubernetes works in general, see the:

- [Kubernetes documentation](https://kubernetes.io/docs/home/)
- [Amazon EKS documentation](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html)
- Linux foundation’s free [introduction to Kubernetes training certification](https://training.linuxfoundation.org/training/introduction-to-kubernetes/)

Specific to its implementation of Kubernetes, the GOV.UK Kubernetes platform cluster:

- uses add-ons to manage storage and secrets
- authenticates platform cluster users using an `aws-auth` ConfigMap

## Platform cluster add-ons

The GOV.UK Kubernetes platform cluster uses the following add-ons in its implementation of Kubernetes:

- External secrets
- ExternalDNS
- AWS load balancer controller
- Cluster autoscaler
- Dex OpenID connect provider
- AWS EBS CSI driver

### External secrets

The [External-secrets add-on](https://github.com/alphagov/govuk-infrastructure/blob/main/terraform/deployments/cluster-services/external_secrets.tf):

- retrieves secrets from [AWS Secrets Manager](https://aws.amazon.com/secrets-manager/)
- makes those secrets available to GOV.UK applications as standard [Kubernetes Secret objects](https://kubernetes.io/docs/concepts/configuration/secret/)

For more information, see the [External secrets documentation](https://external-secrets.io/).

### ExternalDNS

The [ExternalDNS add-on](https://github.com/alphagov/govuk-infrastructure/blob/main/terraform/deployments/cluster-services/external_dns.tf) creates and manages [Domain Name System (DNS)](https://aws.amazon.com/route53/what-is-dns/) records in [AWS Route 53](https://aws.amazon.com/route53/) for [exposed (publicly discoverable) Kubernetes services](https://kubernetes.io/docs/tutorials/kubernetes-basics/expose/expose-intro/) in [AWS Route 53](https://aws.amazon.com/route53/).

For more information, see the [External DNS documentation](https://github.com/kubernetes-sigs/external-dns).

### AWS load balancer controller

The [AWS load balancer controller add-on](https://github.com/alphagov/govuk-infrastructure/blob/main/terraform/deployments/cluster-services/aws_lb_controller.tf) creates and manages [AWS load balancers](https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/introduction.html), based on [Kubernetes Ingress objects](https://kubernetes.io/docs/concepts/services-networking/ingress/) in the cluster.

For more information, see the [AWS load balancer controller documentation](https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html).

### Cluster autoscaler

The [Cluster autoscaler add-on](https://github.com/alphagov/govuk-infrastructure/blob/main/terraform/deployments/cluster-services/cluster_autoscaler.tf) automatically adjusts the size of the Kubernetes cluster by:

- adding [worker nodes](https://kubernetes.io/docs/concepts/architecture/nodes/) to the cluster when the cluster is running low on capacity, so that Kubernetes can [schedule](https://kubernetes.io/docs/concepts/scheduling-eviction/kube-scheduler/) all of the requested pods.
- removing worker nodes when the cluster has spare capacity

The add-on adjusts cluster size by controlling the [AWS EC2 auto scaling group](https://docs.aws.amazon.com/autoscaling/ec2/userguide/AutoScalingGroup.html) for the [managed node group](https://docs.aws.amazon.com/eks/latest/userguide/managed-node-groups.html).

For more information, see the [Cluster autoscaler documentation](https://github.com/kubernetes/autoscaler/tree/master/cluster-autoscaler).

### Dex OpenID connect provider

The [Dex OpenID connect provider](https://github.com/alphagov/govuk-infrastructure/blob/main/terraform/deployments/cluster-services/dex.tf) is a [federated identity provider](https://en.wikipedia.org/wiki/Federated_identity).

The GOV.UK Kubernetes platform cluster uses Dex to manage single sign-on to services in the cluster, for example, [Grafana dashboards](https://docs.publishing.service.gov.uk/manual/grafana.html) and [Argo CD](/get-started/access-eks-cluster/#access-eks-cluster).

Dex acts as an intermediary between apps that are restricted to authorised users, and apps that know how to verify a user's identity.

For more information, see the [Dex OpenID connect provider documentation](https://dexidp.io/docs/).

### AWS EBS CSI Driver

The [AWS Elastic Block Store (EBS) Container Storage Interface (CSI) driver](https://github.com/alphagov/govuk-infrastructure/blob/main/terraform/deployments/cluster-services/aws_ebs_csi_driver.tf) allows Amazon EKS clusters to manage the lifecycle of Amazon EBS volumes for persistent volumes.

For more information, see the [Amazon EBS CSI driver documentation](https://docs.aws.amazon.com/eks/latest/userguide/ebs-csi.html).

## Platform cluster user authentication

To authenticate users, the GOV.UK Kubernetes platform cluster uses an [`aws-auth` ConfigMap](https://github.com/alphagov/govuk-infrastructure/blob/main/terraform/deployments/cluster-services/aws_auth_configmap.tf) in the `kube-system` [namespace](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/).

The ConfigMap maps a user's AWS Identity Access Management (IAM) role to the equivalent role in the [Kubernetes role-based access control system](https://kubernetes.io/docs/reference/access-authn-authz/rbac/).

The list of authenticated users for the platform’s different environments is located in the [`govuk-aws-data/data/infra-security/` GitHub repo on alphagov](https://github.com/alphagov/govuk-aws-data/tree/master/data/infra-security).

To make changes to this list, you must be in the [GOV.UK team on alphagov](https://github.com/orgs/alphagov/teams/gov-uk).

For more information, see the [AWS documentation on enabling IAM user and role access to your cluster](https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html).
