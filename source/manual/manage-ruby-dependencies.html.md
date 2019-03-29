---
owner_slack: "#govuk-developers"
title: Manage Ruby dependencies with Dependabot
description: How we manage our Ruby dependencies using Dependabot, who can merge PRs and security
section: Dependencies
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-09-03
review_in: 6 months
---

We're [obliged to keep our software current][current].

To help with this, we use a service called [Dependabot][] to perform automated dependency upgrades.

## Who can merge Dependabot PRs

- GOV.UK-owned gems (govuk_app_config, govspeak for example) need 1 reviewer
- Gems found in the `test` block in the `Gemfile` (Capybara for example) need 1 reviewer
- All other gems (Rails for example) are [considered to be from a external contributor][ext] and need 2 reviews

You can ignore pull requests from the bot by replying `@dependabot ignore this major version`, but you have to add the PR to the [tech debt Trello board][tech-debt]

If a PR contains a mixture of GOV.UK-owned gems and other gems (which are not solely included in the `test` block of the Gemfile), it will need 2 reviews.

## Add Dependabot to a repo

1. Give Dependabot [access to the repo][access] (only GitHub org owners can do this)
2. Go to [Dependabot admin][admin] and click "Add project"

## Ask Dependabot to bump dependencies

By default Dependabot will bump dependencies once a day, but you can ask it to bump manually:

Go to [Dependabot admin][admin] and click "Bump now" for your project

## Security

There are 2 safeguards to prevent unauthorised code changes. Firstly, Dependabot can only update the repositories that we [explicitly allow on GitHub][access]. This prevents code changes to other repos. Secondly, we've [set up branch protection](/manual/configure-github-repo.html#auto-configuration) for all repos with the `govuk` label. This prevents Dependabot from writing directly to master.

[ext]: https://docs.publishing.service.gov.uk/manual/merge-pr.html
[tech-debt]: https://trello.com/b/oPnw6v3r
[access]: https://github.com/organizations/alphagov/settings/installations/87197
[current]: /manual/keeping-software-current.html
[Dependabot]: https://dependabot.com
[admin]: https://app.dependabot.com/accounts/alphagov/repos
