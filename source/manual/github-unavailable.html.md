---
owner_slack: "#govuk-developers"
title: Deploy when GitHub is unavailable
section: Deployment
layout: manual_layout
parent: "/manual.html"
---

## AWS CodeCommit

We mirror all non-archived GitHub repositories tagged with `govuk` to AWS CodeCommit via the ["Mirror repositories" GitHub Actions workflow](https://github.com/alphagov/govuk-infrastructure/blob/main/.github/workflows/mirror-repos.yml). The workflow uses the [`github_action_mirror_repos_role` IAM role](https://github.com/alphagov/govuk-infrastructure/blob/main/terraform/deployments/github/mirror.tf).

### Build and deploy an app when GitHub is unavailable

If GitHub.com is down, you can still clone a GOV.UK repo from CodeCommit and
build and deploy a container image from your workstation.

Run the following commands from the root directory of the repository.

1. [Set up CodeCommit on your machine](/manual/howto-checkout-and-commit-to-codecommit.html#install-dependencies-and-set-up-local-environment) if you haven't already.
1. Follow the [CodeCommit guide](/manual/howto-checkout-and-commit-to-codecommit.html#quick-reference-guide) to clone the repo and commit/push changes if needed.
1. Set the image tag, image registry and image repository names that you will use by running the following commands. You don't need to modify any of the values in the commands.

```
LOCAL_HEAD_SHA=$(git rev-parse HEAD)
IMAGE_TAG="release-${LOCAL_HEAD_SHA}"
REGISTRY="172025368201.dkr.ecr.eu-west-1.amazonaws.com"
REPO=$(basename "$PWD")
```

1. Build the container image and tag it appropriately.

```
docker build --platform linux/amd64 -t $IMAGE_TAG .
```

1. Log into ECR and push the image:

```
gds aws govuk-production-poweruser aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin $REGISTRY
docker push $REGISTRY/$REPO:$IMAGE_TAG
```

### Deploy the image to Kubernetes using Argo CD

> ⚠️ This procedure will disable automatic deployments *for all applications*, not only in the environment you are working on but also in higher environments. For example, performing this procedure on integration will prevent all automatic deployments in integration, staging and production.

1. Fetch the password for the Argo CD `admin` user. This varies by environment.

    ```sh
    kubectl -n cluster-services get secret argocd-initial-admin-secret -oyaml |yq .data.password |base64 -d
    ```

1. Log into Argo CD (for example in [integration](https://argo.eks.integration.govuk.digital/)).
1. Disable auto-sync for the `app-config` application:
    1. From the Applications page (the Argo CD homepage), choose the `app-config` application.
    1. Press the `App Details` button near the top of the page.
    1. Scroll down to the bottom of the page and press `Disable auto-sync`. Argo will prompt you before actually disabling auto-sync.
1. Repeat the steps above to turn off auto-sync for the application you wish to deploy.
1. Close the `App details` sidebar, then select the Deploy object for the component of the application you'd like to redeploy. For example, to update the Sidekiq workers for Account API, you would open up the `account-api-worker` Deploy object.
1. Go to `Live manifest` and select `Edit`.
1. Find the `image:` field for the `app` container. It should look something like `172025368201.dkr.ecr.eu-west-1.amazonaws.com/<app-name>:release-2e902e3df274a00bbabba7ccf84cbef96ccc9b9e`.
1. Update the tag part of the `image:` value to the new image tag that you pushed to ECR. The part you are changing should look something like `release-2e902e3df274a00bbabba7ccf84cbef96ccc9b9e`.
1. Click `Save`. Argo CD will start the deployment, which should complete in under ten minutes.

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
