---
owner_slack: "#govuk-2ndline-tech"
title: Rules for getting production access
parent: "/manual.html"
layout: manual_layout
section: 2nd line
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

We have a [spreadsheet documenting the full list of permissions for both access levels](https://docs.google.com/spreadsheets/d/1oqy7tKpB8mHBhHQ9jAZu0NR0GKKZXOqtQGBKHYVnpmk/edit?usp=sharing).

### Production Deploy access

This level of access allows engineers to deploy code but not administer admin related
systems. It should be granted to both civil servants and contractors as needed.

Access includes:

- Permission to [deploy apps](https://docs.publishing.service.gov.uk/manual/development-pipeline.html#deployment) in Jenkins via the [GOV.UK Production Deploy Github team](https://github.com/orgs/alphagov/teams/gov-uk-production-deploy)
- Permission to [merge pull requests](https://docs.publishing.service.gov.uk/manual/merge-pr.html#header) in continuously deployed applications
- Readonly access to logging systems such as Logit, etc.
- AWS readonly access via the `role_user_user_arns` role in [Staging](https://github.com/alphagov/govuk-aws-data/blob/main/data/infra-security/staging/common.tfvars) and [Production](https://github.com/alphagov/govuk-aws-data/blob/main/data/infra-security/production/common.tfvars)
- "Normal" role in to GOV.UK Signon on Staging and Production (with app permissions granted as needed)

The steps above are outlined in the [GOV.UK Production Deploy template Trello card](https://trello.com/c/S9sex2XU/1391-govuk-production-deploy-access-for-name), which can be copied to
your team's board and carried out by developers. You can ask 2nd line for help if you have
any access issues.

#### When you get Production Deploy access

Access should be granted at the discretion of the engineer's tech lead, once the engineer has the required level of security clearance (BPSS). Before approving access, tech leads should ensure that the engineer:

- is aware of our processes and standards around [code review](https://gds-way.cloudapps.digital/manuals/code-review-guidelines.html)
- understands the responsibilities that [releasing code](https://docs.publishing.service.gov.uk/manual/development-pipeline.html#deployment) brings with it
- knows how to roll back to an older release if there are any issues
- knows [how to get help](https://docs.publishing.service.gov.uk/manual/ask-for-help.html) from someone with more access if they need it

### Production Admin access

- Permission to read & write [production](https://github.com/alphagov/govuk-secrets/blob/main/puppet_aws/hieradata/production_credentials.yaml) and [staging](https://github.com/alphagov/govuk-secrets/blob/main/puppet_aws/hieradata/staging_credentials.yaml) [hieradata](https://docs.publishing.service.gov.uk/manual/encrypted-hiera-data.html#what-to-do-when-someone-gets-production-access) in govuk-secrets using GPG
- Permission to read & write to the [password store](https://github.com/alphagov/govuk-secrets/tree/main/pass) in govuk-secrets store using [GPG](https://github.com/alphagov/govuk-secrets/blob/master/pass/2ndline/.gpg-id)
- Access to [Production Deploy Jenkins](https://deploy.blue.production.govuk.digital/) and [Staging Deploy Jenkins](https://deploy.blue.staging.govuk.digital/) to deploy applications via the [GOV.UK Production GitHub team](https://github.com/orgs/alphagov/teams/gov-uk-production)
- [SSH access](https://docs.publishing.service.gov.uk/manual/howto-ssh-to-machines.html) to production and staging servers via [govuk-puppet](https://github.com/alphagov/govuk-puppet)
- AWS [PowerUser Access](https://github.com/alphagov/govuk-aws-data/blob/master/data/infra-security/production/common.tfvars) via the `role_poweruser_user_arns` role
- [Google Cloud Platform (GCP)](/manual/google-cloud-platform-gcp.html) access to role to manage [static mirrors](/manual/fall-back-to-mirror.html) and DNS
- Signon "Super Admin" access in production
- `engineer` and "Access all services" permissions in Fastly
- GOV.UK PaaS [Space developer](https://docs.cloud.service.gov.uk/orgs_spaces_users.html#space-developer) and `Org manager`
  access to all spaces in the [govuk_development](https://admin.cloud.service.gov.uk/organisations/f8718311-b9a4-49d3-b1c7-7c5345a74e35) and [data-gov-uk](https://admin.cloud.service.gov.uk/organisations/39c3d2c5-8809-4dcf-8cd6-a8f62923a295/users) organisations
- [Sentry](https://sentry.io/settings/govuk/members/) "Manager" role to administer teams and people

The steps above are outlined in the [GOV.UK Production Admin template Trello card](https://trello.com/c/GIHPZi2o/382-production-admin-access-for-2nd-line), which is normally given whilst on 2nd line.

## When you get Production Admin access

- A minimum of BPSS (a blue building pass) security clearance
- Temporary supervised access during two Technical 2nd Line shadow shifts (GOV.UK developers only) and probation has been passed
- Permanent access once two 2nd line Shadow shifts have been completed
- You will be drafted into the 2nd line [on-call](https://docs.publishing.service.gov.uk/manual/on-call.html) rota after completing two Secondary in hour shifts

"Supervised" means "we trust you, but just be extra careful," and the dev should
ensure they're getting necessary and appropriate support from their team and
tech lead during this time. The tech lead of the mission team is responsible for
the supervision, whether it's by them or the team.

### What is temporary supervised Production Admin access?

Admin access to production may be granted to GDS civil servants or contractors who
don’t meet the criteria above for a time limited period. In these cases, we
require:

- A minimum of BPSS (a blue building pass) security clearance
- Approval from a Lead Developer or the Head of Technology
- Access to be removed at the end of the time limited period
- Supervision to be given by a production cleared person during access
- Agreement from the person that they will only use their access while supervised. We trust our staff to be sensible and operate within these rules.

## Temporarily revoking access

If you're absent more than 6 weeks, your access will be revoked. See [the Trello
leaver template card](https://trello.com/c/IQIV54Pc/378-leaver-name-here-tech-role)
for the steps.
