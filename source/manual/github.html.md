---
owner_slack: "#govuk-developers"
title: How GOV.UK uses GitHub
parent: /manual.html
layout: manual_layout
section: GitHub
type: learn
---

GOV.UK uses GitHub for version control, code deployments, authentication, CI, Dependabot and GitHub Pages. Read the "[GOV.UK reliance on GitHub features doc](https://docs.google.com/document/d/1KsYWCHSQZEwqB2NF1A7Z9rmP1s1azcZhEamaPsXAoxk/edit)" Google doc for more information.

You must follow [these instructions when creating and configuring a new GOV.UK repository](/manual/github-new-repo).

## Our GitHub organisation

Our GitHub organisation is called [alphagov](https://github.com/alphagov). GOV.UK shares it with other teams in the Government Digital Service (GDS).

The organisation is on the Enterprise Cloud plan, which grants us access to GitHub's enterprise support. Only [people with enterprise permissions](https://github.com/orgs/alphagov/people/enterprise_owners) can access enterprise support ([limited to enterprise owners and up to 20 additional members](https://docs.github.com/en/enterprise-cloud@latest/admin/managing-accounts-and-repositories/managing-users-in-your-enterprise/managing-support-entitlements-for-your-enterprise)).

[GDS GitHub Owners](https://groups.google.com/a/digital.cabinet-office.gov.uk/g/gds-github-owners) have superadmin access to alphagov. You need to contact them to request changes to [organisation settings](https://docs.github.com/en/organizations/managing-organization-settings), or to request access to an inaccessible repository (e.g. one that was created by an ex-employee).

## GOV.UK teams in Github

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

## Getting access to GitHub

If your role requires access to Github, you'll need to be added to the organisation and the relevant team(s) through Terraform, in [govuk-user-reviewer][govuk-user-reviewer] - _not_ manually added through the GitHub UI itself, as this breaks the Terraform setup. Note that you will have to accept the invite sent via email before you're added to the organisation.

- If you're an engineer or contractor, ask your tech lead to add you by following the instructions in [govuk-user-reviewer][govuk-user-reviewer].
- If you don't have a tech lead, [ask someone in Senior Tech](/manual/ask-for-help.html#contact-senior-tech) to add you.
- If you're a content designer, ask for GitHub access via Zendesk (see [example ticket](https://govuk.zendesk.com/agent/tickets/5812930)). Make sure you include the `govuk_platform_support` tag.

In these last two cases, you must state:

- your role
- which team you're in
- why you need access
- your GitHub username
- which GitHub team(s) you should join ([see list](#gov-uk-teams-in-github))

## Removing access to GitHub

Users are removed from the GitHub organisation when their entry in [govuk-user-reviewer][govuk-user-reviewer] is deleted.

[govuk-user-reviewer]: https://github.com/alphagov/govuk-user-reviewer
[team-govuk]: https://github.com/orgs/alphagov/teams/gov-uk
[team-govuk-ci-bots]: https://github.com/orgs/alphagov/teams/gov-uk-ci-bots
[team-govuk-content-designers]: https://github.com/orgs/alphagov/teams/gov-uk-content-designers
[team-govuk-production-admin]: https://github.com/orgs/alphagov/teams/gov-uk-production-admin
[team-govuk-production-deploy]: https://github.com/orgs/alphagov/teams/gov-uk-production-deploy
