---
title: Roll back your app
weight: 46
layout: multipage_layout
---

# Roll back your app

You can roll back your app by:

- updating the image tag to an older release in the `govuk-helm-charts` repo
- triggering the deploy GitHub Action to deploy an older release - this only works in the integration environment

## Updating the image tag to an older release

1. Get the full commit simple hashing algorithm (SHA) associated with the older release you want to roll back to.

    There are multiple ways to do this. For example, if you are using the GitHub user interface:
    - go to your app's repo
    - go to __Releases__ > __Tags__ and select the abbreviated SHA, for example `bc0b0b0`
    - copy the full SHA, for example `bc0b0b0c980f867b293cd40157c6da3a29186680`

1. Go to the [`image-tags` folder in the `govuk-helm-charts` repo](https://github.com/alphagov/govuk-helm-charts/tree/main/charts/app-config/image-tags).

1. Replace the contents of the relevant image tag file with the full commit SHA of the release you want to roll back to.

1. Create a pull request and merge the change into the main branch.

Once you have merged your pull request, [Argo CD automatically deploys the older version of the app to production](/manage-app/access-ci-cd/#deploying-a-release-of-a-gov-uk-app).

## Triggering the deploy GitHub Action to deploy an older release

When you manually trigger the deploy GitHub Action for an app,
you will stop the automatic update of that app's images.
You can re-enable the automatic image update by following the
[documentation on re-enabling automatic image updates after manual deploys](#re-enabling-automatic-image-updates-after-manual-deploys).

1. Go to your app's repo and select __Releases__.

1. Find the release number for the version of the app you want to roll back to.

1. Go to __Actions__ and select __Workflows__ > __Deploy__.

1. Select __Run workflow__ and enter the release number that you want to roll back to.

1. Select __Run workflow__ to manually deploy the older version of the app.

Argo CD will then:

- automatically build the image for the older version of the app
- deploy that version of the app

Check the [#govuk-deploy-alerts Slack channel](https://gds.slack.com/archives/C01EE7US9R6) for a notification when the older version of the app is successfully deployed.

## Re-enabling automatic image updates after manual deploys

1. Go to your app's repo.

1. Go to __Actions__ and select __Workflows__ > __Set automatic_deploys_enabled (optionally image_tag too)__.

1. Select __Run workflow__ and complete the fields as required.
