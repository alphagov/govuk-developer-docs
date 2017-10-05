---
owner_slack: "#2ndline"
title: Deploy when GitHub is unavailable
section: Deployment
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/2nd-line/releasing-software/github-unavailable.md"
last_reviewed_on: 2017-10-05
review_in: 1 months
---

## Public GitHub (application code)

Many of the Git repositories which make up GOV.UK are hosted on public GitHub. We may
need to deploy changes at any time, and GitHub.com is a Software as a Service (SaaS)
product which we don't control the availability of.

We mirror all our repositories to GitLab.com every two hours using the
[`govuk-repo-mirror`](https://github.com/alphagov/govuk-repo-mirror) scripts. This is run
from the [`Mirror_Repositories`](https://ci.integration.publishing.service.gov.uk/job/Mirror_Repositories/) CI job
In the event of Github being down, we can deploy the code from the [govuk team](https://gitlab.com/govuk/)
on GitLab.com.

### Deploying from GitLab.com

Use the normal deployment job but check the box to deploy from GitLab.com.

### Making changes before deployment

GOV.UK Tech Leads are owners on the `govuk` team on GitLab.com. Thy can give access to
developers who need to make changes to the code before deployment. This may be necessary
if we need to work in private, for example to fix a security vulnerability without
disclosing it to the public. To do this, push to a new branch on GitLab.com and then deploy that code.

### Deploying if you can't authenticate with Jenkins

If GitHub.com is down, we may not be able to log in to Jenkins. We haven't yet looked into this problem,
2ndline is due to Gameday this scenario soon. Possible options:

1. Run the Capistrano deployment scripts from a developer's laptop. This may require them to have access to the `deploy` user.
2. [Bypass Jenkins authentication](https://jenkins.io/doc/book/system-administration/security/#disabling-security)
3. Add break-glass credentials to Jenkins to use instead of GitHub OAuth.
