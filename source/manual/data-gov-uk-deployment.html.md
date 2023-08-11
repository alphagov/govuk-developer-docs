---
owner_slack: "#govuk-datagovuk"
title: Deployments for data.gov.uk
section: data.gov.uk
layout: manual_layout
parent: "/manual.html"
---

# Deployments for data.gov.uk

[publish]: repos/datagovuk_publish
[find]: repos/datagovuk_find
[publish-ci]: https://travis-ci.org/alphagov/datagovuk_publish/
[find-ci]: https://travis-ci.org/alphagov/datagovuk_find
[heroku]: /manual/review-apps.html#header
[publish-heroku]: https://dashboard.heroku.com/pipelines/7fb4c1c1-618e-42da-ba71-1cb0beb6c5c8
[find-heroku]: https://dashboard.heroku.com/pipelines/0ca23219-ac0e-4d6c-9d5f-40829c6209db
[paas]: https://docs.cloud.service.gov.uk/#set-up-command-line
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

## Find and Publish (Rails Apps)

### Continuous Integration

Github Actions is configured for both [Publish (CI)][publish-ci] and [Find (CI)][find-ci] according to `.github/workflows/ci.yml` file in each repo. Find PRs should automatically build a [Heroku Review App][heroku], which can be accessed from the PR page on GitHub.

### PaaS Integration, Staging and Production Environments

[Publish] and [Find] are provisioned on [GOV.UK PaaS][paas]. Each app repo
contains a set of manifests that specify the container settings for when it's
deployed.

The deployment for both apps in Staging and Production can be triggered automatically via GitHub flow, or all environments can be manually deployed via command line tools.

You will need to log in to the `gds-data-gov-uk` org to get access to the correct space, if you don't have access contact the #paas team slack channel.

#### Pre-requisite for manual deployment -

```
## run once to install the plugin
cf add-plugin-repo CF-Community https://plugins.cloudfoundry.org
cf install-plugin autopilot -r CF-Community -f
```

#### Integration

Log in to `data-gov-uk-staging` space for integration deployments.

Deployment to integration requires manual deployment

```
## manually deploy the publish app
cf zero-downtime-push publish-data-beta-staging-worker -f staging-worker-manifest.yml

## manually deploy the find app
cf zero-downtime-push find-data-beta-integration -f integration-manifest.yml
```

#### Staging

Log in to `data-gov-uk-staging` space for staging deployments.

The deployment to staging is triggered when a PR gets merged into master. You
can check the [Github actions logs of the `master` build for Find](https://github.com/alphagov/datagovuk_find/actions) and [Github actions logs of the `master` build for Publish](https://github.com/alphagov/datagovuk_publish/actions) to see progress.

You can check the deployment on [staging.data.gov.uk](https://staging.data.gov.uk/)

The process to manually deploy is as follows -

```
## manually deploy the publish app
cf zero-downtime-push publish-data-beta-staging-worker -f staging-worker-manifest.yml

## manually deploy the find app
cf zero-downtime-push find-data-beta-staging -f staging-manifest.yml
```

#### Production

Log in to `data-gov-uk` space for production deployments.

The deployment to production is triggered when a [new release] with an appropriate version
number is created in GitHub.

To create a new release, provide a new version number, release title and description. The version number must include the leading 'v' to trigger a deployment, for example: `v1.0.0`

This deployment behaviour is defined in [Publish's ci.yml] and in [Find's ci.yml].

The process to manually deploy is as follows -

```
## manually deploy the publish app
cf zero-downtime-push publish-data-beta-production-worker -f production-worker-manifest.yml

## manually deploy the find app
cf zero-downtime-push find-data-beta -f production-manifest.yml
```

There are [some scripts available for datagovuk_publish](https://github.com/alphagov/datagovuk_publish/tree/main/scripts) which can run a deploy for you, for example:

```
$ cd datagovuk_publish
$ git pull
$ ./scripts/deploy-staging.sh
$ ./scripts/deploy-production.sh
```

For more advanced uses of the PaaS that are not covered in the PaaS internal documentation (e.g. provisioning an app using a buildpack that is not Ruby or Java), refer to the [Cloud Foundry documentation][cf-docs].

### Set up interactive SSH session

You may need this to run things such as rake tasks:

```
/tmp/lifecycle/shell
```

You need to run this every time you start an SSH session.

For more information, refer to the [Cloud Foundry documentation on SSH Session Environment][cf-ssh].

## CKAN

[CKAN] uses GOV.UK infrastructure, which includes [Jenkins][jenkins] for CI.

Integration, staging and production environments behave like all other GOV.UK applications on AWS.

Deployments for ckan are initiated via updates to [ckanext-datagovuk][ckanext-datagovuk], whenever a ckan extension is updated the [install-dependencies][install-dependencies] file will need an update with the relevant extensions (eg. spatial, harvest, dcat) commit or version number.

### CSW

When deploying changes that affect the CSW service, (OWSLib or PyCSW updates), provided at the `/csw` endpoint for the [CKAN publisher][ckan-publisher] you should make sure that the endpoint is still running correctly by curling it, `curl "https://ckan.publishing.service.gov.uk/csw"`, or view it in Firefox. Chrome and Safari do not show the XML on the page correctly.

The daily sync between pycsw and ckan should also be tested:

```
sudo -u deploy govuk_setenv ckan /var/apps/ckan/venv3/bin/ckan ckan-pycsw load -p /var/ckan/pycsw.cfg -u http://localhost:3220
```

The pycsw web process should be automatically restarted after each ckan deployment.

If changes are not appearing, you can try these commands.

```
# show running csw workers
sudo initctl list | grep csw

# restart the pycsw web worker
sudo service pycsw_web-procfile-worker restart
```
