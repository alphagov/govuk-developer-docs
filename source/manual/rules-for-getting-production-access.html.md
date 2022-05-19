---
owner_slack: "#govuk-2ndline-tech"
title: Rules for getting production access
parent: "/manual.html"
layout: manual_layout
section: 2nd line
type: learn
---

These rules apply to developers, SREs, and technical architects in the GOV.UK programme.

## What production access means

- Permission to [read & write production and staging hieradata](https://github.com/alphagov/govuk-secrets/blob/main/puppet_aws/hieradata/production_credentials.yaml) in govuk-secrets using GPG
- Permission to read & write from the Pass in govuk-secrets store using [GPG](https://github.com/alphagov/govuk-secrets/blob/master/pass/2ndline/.gpg-id)
- Access to Production Deploy Jenkins and Staging Deploy Jenkins to deploy applications via the [GOV.UK Production GitHub team](https://github.com/orgs/alphagov/teams/gov-uk-production)
- SSH access to production and staging servers via [govuk-puppet](https://github.com/alphagov/govuk-puppet)
- AWS [PowerUser Access](https://github.com/alphagov/govuk-aws-data/blob/master/data/infra-security/production/common.tfvars) via the `role_poweruser_user_arns` role
- [Google Cloud Platform (GCP)](/manual/google-cloud-platform-gcp.html) access to role to manage [static mirrors](/manual/fall-back-to-mirror.html) and DNS
- Signon "Super Admin" access in production
- GOV.UK PaaS [Space developer](https://docs.cloud.service.gov.uk/orgs_spaces_users.html#space-developer)
  access to all spaces in [the govuk_development organisation](https://admin.cloud.service.gov.uk/organisations/f8718311-b9a4-49d3-b1c7-7c5345a74e35)

## When you get production access

- Temporary supervised access during two Technical 2nd Line shadow shifts (GOV.UK developers only)
- Supervised access during the second shadow shift and probation has been passed
- A minimum of BPSS (a blue building pass) security clearance
- Permanent access once two shadow shifts have been completed

"Supervised" means "we trust you, but just be extra careful," and the dev should
ensure they're getting necessary and appropriate support from their team and
tech lead during this time. The tech lead of the mission team is responsible for
the supervision, whether it's by them or the team.

### What is temporary supervised production access?

Access to production may be granted to GDS civil servants or contractors who
don’t meet the criteria above for a time limited period. In these cases, we
require:

- A minimum of BPSS (a blue building pass) security clearance
- Approval from a Lead Developer or the Head of Technology
- Access to be removed at the end of the time limited period
- Supervision to be given by a production cleared person during access
- Agreement from the person that they will only use their access while supervised. We trust our staff to be sensible and operate within these rules.

## Temporarily revoking access

If you're absent more than 6 weeks, your access will be revoked.
