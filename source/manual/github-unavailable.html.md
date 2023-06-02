---
owner_slack: "#govuk-developers"
title: Deploy when GitHub is unavailable
section: Deployment
layout: manual_layout
parent: "/manual.html"
---

Many of the git repositories which make up GOV.UK are hosted on public GitHub. If GitHub becomes unavailable, our Jenkins deployment pipeline breaks. This is because:

* Jenkins uses the [GitHub Authentication plugin](https://plugins.jenkins.io/github-oauth/) to manage access: [only people in certain GitHub groups can access Jenkins](/manual/access-jenkins.html). If GitHub goes down, nobody can log into Jenkins
* The [`Deploy_App` Jenkins job][Deploy_App]  uses GitHub by default when it clones repositories ready for deploying. If GitHub goes down, it can't clone the repository

The workaround is to disable Jenkins security, then configure the `Deploy_App` job to clone from AWS CodeCommit instead.

## Disable Jenkins Security

If GitHub.com is down, we will not be able to log in to Jenkins.
In this scenario, Jenkins security should be disabled to enable deployment:

1. SSH to the Jenkins deploy instance: `gds govuk connect -e production ssh aws/jenkins`
1. Disable Puppet: `govuk_puppet -r "Emergency Jenkins deploy" --disable`
1. Edit the Jenkins configuration file: `sudo vim /var/lib/jenkins/config.xml`
1. Replace `<useSecurity>true</useSecurity>` with `<useSecurity>false</useSecurity>` and save
1. Restart Jenkins: `sudo service jenkins restart`

Once security is disabled, anyone on GDS-trusted IPs will be able to invoke any Jenkins job, including `Deploy_App`. Do not leave security disabled for any longer than necessary.

See the [Jenkins documentation](https://www.jenkins.io/doc/book/security/securing-jenkins/) for further details.

## Deploy from AWS CodeCommit

We mirror all non-archived GitHub repositories tagged with `govuk` to AWS CodeCommit every 2 hours. This is achieved using a ['Mirror GitHub repositories' Jenkins job](https://deploy.integration.publishing.service.gov.uk/job/Mirror_Github_Repositories/), which is [configured in govuk-puppet](https://github.com/alphagov/govuk-puppet/pull/11631/files) and the [govuk-repo-mirror repository](https://github.com/alphagov/govuk-repo-mirror).

We can deploy from AWS CodeCommit instead of GitHub, if GitHub is down or if we need a private place to develop fixes for security vulnerabilities before they are deployed.

To do so, trigger the [`Deploy_App`][Deploy_App] Jenkins job, but check the `DEPLOY_FROM_AWS_CODECOMMIT` box to deploy from AWS CodeCommit.

### Making changes to code in AWS CodeCommit before deployment

If you need to deploy from AWS CodeCommit because GitHub is down or you need to test a change of a sensitive nature, you will likely need to push a new branch of code to CodeCommit.

Setup your local environment for [checking out code from CodeCommit](/manual/howto-checkout-and-commit-to-codecommit.html)

### Deploying a hotfix from AWS CodeCommit

Once you've [pushed your hotfix branch to CodeCommit](#making-changes-to-code-in-aws-codecommit-before-deployment), you should:

1. Create a pull request in the CodeCommit UI.
1. Ask another developer to review it as a sense check.
1. With the branch reviewed, you can then [deploy it](#deploy-from-aws-codecommit), specifying your branch name as the `TAG` (in the example above, 'hotfix'). Do this in Integration or Staging first, then manually test the changes.
  - In the example above, you can check the README was removed by SSH'ing into the relevant machine and executing `ls /var/apps/{REPO_NAME}` to confirm that the README is absent.
1. Once you're confident in your changes, deploy the branch to Production.
1. Record the missing deployment in the Release app.

### Tidy up after deploying a hotfix

When GitHub is back online, it's time to make Jenkins secure again and merge your changes back into the main repository.

1. Re-enable and run Puppet on the Jenkins instance: `govuk_puppet --enable && govuk_puppet --test`
1. Restart Jenkins: `sudo service jenkins restart`
1. Push your hotfix branch to GitHub, open a pull request, and have it reviewed and merged as normal.
1. This will create a proper release tag, which will automatically deploy through all of the environments if continuous deployment is enabled, or should be manually deployed to all environments if not.
1. Delete your branch from CodeCommit.

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

## Drill creating and deploying a branch from CodeCommit

To ensure that our fallback procedure continues to work, we need to drill it regularly.

1. [Disable Jenkins security](#disable-jenkins-security)
1. Pick a publishing app at random (because the risk is lower than a frontend app, should the change be accidentally published to Production)
1. Clone the repo from CodeCommit and create a branch with a trivial change (see [instructions](#making-changes-to-code-in-aws-codecommit-before-deployment)). Ideally it should be a visible change, such as a text change in one of the pages rendered by the app.
1. Get it reviewed by the other developer on 2nd line, and then deploy it to Staging (see [instructions](#deploying-a-hotfix-from-aws-codecommit)). Do NOT deploy to Production.
1. Manually test that you can see your changes in the app on Staging.
1. Record the missing deployment in the Release app on Staging if you wish, just to familiarise yourself with the process
1. [Re-enable Jenkins security](#tidy-up-after-deploying-a-hotfix), re-deploy the previous release and delete your branch from CodeCommit

[Deploy_App]: https://deploy.integration.publishing.service.gov.uk/job/Deploy_App/
