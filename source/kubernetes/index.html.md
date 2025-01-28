---
title: GOV.UK Internal Developer Platform
weight: 1
layout: multipage_layout
---

# GOV.UK Internal Developer Platform

The GOV.UK Internal Developer Platform is a centralised platform where teams can build, deploy, and manage applications in a reliable and secure environment.

This documentation is designed for both platform users and internal team members, providing guides, tools, and best practices to onboard, manage, and troubleshoot your applications effectively.

## Who is this for?

This documentation is for:

- Developers, engineers, and stakeholders deploying and managing applications on the platform.

- Platform engineers and administrators responsible for maintaining and extending the platform.

## User Guide

This section is specifically for application developers using the platform. The platform is designed to reduce cognitive load for developers by abstracting away infrastructure complexity and providing tools, guides, and automated workflows. 

If there’s something missing, please either let us know and we’ll add a new article, or if you’re comfortable writing one yourself, PRs will be gratefully received.

### Getting Started

- [Gain access to a platform EKS Cluster](../../kubernetes/get-started/access-eks-cluster/index.html)
- [Set up the recommended tools](../../kubernetes/get-started/set-up-tools/index.html)
- [Understand how the platform works](../../kubernetes/how-platform-works/index.html)

### Tutorials

- [Create a new application](../../kubernetes/create-app/index.html)
- [Update an application's environment in our Helm charts](../../kubernetes/get-started/tutorials/app-config-deploy-helm-chart/index.html)
- [Update, deploy, and monitor an application](../../kubernetes/get-started/tutorials/app-update-deploy-monitor-logs/index.html)
- [Set or change an environment variable in your application](../../kubernetes/manage-app/set-env-var/index.html)
- [Add secrets to your application](../../kubernetes/manage-app/manage-secrets/index.html)
- [Horizontally and vertically scale your application](../../kubernetes/manage-app/scale-app/index.html)
- [Rolling Back Applications](../../kubernetes/manage-app/roll-back-app/index.html)
- [Fix your application when something's gone wrong](../../kubernetes/fix-app/index.html)
- [View your application and inspect Kubernetes via the command-line](../../kubernetes/manage-app/get-app-info/index.html)
- [Troubleshoot your failed deployment](../../kubernetes/manage-app/manage-state/index.html)

### Concepts

- [How we release a new version of your app](../../kubernetes/manage-app/release-new-version/index.html)
- [How is your application deployed](../../kubernetes/manage-app/access-ci-cd/index.html)

## Runbooks

This section is specifically for platform engineers and administrators and should act as a place for knowledge capture and ways of working practices.

### Common tasks

- [Create New Environments](../../kubernetes/manage-app/create-new-env/index.html)

## Cheatsheet

Quickly reference common commands and workflows in the [Cheatsheet](../../kubernetes/cheatsheet.html).

## Contact the Platform Engineering Team

Need help? Visit [Contact the Platform Engineering Team](../../kubernetes/contact-platform-engineering-team.html) for support options.

