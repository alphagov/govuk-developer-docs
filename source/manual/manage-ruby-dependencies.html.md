---
owner_slack: "#govuk-developers"
title: Manage Ruby dependencies with Dependabot
description: How we manage our Ruby dependencies using Dependabot, who can merge PRs and security
section: Dependencies
layout: manual_layout
parent: "/manual.html"
---

We're [obliged to keep our software current][current]. To help with this, we use a
service called [Dependabot][] to perform automated dependency upgrades.

[RFC 126][] describes the custom configuration we have for Dependabot to reduce the
number of PRs it opens, and therefore the number of deployments and effort required to
keep our apps up to date.

### Reviewing Dependabot PRs

Dependabot updates occur relatively soon after a new version is published, which means
there’s a risk of updating to a rogue version. Some updates also contain breaking
changes, irrespective of when they are published.

When reviewing a Dependabot PR you should do the following:

- Check the `CHANGELOG` for any breaking changes or upgrade instructions.

- Use "See full diff in compare view" to verify the version bump in the repo matches
  the one for the PR, from RubyGems.

- Verify the author of the version bump commit is a regular contributor to the repo,
  and otherwise review the commits in more detail.

For these reasons we’re not planning to enable auto-merge for Dependabot PRs.

### Managing Dependabot

#### Add Dependabot to a repo

1. Give Dependabot [access to the repo][access] (only GitHub org owners can do this)
1. Go to [Dependabot admin][admin] and click "Add project"

#### Ask Dependabot to bump dependencies

By default Dependabot will bump dependencies once a day, but you can ask it to bump manually:

Go to [Dependabot admin][admin] and click "Bump now" for your project

#### Audit Dependabot PRs

We have the [govuk-dependencies app][app] to monitor outstanding Dependabot PRs on govuk repos.

### Security

There are 2 safeguards to prevent unauthorised code changes. Firstly, Dependabot can only update the repositories that we [explicitly allow on GitHub][access]. This prevents code changes to other repos. Secondly, we've [set up branch protection](/manual/configure-github-repo.html#auto-configuration) for all repos with the `govuk` label. This prevents Dependabot from writing directly to master.

[RFC 126]: https://github.com/alphagov/govuk-rfcs/blob/master/rfc-126-custom-configuration-for-dependabot.md
[ext]: https://docs.publishing.service.gov.uk/manual/merge-pr.html
[access]: https://github.com/organizations/alphagov/settings/installations/87197
[current]: /manual/keeping-software-current.html
[Dependabot]: https://dependabot.com
[admin]: https://app.dependabot.com/accounts/alphagov/repos
[app]: /apps/govuk-dependencies.html
