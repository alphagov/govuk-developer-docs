---
owner_slack: "#govuk-datagovuk"
title: Deployments for data.gov.uk
section: data.gov.uk
layout: manual_layout
parent: "/manual.html"
---
[find]: https://github.com/alphagov/datagovuk_find
[Staging]: https://staging.data.gov.uk/
[CKAN]: https://github.com/alphagov/ckanext-datagovuk
[ckanext-datagovuk]: https://github.com/alphagov/ckanext-datagovuk
[docker/ckan]: https://github.com/alphagov/ckanext-datagovuk/tree/main/docker/ckan
[ckan-publisher]: https://ckan.publishing.service.gov.uk/
[Argo CD]: https://argo.eks.integration.govuk.digital/
[govuk-dgu-charts]: https://github.com/alphagov/govuk-dgu-charts/pulls
[CSW]: https://opengeospatial.github.io/e-learning/cat/text/main.html

This document describes the release and rollout automation (CI/CD) for data.gov.uk and how to deploy a release to production.

## Overview

The data.gov.uk applications run in the `datagovuk` namespace on the GOV.UK Kubernetes clusters. Builds and tests (CI) run in GitHub Actions.

Rollout automation is in [Argo CD] under the `datagovuk`, `ckan` and `dgu-shared` Argo applications. These are configured via the `dgu-app-of-apps` Argo application.

There are some differences between data.gov.uk and other GOV.UK applications in how rollouts work. In data.gov.uk, you need to:

- push a Git tag to create a release, such as `v1.2.3`
- approve and merge an automated PR to roll out a release to integration, staging or production

data.gov.uk's releases and rollouts tooling is otherwise similar to the rest of GOV.UK.

## List existing releases of a data.gov.uk application

You can see a list of all the tagged releases for each application:

- [Find](https://github.com/alphagov/datagovuk_find/pkgs/container/datagovuk_find)
- [CKAN](https://github.com/alphagov/ckanext-datagovuk/pkgs/container/ckan) (ckanext-datagovuk)
- [PyCSW](https://github.com/alphagov/ckanext-datagovuk/pkgs/container/pycsw)
- [Solr](https://github.com/alphagov/ckanext-datagovuk/pkgs/container/solr)

## Find

### Create a release

Create a release of datagovuk_find by pushing a Git tag to the application's GitHub repository.

You must name the tag using the format `v<major>.<minor>.<patch>`, where major, minor and patch are integers. For example `v1.0.23` is a valid release tag whereas `1.0.23` is not.

You should determine the version number for your release by looking up the current version and applying the principles of [semantic versioning](https://semver.org/) (semver). For example if your release includes a new feature but no breaking changes, you should increment the minor version number.

1. Find the latest existing release tag.

    ```sh
    git tag --list --sort=-version:refname v\* | head
    ```

1. Tag your new release.

    ```sh
    git tag v1.0.23
    ```

1. Push your new release tag to GitHub.

    ```sh
    git push origin v1.0.23
    ```

    The `create-pr-on-tags` workflow in GitHub Actions will raise a PR in [govuk-dgu-charts] with a title like `Update <app> tags for integration (<commit_sha>)`.

1. Merge the PR to roll the release out to the integration environment.

Builds can take up to 10 minutes. You can view progress in GitHub Actions under the `build-and-push-images-on-tags` workflow in the app's repo.

Deployments typically take 5 minutes. You can view progress in Argo CD.

### Check that your release has been successfully deployed

In order to validate that your release has been deployed, you will need to check the status of the relevant pod in the appropriate environment in Argo CD.

For changes to `CKAN` you will need to look under the `ckan` application and for the `Find` app you will need to look under the `datagovuk` application. For example [datagovuk application in integration in Argo CD](https://argo.eks.integration.govuk.digital/applications/cluster-services/datagovuk)

If the application sync status does not match your deployment, i.e. the commit sha doesn't match or the sync status comment is referring to an older pull request merge, then you will need to click on `sync` to manually trigger the sync to the latest commit on the `main` branch.

When the Argo app health status is not "Healthy" this indicates that the deployment has not been successful and will need to be investigated by checking the failing pod's logs, or by running something like `kubectl describe pod <pod name> -n datagovuk` on your terminal if the logs are not available or useful. The deployment needs to be fixed before you should start testing the web application, as web traffic will be served by pods running the previous successful release.

### Promote a release to staging or production

Once you are happy that your change works well in the integration environment, you can promote it to staging and then to production.

The `create-charts-pr` workflow in GitHub Actions will have automatically raised a pair of PRs after you merged the `Update <app> tags for integration` PR. See the [previous section](#create-a-release) if your release is not yet in integration.

1. Merge the `Update <app> tags for staging` PR to roll your release out to staging.

1. Test that your changes are working in [Staging].

1. Merge the `Update <app> tags for production` PR.

## CKAN

You can create a CKAN release by pushing a tag to the [ckanext-datagovuk] repo. CKAN releases and rollouts work the same way as [Find](#Find).

### Update a CKAN extension

To update a CKAN extension such as `spatial`, `harvest` or `dcat`, you must update the extension's pinned version SHA in the Dockerfile for the appropriate version of CKAN under [docker/ckan].

### Manually test the CSW service

When deploying changes that affect the [CSW] service, such as OWSLib or PyCSW updates, you should test that the `/csw` endpoint still works properly.

```sh
curl -v https://ckan.staging.publishing.service.gov.uk/csw
```

Alternatively you can visit <https://ckan.staging.publishing.service.gov.uk/csw> in Firefox. Chrome and Safari don't display the XML very nicely.

You can also test the daily sync between PyCSW and CKAN:

```sh
ckan ckan-pycsw load -p /var/ckan/pycsw.cfg -u http://ckan-ckan:5000
```

PyCSW should automatically update as part of the CKAN rollout. If changes are not appearing, you can:

- check the rollout status in Kubernetes

    ```sh
    kubectl -n datagovuk rollout status deploy/ckan-pycsw
    ```

- check the status of the `ckan-pycsw` pods in Argo CD, under the `ckan` Argo application
