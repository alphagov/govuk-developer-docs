---
owner_slack: "#govuk-datagovuk"
title: Deployments for data.gov.uk
section: data.gov.uk
layout: manual_layout
parent: "/manual.html"
---
[publish]: repos/datagovuk_publish
[find]: repos/datagovuk_find
[publish-ci]: https://github.com/alphagov/datagovuk_publish/tree/main/.github/workflows
[find-ci]: https://github.com/alphagov/datagovuk_find/tree/main/.github/workflows
[staging]: http://staging.data.gov.uk
[CKAN]: https://github.com/alphagov/ckanext-datagovuk
[ckanext-datagovuk]: https://github.com/alphagov/ckanext-datagovuk
[install-dependencies]: https://github.com/alphagov/ckanext-datagovuk/blob/main/bin/install-dependencies.sh
[ckan-publisher]: https://ckan.publishing.service.gov.uk
[CKAN Argo]: https://argo.eks.integration.govuk.digital/applications/ckan
[Github Actions]: https://github.com/alphagov/ckanext-datagovuk/actions
[datagovuk Argo]: https://argo.eks.integration.govuk.digital/applications/datagovuk
[CKAN charts]: https://github.com/alphagov/govuk-ckan-charts/pulls
[build image on tag]: https://github.com/alphagov/ckanext-datagovuk/actions/workflows/build-image-on-tags.yaml

## Find and Publish (Rails Apps)

### Continuous Integration

Github Actions is configured for both [Publish (CI)][publish-ci] and [Find (CI)][find-ci]. Tests are run on pull requests.

### Integration, Staging and Production Environments

[Publish] and [Find] uses some of GOV.UK Kubernetes platform, which includes [Argo][datagovuk Argo] for managing the application stack.

Deployment of both apps in Integration, Staging and Production is triggered automatically via GitHub flow.

#### Integration

To deploy to Integration merge a PR into `main`.

### Staging & Production

To deploy to Staging/Production you need to tag the release.
The tag needs to be in this format `v9.9.9` - where 9 is a number and the leading `v` is required. E.g. `v0.1.11` is valid, `0.1.11` is not.

This will create a PR on [govuk-dgu-charts][govuk-dgu-charts] which you should be able to approve and merge into `main` for testing.

Test that your changes are working in [Staging][staging] before releasing to Production.

Then merge in the Production release PR.

All tagged releases can be viewed on these links for their respective applications:

[Publish](https://github.com/alphagov/datagovuk_publish/pkgs/container/datagovuk_publish)
[Find](https://github.com/alphagov/datagovuk_find/pkgs/container/datagovuk_find)

## CKAN

[CKAN] uses some of GOV.UK Kubernetes platform, which includes [Argo][CKAN Argo] for managing the application stack and [Github Actions][Github Actions] for CI.

Deployments for CKAN are initiated via updates to [ckanext-datagovuk][ckanext-datagovuk]. Whenever a CKAN extension (eg. spatial, harvest, dcat) is updated, the [install-dependencies][install-dependencies] file will need an update with the relevant extension's commit or version number.

After merging a pull request into the `main` branch, the build images will be created for CKAN, PYCSW and Solr, and a pull request will be opened on the [CKAN charts][CKAN charts] Github repository. This will require approval and merge into the `main` branch.

All tagged releases can be viewed on these links for their respective applications:

[CKAN](https://github.com/alphagov/ckanext-datagovuk/pkgs/container/ckan)
[PYCSW](https://github.com/alphagov/ckanext-datagovuk/pkgs/container/pycsw)
[Solr](https://github.com/alphagov/ckanext-datagovuk/pkgs/container/solr)

- Check that the changes have been successfully deployed to Integration and that CKAN is still working as expected, without pods failing in the cluster:

```bash
# show running pods
$ kubectl get pods -n datagovuk
```

- To promote the deployment to Staging and Production create a release tag on [ckanext-datagovuk][ckanext-datagovuk] in the semantic versioning form `v1.0.0`.
  - This creates the relevant build images for use on the Kubernetes cluster and a pull request on the [CKAN charts][CKAN charts] Github repository for Staging and Production deployments.
    - The build image can take up to 10 minutes to complete their build. Visit [build image on tag][build image on tag] to keep track of the build before merging the pull request.
  - It's recommended that you approve and merge the pull request for Staging to `main`, and ensure that the deployment was successful, before merging the pull request for Production.
  - You'll need to authenticate when switching between environments if you want to use `kubectl` to check the pods.

Deployments generally take up to 5 minutes to synchronise on the cluster. You can view the progress in [Argo][CKAN Argo]. The polling to synchronise changes are every 2 minutes.

### CSW

When deploying changes that affect the CSW service (OWSLib or PyCSW updates) for the [CKAN publisher][ckan-publisher] (provided at the `/csw` endpoint) you should make sure that the endpoint is still running correctly by curling it, `curl "https://ckan.publishing.service.gov.uk/csw"`, or viewing it in Firefox. Chrome and Safari do not show the XML correctly.

The daily sync between pycsw and ckan can also be tested:

```bash
$ ckan ckan-pycsw load -p /var/ckan/pycsw.cfg -u http://ckan-ckan:5000
```

The PYCSW pod should be automatically updated for each deployment of CKAN. If changes are not appearing, you can try this command:

```bash
# show running csw pods
$ kubectl get pods -n datagovuk | grep csw
```
