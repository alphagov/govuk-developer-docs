---
owner_slack: "#govuk-developers"
title: Deploy when GitHub is unavailable
section: Deployment
layout: manual_layout
parent: "/manual.html"
---

## Public GitHub (application code)

Many of the git repositories which make up GOV.UK are hosted on public GitHub. We may need to deploy changes at any time, and GitHub is a Software as a Service (SaaS) product which is not guaranteed to be available.

If GitHub is unavailable, we lose:

* Access to our primary code repository
* The ability to authenticate with Jenkins, as it makes use of GitHub groups

We [mirror all GitHub repositories](repository-mirroring.html) tagged with `govuk` to AWS CodeCommit every 2 hours. In the event of GitHub being down, we can deploy from AWS CodeCommit repos. This requires help from a GOV.UK AWS admin.

### Deploying from AWS CodeCommit

Use the normal deployment Jenkins job but check the box to deploy from AWS CodeCommit.

#### Making changes to code in AWS CodeCommit before deployment

GOV.UK AWS admin users can give access to developers who need to make changes to the code before deployment.

1. In the root of the local repo, run the following commands to install the AWS
   credential helper and add CodeCommit as a remote:

   ```
   git config credential.helper '!aws codecommit credential-helper $@'
   git config credential.UseHttpPath true
   git remote add aws https://git-codecommit.eu-west-2.amazonaws.com/v1/repos/<app>
   ```

1. Get some credentials for the GOV.UK Tools AWS account:

   ```
   gds aws govuk-tools-poweruser -e
   ```

1. Fetch the AWS upstream by running `git fetch aws`

1. Checkout a new branch on the upstream by running `git checkout -b aws/my-super-secret-fix`

1. Make and commit your changes to this branch, and make sure all tests run successfully
   locally (since CodeCommit does not run tests)

1. Push your changes to CodeCommit by running `git push`

1. Tag your changes by running `git tag release_XYZ`, where XYZ is one more that the latest
   release tag for the application you're working on, as reported by the Release app

1. Push your new tag to CodeCommit by running `git push aws release_XYZ`

#### Deploying the code change

1. Review the pull request on AWS CodeCommit through the [AWS Console](https://eu-west-1.console.aws.amazon.com/codesuite/codecommit/repositories?region=eu-west-1#) (access to GOV.UK repos must be granted by a GDS AWS administrator).

1. Create a release tag manually in git. This should follow the standard format
   `release_X`. Tag the branch directly instead of merging it.

1. Don't use the release app. Go directly to the `Deploy_App` Jenkins job, and
   check `DEPLOY_FROM_AWS_CODECOMMIT`.

#### After deploying the change

1. Push the branch and tag to GitHub.

1. Merge the branch into master.

1. Record the missing deployment in the Release app.

#### Troubleshooting

If running any `git` commands against CodeCommit returns you a 403, you probably
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

### Authenticating with Jenkins

If GitHub.com is down, we will not be able to log in to Jenkins.

In this scenario, Jenkins security should be disabled to enable deployment:

1. SSH to the Jenkins deploy instance:

```console
gds govuk connect -e production ssh carrenza/jenkins
gds govuk connect -e production ssh aws/jenkins
```

2. Disable Puppet: `govuk_puppet -r "Emergency Jenkins deploy" --disable`
3. Edit the Jenkins configuration file: `sudo vim /var/lib/jenkins/config.xml`
4. Replace `<useSecurity>true</useSecurity>` with `<useSecurity>false</useSecurity>` and save
5. Restart Jenkins: `sudo service jenkins restart`
6. Browse to the Jenkins UI and begin the deployment process
7. When completed, enable and run Puppet on the instance: `govuk_puppet --enable && govuk_puppet --test`

Note that once security is disabled, anyone on GDS trusted IPs will be able to deploy to that environment. This will bypass protection for Production - do not leave Production without security for any longer than necessary.

See the [Jenkins documentation](https://jenkins.io/doc/book/system-administration/security/#disabling-security) for further details.

### Simulating a GitHub outage on 2nd line

You can simulate an outage of GitHub.com by modifying your local hosts file.

1. `sudo vi /etc/hosts`
2. Add `127.0.0.1       github.com`

Don't forget to remove it afterwards!
