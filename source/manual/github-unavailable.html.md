---
owner_slack: "#govuk-developers"
title: Deploy when GitHub is unavailable
section: Deployment
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-07-31
review_in: 3 months
---

## Public GitHub (application code)

Many of the Git repositories which make up GOV.UK are hosted on public GitHub. We may need to deploy changes at any time, and GitHub.com is a Software as a Service (SaaS) product which is not guaranteed to be available.

If GitHub is unavailable, we lose:

* Access to our primary code repository
* The ability to authenticate with Jenkins, as it makes use of GitHub groups

We mirror all our repositories to AWS CodeComit every two hours using the
[`govuk-repo-mirror`](https://github.com/alphagov/govuk-repo-mirror) scripts. This is run from the [`Mirror_Repositories`](https://ci.integration.publishing.service.gov.uk/job/Mirror_Repositories/) CI job
In the event of Github being down, we can deploy the code from AWS CodeCommit repos. This requires help from a GOV.UK AWS admin.

### Deploying from AWS CodeCommit

Use the normal deployment job but check the box to deploy from AWS CodeCommit.

### Making changes to code in AWS CodeCommit before deployment

GOV.UK AWS admin users can give access to developers who need to make changes to the code before deployment. This may be necessary if we need to work in private, for example to fix a security vulnerability without disclosing it to the public. To do this, push to a new branch on AWS CodeCommit and then deploy that code.

### Authenticating with Jenkins

If GitHub.com is down, we will not be able to log in to Jenkins.

In this scenario, Jenkins security should be disabled to enable deployment:

1. SSH to the Jenkins Deploy instance: `ssh jenkins-1.<environment>`
2. Disable Puppet: `govuk_puppet -r "Emergency Jenkins deploy" --disable`
3. Edit the Jenkins configuration file: `sudo vim /var/lib/jenkins/config.xml`
4. Replace `<useSecurity>true</useSecurity>` with `<useSecurity>false</useSecurity>` and save
5. Restart Jenkins: `sudo service jenkins restart`
6. Browse to the Jenkins UI and begin the deployment process
7. When completed, enable and run Puppet on the instance: `govuk_puppet --enable && govuk_puppet --test`

Note that once security is disabled, anyone on GDS trusted IPs will be able to deploy to that environment. This will bypass protection for Production - do not leave Production without security for any longer than necessary.

See the [Jenkins documentation](https://jenkins.io/doc/book/system-administration/security/#disabling-security) for further details.

### Simulating a GitHub outage on 2ndline

You can game an outage of GitHub.com by modifying your local hosts file.

1. `sudo vi /etc/hosts`
2. Add `127.0.0.1       github.com`

Don't forget to remove it afterwards!
