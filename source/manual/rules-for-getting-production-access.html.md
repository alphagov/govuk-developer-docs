---
owner_slack: "#govuk-platform-engineering"
title: Rules for getting production access
parent: "/manual.html"
layout: manual_layout
section: Authentication and authorisation
type: learn
---

In the GOV.UK programme we restrict access to production systems for new or
returning developers, SREs, and technical architects. We do so to defend
against accidental mistakes and to provide time for people build knowledge in
how to interact with our production systems safely. Note we have separate
processes to protect against malicious activity, for example security
clearance, probation, building secure systems with audibility etc.

## Types of production access

We have two types of production access:

1. [Production Deploy access](#production-deploy-access)
2. [Production Admin access](#production-admin-access)
3. [Platform Engineer access](#platform-engineer-access)

We have a [spreadsheet documenting the full list of permissions for both access levels](https://docs.google.com/spreadsheets/d/1oqy7tKpB8mHBhHQ9jAZu0NR0GKKZXOqtQGBKHYVnpmk/edit?usp=sharing).

### Production Deploy access

This level of access allows engineers to deploy code but not administer admin related
systems. Access includes:

- Permission to [deploy apps](/manual/development-pipeline.html#deployment) via the [GOV.UK Production Deploy Github team](https://github.com/orgs/alphagov/teams/gov-uk-production-deploy)
- Permission to [merge pull requests](/manual/merge-pr.html#header) in continuously deployed applications
- Read-only access to logging systems such as Logit, etc.
- Read-only access to dashboards in staging and production, such as the Argo CD web UI
- AWS "developer" access in Staging environment (via the `production_deploy_access` role [in `govuk-user-reviewer`](https://github.com/alphagov/govuk-user-reviewer/blob/main/config/govuk_tech.yml)) which grants read-only access to all services plus additional access to Athena, EKS and other components that are regarded as having a low potential for misuse
- The AWS "developer" Role will also grant to access to most resources and actions in EKS (using `kubectl`) through RBAC (Role-Based Access Control)
- "Normal" role in to GOV.UK Signon on Staging and Production (with app permissions granted as needed)

The steps above are outlined in the [GOV.UK Production Deploy template Trello card](https://trello.com/c/S9sex2XU/1391-govuk-production-deploy-access-for-name), which can be copied to
your team's board and carried out by developers. You can ask Platform Engineering for help if you have
any access issues.

#### When you get Production Deploy access

Access can be granted to both civil servants and contractors as needed, at the discretion of a "sponsor": either the engineer's (civil servant) tech lead, or a [GOV.UK Senior Tech member](/manual/ask-for-help.html#contact-senior-tech).

Before approving access, the sponsor should ensure that the engineer:

- has the required level of security clearance (BPSS)
- is aware of our processes and standards around [code review](https://gds-way.digital.cabinet-office.gov.uk/manuals/code-review-guidelines.html)
- understands the responsibilities that [releasing code](/manual/development-pipeline.html#deployment) brings with it
- knows [how to roll back to an older release](/kubernetes/manage-app/roll-back-app/#roll-back-your-app) if there are any issues
- knows [how to get help](/manual/ask-for-help.html) from someone with more access if they need it

To grant access, the sponsor should follow the steps in the ["GOV.UK Production Deploy" access](https://trello.com/c/S9sex2XU/3227-govuk-production-deploy-access-for-name) template card.

Note that a technologist apprentice is limited to Production Deploy access. However, if they are confident and want to take on an in-hours technical on-call shift as a Secondary, they can follow the Production Admin access steps (at their Line Manager's discretion).

### Production Admin access

Gives:

- Write access to Argo CD in staging and production via the [GOV.UK Production GitHub team](https://github.com/orgs/alphagov/teams/gov-uk-production-admin)
- Privileged AWS Access in Production and Staging environments (via the `production_admin_access` role [in `govuk-user-reviewer`](https://github.com/alphagov/govuk-user-reviewer/blob/main/config/govuk_tech.yml))
- [Google Cloud Platform (GCP)](/manual/google-cloud-platform-gcp.html) access to role to manage [static mirrors](/manual/fall-back-to-mirror.html) and DNS
- Signon "Super Admin" access in production
- `engineer` and "Access all services" permissions in Fastly
- [Sentry](https://sentry.io/settings/govuk/members/) "Admin" role to administer teams and projects

#### When you get Production Admin access

- You have a minimum of BPSS security clearance (blue building pass), AND
- You have passed your probation period, AND
- You have completed the [Production Admin Preparedness checklist](https://docs.google.com/forms/d/e/1FAIpQLSeY5H8ei89AJFaQLuDrd6CpWjCighCvF3d2iXx7QsyJdQjL-Q/viewform), covering the [learning objectives](#production-admin-learning-objectives) below, and have had your form response reviewed by [someone in Senior Tech](/manual/ask-for-help.html#contact-senior-tech).

To grant access, the senior tech person should follow the steps in the ["GOV.UK Production Admin" access](https://trello.com/c/GIHPZi2o) template card.

#### Production Admin learning objectives

A new starter/engineer will be expected to work through the following checklist in order to 'qualify' for production admin access:

- The different parts of the GOV.UK technical stack (CDN, frontends, publishing apps, etc). E.g. by attending an "Introduction to GOV.UK Technical Architecture" session (or watching the [recording](https://drive.google.com/file/d/1-az_Y_JeKJ2Xhqrc7VNVt1sKOTEpHbcM/view)).
- The deployment pipeline - how code gets from your machine to running on production. E.g. by reading [the deployment docs](/manual#deployment), and learning on the job.
- The incident management process. E.g. by reading through the [So, you're having an incident](/manual/incident-what-to-do) doc and completing the [incident preparedness quizzes](https://drive.google.com/drive/folders/1X9eGQMIl9ifb3X2jYcdjqrt01P9JYJzR).
- Best practices around the principle of least privilege, how to safely debug production issues, and how to work with credentials and accounts. E.g. by pairing with another developer to practise a drill on your product team.

### Platform Engineer access

Platform Engineer access is a special set of access permissions that are very similar to Production Admin, except with specific additional access to aid Platform Engineers with their day-to-day operational needs. In addition to the access granted by Production Admin, it also gives:

- A special set of `-platformengineer` IAM roles for each environment that provide an access level similar to the `-developer` roles except also grants "Cluster Admin" access to our EKS clusters to allow Platform Engineers to access and manage all namespaces and resources

This is necessary because without this, the only way to obtain Cluster Admin access would be to assume the `fulladmin` role on a regular basis, which we are trying to discourage except for "break glass" type scenarios that may trigger alerting.

## Temporarily revoking access

If you're absent more than 6 weeks, your access should be revoked.
