---
owner_slack: "@tijmen"
title: Manage Ruby dependencies with Dependabot
section: Dependencies
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2017-12-05
review_in: 2 weeks
---

We're [obliged to keep our software current][current].

To help with this we're currently trialling a service called [Dependabot][] to perform automated dependency upgrades.

## Policies

- PRs from Dependabot are [considered to be from a external contributor][ext] and need 2 reviews
- You can ignore pull requests from the bot by replying `@dependabot ignore this major version`, but you have to add the PR to the [tech debt Trello board][tech-debt]

## Add Dependabot to a repo

1. Give Dependabot [access to the repo][access] (only GitHub org owners can do this)
2. Go to [Dependabot admin][admin] and click "Add project"

[ext]: https://github.com/alphagov/govuk-rfcs/blob/master/rfc-052-pull-request-merging-process.md#a-change-from-an-external-contributor
[tech-debt]: https://trello.com/c/tBEHwkI9/62-wip-out-of-date-dependencies
[access]: https://github.com/organizations/alphagov/settings/installations/64726
[current]: /manual/keeping-software-current.html
[Dependabot]: https://dependabot.com
[admin]: https://app.dependabot.com/accounts/alphagov/repos
