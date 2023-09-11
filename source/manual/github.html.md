---
owner_slack: "#govuk-developers"
title: GitHub
parent: /manual.html
layout: manual_layout
section: GitHub
type: learn
---

GOV.UK uses GitHub for version control, code deployments, authentication, CI, Dependabot and GitHub Pages. Read the "[GOV.UK reliance on GitHub features doc](https://docs.google.com/document/d/1KsYWCHSQZEwqB2NF1A7Z9rmP1s1azcZhEamaPsXAoxk/edit)" Google doc for more information.

# GitHub organisation

Our GitHub organisation is called [alphagov](https://github.com/alphagov). We (GOV.UK) share it with other teams in the Government Digital Service (GDS).

The organisation is on the Enterprise Cloud plan, which grants us access to GitHub's enterprise support. Only [people with enterprise permissions](https://github.com/orgs/alphagov/people/enterprise_owners) can access enterprise support ([limited to enterprise owners and up to 20 additional members](https://docs.github.com/en/enterprise-cloud@latest/admin/managing-accounts-and-repositories/managing-users-in-your-enterprise/managing-support-entitlements-for-your-enterprise)).

[GDS GitHub Owners](https://groups.google.com/a/digital.cabinet-office.gov.uk/g/gds-github-owners) have superadmin access to alphagov. You can contact them to request changes to [organisation settings](https://docs.github.com/en/organizations/managing-organization-settings), or to request access to an inaccessible repository (e.g. one that was created by an ex-employee).

# GOV.UK teams

There are several GOV.UK GitHub teams within alphagov, including:

- [GOV.UK][team-govuk].
  Grants write access to GOV.UK repos, as well as integration admin access to the CI environment.

- [GOV.UK Production Deploy][team-govuk-production-deploy].
  Grants the ability to merge PRs against continuously deployed apps, and the ability to [deploy apps to staging and production](/manual/rules-for-getting-production-access.html#production-deploy-access)

- [GOV.UK Production Admin][team-govuk-production-admin].
  Grants admin access to GOV.UK repos, and [admin access to a number of other tools](/manual/rules-for-getting-production-access.html#production-admin-access).

- [GOV.UK Content Designers][team-govuk-content-designers].
  This team allows the user to create a branch in a GOV.UK repository and open a pull request, but only a developer can merge the request.
  Only content designers should be added to this team.

# Getting access to GitHub

Not everyone on GOV.UK requires GitHub access, as much of what we do is in the open. However, if your role requires it, you should be added to the org and the relevant team(s) through Terraform, in [govuk-user-reviewer][govuk-user-reviewer] - _not_ manually added through the GitHub UI itself, as this breaks the Terraform setup. Note that you will be sent an invitation email and will have to accept the invite before you are added to the organisation.

- If you're a content designer, ask for GitHub access via Zendesk (see [example ticket](https://govuk.zendesk.com/agent/tickets/5297731/events))
- If you're an engineer or contractor, ask your tech lead to follow the instructions in [govuk-user-reviewer][govuk-user-reviewer] to add you.
- If you don't have a tech lead, [ask someone in Senior Tech](https://groups.google.com/a/digital.cabinet-office.gov.uk/g/govuk-senior-tech-members/members) to add you. You must state
  - your role
  - which team you're in
  - your GitHub handle
  - which GitHub team(s) you should join ([see list](#govuk-teams))
  - why you need access

# GOV.UK repos

## Create and configure a new GOV.UK repo

When creating a new GOV.UK repo, you must ensure it:

- has a well written README (see [READMEs for GOV.UK applications](/manual/readmes.html), or the [GDS Way guidance](https://gds-way.cloudapps.digital/manuals/readme-guidance.html#writing-readmes) for general repositories)
- is tagged with the [`govuk`](https://github.com/search?q=topic:govuk) "topic"
- is added to the [repos.yml](https://github.com/alphagov/govuk-developer-docs/blob/main/data/repos.yml) file in the Developer Docs. We run a [daily script](https://github.com/alphagov/govuk-saas-config/blob/main/.github/workflows/verify-repo-tags.yml) to ensure that the Developer Docs' config is in sync with GitHub.
- grants the following access to GitHub teams:
  - [GOV.UK CI Bots][team-govuk-ci-bots]: Admin access
  - [GOV.UK Production Admin][team-govuk-production-admin]: Admin access
  - [GOV.UK team][team-govuk]: Write access

The team access currently needs applying manually, but [watch this space](https://trello.com/c/tbQjgkwR/3249-have-govuk-saas-config-grant-team-access-to-govuk-tagged-repos-3). The rest of the configuration is automated - see below.

## How GOV.UK automates its repository settings

We currently use two tools for this:

1. [govuk-saas-config](https://github.com/alphagov/govuk-saas-config/blob/main/github/lib/configure_repo.rb). This runs every night and:
  - Applies [branch protection](https://help.github.com/articles/about-protected-branches) rules and configures PRs to be blocked on the outcome of the [GitHub Action CI](/manual/test-and-build-a-project-with-github-actions.html) workflow (if one exists)
  - Retricts the merging of PRs for continuously deployed apps, so that only those with Production Deploy or Production Admin access can merge
  - Enables vulnerability alerts and security fixes
  - Sets up the webhook for [GitHub Trello Poster](/repos/github-trello-poster.html)
  - Sets some other default repo settings (e.g. delete branch on merge)
2. [govuk-infrastructure](https://github.com/alphagov/govuk-infrastructure/tree/main/terraform/deployments/github), which:
  - Gives permissions (to push to the ECR registry) to repositories that have specific tags

The fact that we have two tools for managing GitHub resources is [recognised as technical debt](https://trello.com/c/mojlsebq/226-we-have-two-tools-for-managing-github-resources). The hope is to consolidate the GitHub code from govuk-saas-config into govuk-infrastructure.

[govuk-user-reviewer]: https://github.com/alphagov/govuk-user-reviewer
[team-govuk]: https://github.com/orgs/alphagov/teams/gov-uk
[team-govuk-ci-bots]: https://github.com/orgs/alphagov/teams/gov-uk-ci-bots
[team-govuk-content-designers]: https://github.com/orgs/alphagov/teams/gov-uk-content-designers
[team-govuk-production-admin]: https://github.com/orgs/alphagov/teams/gov-uk-production-admin
[team-govuk-production-deploy]: https://github.com/orgs/alphagov/teams/gov-uk-production-deploy
