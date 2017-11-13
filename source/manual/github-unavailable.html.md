---
owner_slack: "#2ndline"
title: Deploy when GitHub is unavailable
section: Deployment
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2017-10-13
review_in: 1 months
---

## Public GitHub (application code)

Many of the Git repositories which make up GOV.UK are hosted on public GitHub. We may need to deploy changes at any time, and GitHub.com is a Software as a Service (SaaS) product which is not guaranteed to be available.

If GitHub is unavailable, we lose:

* Access to our primary code repository
* The ability to authenticate with Jenkins, as it makes use of GitHub groups

We mirror all our repositories to GitLab.com every two hours using the
[`govuk-repo-mirror`](https://github.com/alphagov/govuk-repo-mirror) scripts. This is run from the [`Mirror_Repositories`](https://ci.integration.publishing.service.gov.uk/job/Mirror_Repositories/) CI job
In the event of Github being down, we can deploy the code from the [govuk team](https://gitlab.com/govuk/) on GitLab.com.

### Deploying from GitLab.com

Use the normal deployment job but check the box to deploy from GitLab.com.

### Making changes to code in GitLab before deployment

GOV.UK Tech Leads are owners on the `govuk` team on GitLab.com. Thy can give access to developers who need to make changes to the code before deployment. This may be necessary if we need to work in private, for example to fix a security vulnerability without disclosing it to the public. To do this, push to a new branch on GitLab.com and then deploy that code.

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
