---
owner_slack: "#2ndline"
title: Deploy when GitHub is unavailable
section: Deployment
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/2nd-line/releasing-software/github-unavailable.md"
last_reviewed_on: 2016-12-18
review_in: 6 months
---

> **This page was imported from [the opsmanual on GitHub Enterprise](https://github.com/alphagov/govuk-legacy-opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.com/alphagov/govuk-legacy-opsmanual/tree/master/2nd-line/releasing-software/github-unavailable.md)


## Public GitHub (application code)

Many of the Git repositories which make up GOV.UK are hosted on public GitHub. We may
need to deploy changes at any time, and GitHub.com is a Software as a Service (SaaS)
product which we don't control the availability of.

GDS Internal IT host GitHub Enterprise which we can use to deploy from if public
GitHub is unavailable.

During a normal production application deployment the app code is pushed to the
[`gds-production-backup`](https://github.digital.cabinet-office.gov.uk/gds-production-backup/) organisation
on GitHub Enterprise.

We copy to GitHub Enterprise after a production deployment so we know that we're
only mirroring trusted code.

### Deploying from GitHub Enterprise

Use the normal deployment job but check the box to deploy from GitHub Enterprise.

In integration and staging the job will fail because it doesn't have access to push
branches and tags back to the repository in `gds-production-backup`.

### Making changes before deployment

Push to a new branch on the production backup repo and then deploy that code. Ideally
we wouldn't make changes to the production backup repo and only use it as a backup,
but sometimes we need to (in exceptional circumstances when we can't work in public).

## GitHub Enterprise (secrets)

If GitHub Enterprise becomes unavailable, GDS internal IT will switch to
a disaster recovery instance. Internal IT have previously estimated that failing
over to the DR machine may take some time.

Depending on the nature of the outage, we may need to change our `govuk_ghe_vpn`
configuration to point to `vpndr.digital.cabinet-office.gov.uk`.

In order to deploy this change, you may first need to disable Puppet on the Jenkins
machine and make the change manually.
