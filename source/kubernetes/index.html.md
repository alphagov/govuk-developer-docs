---
title: GOV.UK Internal Developer Platform
weight: 1
layout: multipage_layout
---

# GOV.UK Internal Developer Platform

The GOV.UK Internal Developer Platform is a centralised platform where teams can build, deploy, and manage applications in a reliable and secure environment.

This documentation is for both platform users and internal team members. It provides guides, tools, and best practices to help onboard, manage, and troubleshoot applications efficiently.

## Who this guide is for

This documentation is for:

- **Developers and engineers**: Deploying and managing applications on the platform.
- **Platform engineers and administrators**: Maintaining and extending the platform.

## User Guide

This section is for application developers using the platform. The platform reduces cognitive load by abstracting infrastructure complexity and providing tools, guides, and automated workflows.

If something is missing, let us know, and we’ll add an article. If you're comfortable contributing, pull requests (PRs) are welcome.

### Getting Started

- [Gain access to a platform EKS cluster](../../kubernetes/get-started/access-eks-cluster/index.html)
- [Set up the recommended tools](../../kubernetes/get-started/set-up-tools/index.html)
- [Understand how the platform works](../../kubernetes/how-platform-works/index.html)

### Tutorials

- [Create a new application](../../kubernetes/create-app/index.html)
- [Update an application's environment in Helm charts](../../kubernetes/get-started/tutorials/app-config-deploy-helm-chart/index.html)
- [Update, deploy, and monitor an application](../../kubernetes/get-started/tutorials/app-update-deploy-monitor-logs/index.html)
- [Set or change an environment variable](../../kubernetes/manage-app/set-env-var/index.html)
- [Add secrets to your application](../../kubernetes/manage-app/manage-secrets/index.html)
- [Horizontally and vertically scale your application](../../kubernetes/manage-app/scale-app/index.html)
- [Roll back applications](../../kubernetes/manage-app/roll-back-app/index.html)
- [Fix your application when something goes wrong](../../kubernetes/fix-app/index.html)
- [View your application and inspect Kubernetes using the command line](../../kubernetes/manage-app/get-app-info/index.html)
- [Troubleshoot failed deployments](../../kubernetes/manage-app/manage-state/index.html)

### Concepts

- [How we release a new version of your app](../../kubernetes/manage-app/release-new-version/index.html)
- [How applications are deployed](../../kubernetes/manage-app/access-ci-cd/index.html)

## Runbooks

This section is for **platform engineers and administrators**. It serves as a central place for capturing knowledge and documenting ways of working.

### Common tasks

- [Create new environments](../../kubernetes/manage-app/create-new-env/index.html)

## Cheatsheet

Quickly reference common commands and workflows in the [cheatsheet](../../kubernetes/cheatsheet.html).

## Contact the Platform Engineering Team

Need help? Visit [Contact the Platform Engineering Team](../../kubernetes/contact-platform-engineering-team.html) for support options.
