---
owner_slack: "#govuk-2ndline-tech"
title: GitHub access
parent: "/manual.html"
layout: manual_layout
section: Accounts
---

## Do you need GitHub access?

Not everyone on GOV.UK requires GitHub access, as much of what we do is in the open. However, if your role requires it, you can be added to the alphagov org.

If you're a content designer, your request should go through Zendesk (see [example ticket](https://govuk.zendesk.com/agent/tickets/5297731/events)).

If you're an engineer or contractor, ask your tech lead to follow the steps below. If you don't have a tech lead, ask in the [Technical 2nd Line Slack channel](https://gds.slack.com/archives/CADKZN519) for them to add you. You must state:

- your role
- which team you're in
- your GitHub handle
- why you need access

## Granting GitHub access

These steps should only be completed by a developer with production access:

1. Add the person to the relevant file in [govuk-user-reviewer](https://github.com/alphagov/govuk-user-reviewer).
1. Email <govuk-github-owners@digital.cabinet-office.gov.uk>, asking for the person to be added to the org. You should include:
  1. A link to the pull request created in the previous step.
  1. The GitHub username to be added.
  1. The name of the team they should be added to (see [Teams in alphagov](#teams-in-alphagov)). This is usually "GOV.UK" for engineers and contractors, and "GOV.UK Content Designers" for content designers.
  1. An explanation of which team the person is working in, and in what role.
1. An alphagov admin will process the request. The person will receive an invite from GitHub in their inbox, which they will have to accept.

## Teams in alphagov

There are several core 'teams' set up in GitHub, under the [alphagov org](https://github.com/orgs/alphagov).

- [GOV.UK Content Designers](https://github.com/orgs/alphagov/teams/gov-uk-content-designers/members).
  This team allows the user to create a branch in a GOV.UK repository and open a pull request, but only a developer can merge the request.
  Only content designers should be added to this team.

- [GOV.UK](https://github.com/orgs/alphagov/teams/gov-uk).
  This team gives write access to private repos (see [Configure a GitHub repo](/manual/configure-github-repo.html)), as well as integration admin access to the CI environment.

- [GOV.UK Production Deploy](https://github.com/orgs/alphagov/teams/gov-uk-production-deploy).
  Grants [deploy access to staging and production](/manual/rules-for-getting-production-access.html#production-deploy-access).

- [GOV.UK Production Admin](https://github.com/orgs/alphagov/teams/gov-uk-production-admin).
  Grants [admin access to staging and production](/manual/rules-for-getting-production-access.html#production-admin-access).
