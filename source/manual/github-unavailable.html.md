---
owner_slack: "#govuk-developers"
title: Deploy when GitHub is unavailable
section: Deployment
layout: manual_layout
parent: "/manual.html"
---

## Backup to AWS CodeCommit

We mirror all non-archived GitHub repositories tagged with `govuk` to AWS CodeCommit. This is achieved using a ["Mirror repositories" GitHub workflow](https://github.com/alphagov/govuk-infrastructure/blob/main/.github/workflows/mirror-repos.yml), which uses a [`github_action_mirror_repos_role` IAM role configured in Terraform](https://github.com/alphagov/govuk-infrastructure/blob/main/terraform/deployments/github/mirror.tf).

### Checkout code in AWS CodeCommit

Since our deployment images are named via git tags, we'll need to checkout our code from AWS CodeCommit in order to make sure we're deploying the correct image and have an up-to-date copy of the code.

Setup your local environment for [checking out code from CodeCommit](/manual/howto-checkout-and-commit-to-codecommit.html)

## Drill creating and deploying a branch from CodeCommit

If GitHub.com is down, Docker images can still be created and then deployed manually in Argo.

### Create and deploy an image to ECR

Ensure the following instructions are all run from the root directory of the repository.

1. Follow the steps for [checking out and committing from CodeCommit](/manual/howto-checkout-and-commit-to-codecommit.html) to clone the repo.
1. Make your changes.
1. Name the `IMAGE_TAG` for your change, which you will then push to the ECR (Elastic Container Registry) in order to deploy the change from Argo.

```
LOCAL_HEAD_SHA="$(git rev-parse HEAD)"
IMAGE_TAG="release-${LOCAL_HEAD_SHA}"
ECR_REGISTRY="172025368201.dkr.ecr.eu-west-1.amazonaws.com"
REPO=$(awk -F '=' /GOVUK_APP_NAME/'{print $2}' Dockerfile)
```

1. Build the docker image locally with the tag named after the latest sha.

```
 docker build --platform linux/amd64 -f Dockerfile -t $IMAGE_TAG .
```

1. Log in and push the image to ECR:

```
gds aws govuk-production-poweruser aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin $ECR_REGISTRY
docker push $ECR_REGISTRY/$REPO:$IMAGE_TAG
```

### Deploy the image to EKS using Argo

1. Get the Admin Argo credentials by running `kubectl -n cluster-services get secret argocd-initial-admin-secret -oyaml |yq .data.password |base64 -d`
1. Log into [Argo](https://argo.eks.integration.govuk.digital/)
1. Search for the application you wish to deploy in the "Search applications..." search bar
1. Select the application from the list below the search bar
1. Select "APP DETAILS"
1. Go to "DISABLE AUTO-SYNC" then select "ok" when prompted "Disable Auto-Sync?"
1. Close the "APP DETAILS" menu, then select the three dots next to the Deploy object for the part of the application you'd like to redeploy. For example, `account-api-worker` would be for deploying the `account-api-workers`.
1. Go to the "LIVE MANIFEST" and select "EDIT". Find the "image", then update it to the new image tag you'd like to deploy. (You can double-check you have the correct image name by doing a `git log` after [checking out the code from CodeCommit](/manual/howto-checkout-and-commit-to-codecommit.html)).
1. Click "Save" and Argo will start the deployment, which should complete in under ten minutes.

## Troubleshooting 403 errors from AWS

If running any `git` commands against CodeCommit returns a 403 response, you probably
have expired credentials stored in your macOS keychain from a previous attempt.
Apparently macOS stores these the first time you use it and subsequently tries
to use them again despite you setting new AWS credentials.

To fix this:

1. Open Keychain Access (use cmd-space to search for it).
1. Select "Passwords" from the "Category" on the left.
1. Search for `git-codecommit`.
1. Right click on the item and select "Get Info".
1. Click "Access Control" on the modal that pops up.
1. Select "git-credential-osxkeychain" from the list.
1. Hit the minus key.
1. Try your terminal commands again.
1. If you are prompted to add the item to keychain, deny.

There is more information about setting up your access key in the [AWS guide](https://docs.aws.amazon.com/codecommit/latest/userguide/setting-up-https-unixes.html)
