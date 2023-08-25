---
title: Set up tools
weight: 21
layout: multipage_layout
---

# Set up tools to use the GOV.UK Kubernetes platform

You must set up the following tools to use the GOV.UK Kubernetes platform:

- kubectl
- Helm
- Argo CLI to manage Argo Workflows
- `gds-cli` and `aws-vault`

## Install kubectl

The [kubectl command line tool](https://kubernetes.io/docs/reference/kubectl/overview/) lets you control Kubernetes clusters.

You should use [Homebrew](https://brew.sh/) to install kubectl on your local machine. Run the following in the command line:

```sh
brew install kubectl
```

You can test that kubectl is working by running:

```sh
kubectl version --client
```

If kubectl is working, you should get some version number output, like in the following example:

```
Client Version: version.Info{Major:"1", Minor:"22", GitVersion:"v1.22.1", GitCommit:"632ed300f2c34f6d6d15ca4cef3d3c7073412212", GitTreeState:"clean", BuildDate:"2021-08-19T15:38:26Z", GoVersion:"go1.16.6", Compiler:"gc", Platform:"darwin/amd64"}
```

See the [kubectl installation documentation](https://kubernetes.io/docs/tasks/tools/install-kubectl-macos/) for information on other ways to install kubectl if you prefer not to use Homebrew, or for troubleshooting.

## Install Helm

[Helm](https://helm.sh/docs/) is the package manager for Kubernetes.

You should use [Homebrew](https://brew.sh/) to install Helm on your local machine. Run the following in the command line:

```sh
brew install helm
```

You can test that Helm is working by running:

```sh
helm version
```

If Helm is working, you should get some version number output, like in the following example:

```
version.BuildInfo{Version:"v3.8.0", GitCommit:"d14138609b01886f544b2025f5000351c9eb092e", GitTreeState:"clean", GoVersion:"go1.17.6"}
```

See the [Helm installation documentation](https://helm.sh/docs/intro/install/) for information on other ways to install Helm if you prefer not to use Homebrew, or for troubleshooting.

## Install Argo CLI

[Argo Workflows](https://argoproj.github.io/argo-workflows/) is the workflow engine for Kubernetes.

You use the Argo CLI to manage Argo Workflows. You should install Argo CLI using Homebrew. Run the following in the command line:

```sh
brew install argo
```

You can test that Argo CLI is working by running:

```sh
argo version
```

If Argo CLI is working, you should get some version number output, like in the following example:

```
argo: v3.2.8+8de5416.dirty
  BuildDate: 2022-02-05T05:15:13Z
  GitCommit: 8de5416ac6b8f5640a8603e374d99a18a04b5c8d
  GitTreeState: dirty
  GitTag: v3.2.8
  GoVersion: go1.17.6
  Compiler: gc
  Platform: darwin/amd64
```

See the [Argo Workflows release notes](https://github.com/argoproj/argo-workflows/releases) for information on other ways to install Argo CLI if you prefer not to use Homebrew, or for troubleshooting.

## Install `gds-cli` and `aws-vault`

`gds-cli` is a command line interface (CLI) for GDS users. This CLI makes certain tasks easier, such as assuming an AWS Identity Access Management (IAM) role.

`aws-vault` is a tool to securely store and access AWS credentials in a development environment.

### Install gds-cli

If you have [installed the GDS command line tools](https://docs.publishing.service.gov.uk/manual/get-started.html#3-install-gds-command-line-tools) as part of [getting started on GOV.UK](https://docs.publishing.service.gov.uk/manual/get-started.html), you do not need to install `gds-cli`.

If you need to install `gds-cli`, you should do so using [Homebrew](https://brew.sh/). Run the following in the command line:

```sh
brew install alphagov/gds/gds-cli
```

You can test that `gds-cli` is working by running:

```sh
gds --version
```

If `gds-cli` is working, you should get some version number output, like in the following example:

```
gds version v5.13.0
```

See the [`gds-cli` README](https://github.com/alphagov/gds-cli#readme) for more information on how to use `gds-cli`.

### Install aws-vault

If you have [installed the GDS command line tools](https://docs.publishing.service.gov.uk/manual/get-started.html#3-install-gds-command-line-tools) as part of [getting started on GOV.UK](https://docs.publishing.service.gov.uk/manual/get-started.html), you do not need to install `aws-vault`.

If you need to install `aws-vault`, you should do so using [Homebrew](https://brew.sh/). Run the following in the command line:

```sh
brew install --cask aws-vault
```

You can test that `aws-vault` is working by running:

```sh
aws-vault --version
```

If `aws-vault` is working, you should get some version number output, like in the following example:

```
v6.2.0
```

See the [`aws-vault` README](https://github.com/99designs/aws-vault#readme) for more information on how to use `aws-vault`.
