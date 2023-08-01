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

When reviewing a Dependabot PR you should do the following as a minimum:

- Expand the "Release notes" or "Changelog" details.
  - Click on the link to the `CHANGELOG` file (if there is one).
  - Read the additions to the file to find out about any breaking changes or upgrade instructions.
  - Take extra care when this is a 'major' upgrade, e.g. `2.1.0` => `3.0.0`.

If this is the first update the dependency has had in a while, or if this is an unfamiliar dependency that perhaps has a solo maintainer, you'll want to take extra due diligence in your review:

- Expand the "Commits" details
  - Click on the "compare view" link.
  - Verify that the version bump in the repo matches the one for the PR.
  - Review the code, not necessarily in a huge amount of depth, but looking for anything odd or potentially risky (e.g. use of `eval`, encoded strings, HTTP requests to non-GOV.UK domains, etc).
- Find the package in the equivalent package hosting website, e.g. [Rubygems](https://rubygems.org/)
  - Verify that the 'Homepage' or 'Source Code' links refer back to the git repository you've been reviewing the diff on.
  - Verify that the version in the PR also exists in the package hosting website.
- You may want to verify the author of the version bump commit is a regular contributor to the repo.
- If in doubt, get a second opinion from Senior Tech.

For these reasons we’re not planning to enable auto-merge for Dependabot PRs for external dependencies.

### Managing Dependabot

#### Add Dependabot to a repo

Any GOV.UK developer with production access can enable GitHub for a repo.

1. Navigate to the repo on GitHub, click "Insights".
1. Choose the "Dependency graph" menu item.
1. Select the "Dependabot" tab.
1. Click "Enable Dependabot".
1. To configure Dependabot, a PR will need to be created that adds a configuration file. In [RFC #126](https://github.com/alphagov/govuk-rfcs/blob/main/rfc-126-custom-configuration-for-dependabot.md#custom-configuration) it was decided that a custom configutation would be used for GOV.UK applications. Once you have written a `.github/dependabot.yml` configuration file, create a pull request and merge this into the repo. Dependabot will automatically run following the merge.

#### Ask Dependabot to bump dependencies

By default Dependabot will bump dependencies at the frequency specified in the configuration file, but you can ask it to bump manually:

Go to your project in GitHub and click on "Insights", then "Dependency graph", then "Dependabot", then "Last checked X minutes ago" next to the package manager of choice (e.g. Gemfile). Then you can click "Check for updates".

#### Audit Dependabot PRs

We have the [seal][app] to monitor outstanding Dependabot PRs on GDS repos.

### Security

There are 2 safeguards to prevent unauthorised code changes. Firstly, Dependabot can only update the repositories that we [explicitly allow on GitHub][access]. This prevents code changes to other repos. Secondly, we've [set up branch protection](/manual/github.html) for all repos with the `govuk` label. This prevents Dependabot from writing directly to main.

[RFC 126]: https://github.com/alphagov/govuk-rfcs/blob/main/rfc-126-custom-configuration-for-dependabot.md
[ext]: /manual/merge-pr.html
[access]: https://github.com/organizations/alphagov/settings/installations/87197
[current]: /manual/keeping-software-current.html
[Dependabot]: https://dependabot.com
[admin]: https://app.dependabot.com/accounts/alphagov/repos
[app]: /repos/seal.html
