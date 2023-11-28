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
[staging]: http://test.data.gov.uk
[cf-docs]: https://docs.cloudfoundry.org
[jenkins]: /manual/jenkins-ci.html
[CKAN]: https://github.com/alphagov/ckanext-datagovuk
[new release]: https://github.com/alphagov/datagovuk_find/releases
[Publish's travis.yml]: https://github.com/alphagov/datagovuk_publish/blob/main/.travis.yml#L30-L50
[Find's travis.yml]: https://github.com/alphagov/datagovuk_find/blob/af8cfa61584b16e4e1ad7bedbd1b7f890cec940d/.travis.yml#L44-L48
[cf-ssh]: https://docs.cloudfoundry.org/devguide/deploy-apps/ssh-apps.html#ssh-env
[ckanext-datagovuk]: https://github.com/alphagov/ckanext-datagovuk
[install-dependencies]: https://github.com/alphagov/ckanext-datagovuk/blob/main/bin/install-dependencies.sh
[ckan-publisher]: https://ckan.publishing.service.gov.uk
[Argo]: https://argo.eks.integration.govuk.digital/applications/ckan
[Github Actions]: https://github.com/alphagov/ckanext-datagovuk/actions
[datagovuk Argo]: https://argo.eks.integration.govuk.digital/applications/datagovuk
[CKAN charts]: https://github.com/alphagov/govuk-ckan-charts/pulls
[build image on tag]: https://github.com/alphagov/ckanext-datagovuk/actions/workflows/build-image-on-tags.yaml

## Find and Publish (Rails Apps)

### Continuous Integration

Github Actions is configured for both [Publish (CI)][publish-ci] and [Find (CI)][find-ci].

### Integration, Staging and Production Environments

[Publish] and [Find] uses some of GOV.UK kubernetes platform, which includes [Argo][datagovuk Argo] for managing the application stack.

The deployment for both apps in Integration, Staging and Production are triggered automatically via GitHub flow.

#### Integration

To deploy to integration merge a PR into `main`.

### Staging & Production

To deploy to staging/production you need to tag the release, the tag needs to be in this format - `v9.9.9` where 9 is a number and the leading `v` is required. E.g. `v0.1.11` is valid, `0.1.11` is not.

This will create a PR on [govuk-dgu-charts](https://github.com/alphagov/govuk-dgu-charts/pulls) which you should be able to approve and merge into main for testing.

Test that your changes are working in staging - https://staging.data.gov.uk before releasing to Production.

Then merge in the production release PR.

All tagged releases can be viewed on these links for their respective applications:

Publish - https://github.com/alphagov/datagovuk_publish/pkgs/container/datagovuk_publish
Find - https://github.com/alphagov/datagovuk_find/pkgs/container/datagovuk_find

## CKAN

[CKAN] uses some of GOV.UK kubernetes platform, which includes [Argo][Argo] for managing the application stack and [Github Actions][Github Actions] for CI.

Deployments for ckan are initiated via updates to [ckanext-datagovuk][ckanext-datagovuk], whenever a ckan extension is updated the [install-dependencies][install-dependencies] file will need an update with the relevant extensions (eg. spatial, harvest, dcat) commit or version number.

After merging a pull request into the `main` branch, the build images will be created for CKAN, PYCSW and Solr and a pull request will be opened on the [CKAN charts][CKAN charts] github repository which will require an approval and merge into the `main` branch by a developer.

All tagged releases can be viewed on these links for their respective applications:

CKAN - https://github.com/alphagov/ckanext-datagovuk/pkgs/container/ckan
PYCSW - https://github.com/alphagov/ckanext-datagovuk/pkgs/container/pycsw
Solr - https://github.com/alphagov/ckanext-datagovuk/pkgs/container/solr

- Check that the changes have been successfully deployed to integration and the CKAN is still working as expected, without pods failing in the cluster

```bash
# show running pods
$ kubectl get pods -n datagovuk
```

- To promote the deployment to Staging and Production you must create a release tag on [ckanext-datagovuk][ckanext-datagovuk] in the semantic versioning form `v1.0.0`.
  - This will create the relevant build images for use on the kubernetes cluster and a pull request on the [CKAN charts][CKAN charts] github repository for Staging and Production deployments.
    - The build image can take up to 10 minutes to complete their build, visit [build image on tag][build image on tag] to keep track of the build before merging the pull request in.
  - It is recommended that you should approve and merge the pull request for Staging to `main`, and ensure that the deployment was successful before merging the pull request for Production.
  - Remember that you will need to authenticate when switching between environments if you want to use `kubectl` to check the pods.

Deployments generally take up to 5 minutes to synchronise on the cluster, you can view the progress in [Argo][Argo], the polling to synchronise changes are every 2 minutes.

### CSW

When deploying changes that affect the CSW service, (OWSLib or PyCSW updates), provided at the `/csw` endpoint for the [CKAN publisher][ckan-publisher] you should make sure that the endpoint is still running correctly by curling it, `curl "https://ckan.publishing.service.gov.uk/csw"`, or view it in Firefox. Chrome and Safari do not show the XML on the page correctly.

The daily sync between pycsw and ckan can also be tested:

```bash
$ ckan ckan-pycsw load -p /var/ckan/pycsw.cfg -u http://ckan-ckan:5000
```

The PYCSW pod should be automatically updated if there is a for each deployment of CKAN.

If changes are not appearing, you can try these commands.

```bash
# show running csw pods
$ kubectl get pods -n datagovuk | grep csw
```
