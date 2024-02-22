---
owner_slack: "#govuk-developers"
title: Manage dependencies with Dependabot
description: How we manage our dependencies using Dependabot, including setup, automation and how to review dependency update PRs.
section: Dependencies
layout: manual_layout
parent: "/manual.html"
---

We're [obliged to keep our software current](/manual/keeping-software-current.html). To help with this, we use a
service called Dependabot (by GitHub) to open automated dependency upgrade PRs, and we use an in-house tool called the [Seal](/repos/seal.html) to notify us of Dependabot PRs that have not yet been merged. We also have an in-house tool, [govuk-dependabot-merger](https://github.com/alphagov/govuk-dependabot-merger), for automatically merging [certain Dependabot PRs](#auto-merging-dependabot-prs).

## Reviewing Dependabot PRs

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

## Managing Dependabot

### Add Dependabot to a repo

Any GOV.UK developer with production access can enable GitHub for a repo.

1. Navigate to the repo on GitHub, click "Insights".
1. Choose the "Dependency graph" menu item.
1. Select the "Dependabot" tab.
1. Click "Enable Dependabot".

To configure Dependabot, a PR will need to be created that adds a configuration file (`.github/dependabot.yml`). In [RFC #126](https://github.com/alphagov/govuk-rfcs/blob/main/rfc-126-custom-configuration-for-dependabot.md#custom-configuration) it was decided that a custom configuration would be used for GOV.UK applications, but this inadvertently disabled some security updates, so was reversed in [RFC-153](https://github.com/alphagov/govuk-rfcs/blob/main/rfc-153-remove-allowlists-from-dependabot-configs.md), and configuration is now largely limited to specifying the package ecosystem and schedule ([example](https://github.com/alphagov/support-api/blob/070b2f3f8f97e5c3c7a21ec126e42bde54b89e6a/.github/dependabot.yml)).

### Ask Dependabot to bump dependencies

By default Dependabot will bump dependencies at the frequency specified in the configuration file, but you can ask it to bump manually:

Go to your project in GitHub and click on "Insights", then "Dependency graph", then "Dependabot", then "Last checked X minutes ago" next to the package manager of choice (e.g. Gemfile). Then you can click "Check for updates".

## Auto merging Dependabot PRs

We have a [govuk-dependabot-merger](https://github.com/alphagov/govuk-dependabot-merger) service that can auto-merge certain Dependabot PRs, outlined in [RFC-156](https://github.com/alphagov/govuk-rfcs/blob/main/rfc-156-auto-merge-internal-prs.md).

Repos that wish to opt in to this service must have a `.govuk_dependabot_merger.yml` file at the root of the repository, configured as per the govuk-dependabot-merger README instructions. They must then be added to the [repos_opted_in.yml](https://github.com/alphagov/govuk-dependabot-merger/blob/main/config/repos_opted_in.yml) list in govuk-dependabot-merger.

## Security

We've [set up branch protection](/manual/github.html) for all repos with the `govuk` label. This prevents Dependabot from writing directly to main.
