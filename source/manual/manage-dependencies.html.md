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

## Responsibility

Each service team is responsible for setting up and maintaining dependency management for their own repositories. This includes configuring Dependabot, reviewing and merging dependency PRs, and opting in to auto-merging where appropriate.

GOV.UK Platform Engineering can provide advice and additional tooling (such as [govuk-dependabot-merger](https://github.com/alphagov/govuk-dependabot-merger)) to support this, but the day-to-day ownership sits with the service team.

## Auto merging Dependabot PRs

According to the [National Cyber Security Centre](https://www.ncsc.gov.uk/collection/vulnerability-management/guidance/policy-update-by-default), we should apply updates as soon as possible, and ideally automatically.

To facilitate that, we have a [govuk-dependabot-merger](https://github.com/alphagov/govuk-dependabot-merger) service that can auto-merge certain Dependabot PRs, outlined in [RFC-167](https://github.com/alphagov/govuk-rfcs/blob/main/rfc-167-auto-patch-dependencies.md).

Repos that wish to opt in to this service must have a `.govuk_dependabot_merger.yml` file at the root of the repository, configured as per the govuk-dependabot-merger README instructions. They must then be added to the [repos_opted_in.yml](https://github.com/alphagov/govuk-dependabot-merger/blob/main/config/repos_opted_in.yml) list in govuk-dependabot-merger.

## Reviewing Dependabot PRs

Given the higher security risks associated with delaying updates, we should prioritize using the [auto merging tool](#auto-merging-dependabot-prs) whenever possible. However, in cases where that cannot be used or a PR needs manual reviewing, we should follow the instructions for reviewing Dependabot PRs:

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

It's crucial to acknowledge that the traditional human review process may not offer significant security benefits. Instead, we should prioritize comprehensive test coverage and security scanning as our primary safeguards.
RFC-167 [lists reasons](https://github.com/alphagov/govuk-rfcs/blob/main/rfc-167-auto-patch-dependencies.md#justification) why the above steps are not sufficient to detect malicious activity.

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

## Configuring Dependabot for your repository

The following are suggested configurations for `.github/dependabot.yml`. These are opinions, not rules. Adapt them to suit your project.

A good example to follow is the [govuk-frontend dependabot.yml](https://github.com/alphagov/govuk-frontend/blob/main/.github/dependabot.yml).

### Schedule and cooldown

A monthly schedule for version updates strikes a balance between staying current and not overwhelming reviewers. Pair this with a cooldown period so that Dependabot waits a few days after a version is published before raising a PR. This gives the community time to flag compromised or broken releases.

### Grouping

Group related dependencies (e.g. linting, testing, build tools) into a single PR rather than creating one PR per dependency.

### Example configurations

The following example covers Ruby, npm, Go and infrastructure tooling ecosystems in a single file. Most repositories will only need one or two of these.

```yaml
version: 2

updates:
  # Ruby (Bundler)
  - package-ecosystem: bundler
    directory: /
    schedule:
      interval: monthly
      time: "10:30"
      timezone: "Europe/London"
    cooldown:
      default-days: 3
    open-pull-requests-limit: 10
    allow:
      - dependency-type: direct
    groups:
      test:
        patterns:
          - "rspec"
          - "rspec-*"
          - "simplecov"
          - "webmock"
          - "factory_bot*"
      lint:
        patterns:
          - "rubocop"
          - "rubocop-*"

  # npm
  - package-ecosystem: npm
    directory: /
    schedule:
      interval: monthly
      time: "10:30"
      timezone: "Europe/London"
    cooldown:
      default-days: 3
    open-pull-requests-limit: 10
    allow:
      - dependency-type: direct
    groups:
      test:
        patterns:
          - "jest"
          - "jest-*"
          - "@types/jest"
      lint:
        patterns:
          - "eslint"
          - "eslint-*"
          - "prettier"
          - "standard"

  # Go modules
  - package-ecosystem: gomod
    directory: /
    schedule:
      interval: monthly
      time: "10:30"
      timezone: "Europe/London"
    cooldown:
      default-days: 3
    open-pull-requests-limit: 10
    allow:
      - dependency-type: direct

  # Terraform and infrastructure tooling
  - package-ecosystem: terraform
    directory: /
    schedule:
      interval: monthly
      time: "10:30"
      timezone: "Europe/London"
    cooldown:
      default-days: 7
    open-pull-requests-limit: 5

  # Docker base images
  - package-ecosystem: docker
    directory: /
    schedule:
      interval: monthly
      time: "10:30"
      timezone: "Europe/London"
    cooldown:
      default-days: 7

  # GitHub Actions
  - package-ecosystem: github-actions
    directory: /
    schedule:
      interval: monthly
      time: "10:30"
      timezone: "Europe/London"
    cooldown:
      default-days: 3
```

### Key choices explained

- **`interval: monthly`**: security updates are still raised immediately regardless of schedule.
- **`cooldown: default-days: 3`**: waits 3 days after a version is published before raising a PR. Infrastructure tooling (Terraform, Docker) uses 7 days, as these changes tend to carry more risk.
- **`allow: dependency-type: direct`**: only updates top-level dependencies, not transitive ones.
- **`groups`**: bundles related dependencies (e.g. all RuboCop gems) into a single PR. Tailor these to the libraries your project actually uses.
- **`open-pull-requests-limit`**: the default is 5, which is easy to hit if you have a few dependencies that can't be auto-merged. A low cap has contributed to past incidents where security updates were blocked by the limit. We recommend setting this to at least 10 (see [alphagov/whitehall#11286](https://github.com/alphagov/whitehall/pull/11286) for prior art).

## Security

We've [set up branch protection](/manual/github.html) for all repos with the `govuk` label. This prevents Dependabot from writing directly to main.

## Further reading

### Supply chain incidents and threat landscape

- [tj-actions/changed-files compromise (March 2025)](https://emmer.dev/blog/pin-your-github-actions-to-protect-against-mutability/) — A detailed post-mortem on the incident that affected 23,000+ repositories. Illustrates why mutable Git tags are a structural risk.
- [RFC-167: Auto-patch dependencies](https://github.com/alphagov/govuk-rfcs/blob/main/rfc-167-auto-patch-dependencies.md) — GOV.UK's own rationale for why traditional manual review is insufficient against supply chain compromise.
- [GitHub Actions has a package manager, and it might be the worst](https://nesbitt.io/2025/12/06/github-actions-package-manager.html) — A critical analysis of the structural gaps in GitHub Actions' dependency model, particularly around transitive dependencies and the absence of a lockfile.

### Defensive practices

- [Best practices for handling credentials](/manual/best-practices-for-handling-credentials.html) — GOV.UK guidance on protecting credentials on developer workstations from supply chain malware, covering Git, AWS, GCP and local secrets. Written in response to the September 2025 npm malware incident.
- [GitHub Docs: Secure use reference for GitHub Actions](https://docs.github.com/en/actions/reference/security/secure-use) — The canonical GitHub guidance on securing workflows, including SHA pinning, minimum token permissions, and dependency review.
- [GitHub Actions policy: blocking and SHA pinning](https://github.blog/changelog/2025-08-15-github-actions-policy-now-supports-blocking-and-sha-pinning-actions/) — August 2025 changelog covering new org-level controls for blocking specific actions and enforcing SHA pinning as policy.
- [Pin your GitHub Actions to protect against supply chain attacks](https://emmer.dev/blog/pin-your-github-actions-to-protect-against-mutability/) — Practical guide to SHA pinning, including Renovate's `helpers:pinGitHubActionDigestsToSemver` preset as an alternative to Dependabot for managing pinned SHAs.
- [zizmor](https://github.com/woodruffw/zizmor) — Static analysis tool for GitHub Actions workflows. Scans for security issues including over-privileged tokens, injection vulnerabilities, and unpinned actions.

### GitHub's 2026 security roadmap

- [What's coming to GitHub Actions 2026 security roadmap](https://github.blog/news-insights/product-news/whats-coming-to-our-github-actions-2026-security-roadmap/) — Covers the forthcoming `dependencies:` lockfile for workflows (analogous to `go.sum`), actor/event rules, and broader supply chain hardening. Directly relevant to where Dependabot integration is heading.

### Build provenance and SLSA

- [GitHub Artifact Attestations](https://docs.github.com/en/actions/concepts/security/artifact-attestations) — How to generate cryptographically verifiable build provenance. Relevant if any GOV.UK pipeline publishes deployable artefacts.
- [SLSA framework](https://slsa.dev) — The Supply-chain Levels for Software Artifacts framework from OpenSSF. Provides a progression from basic provenance (Level 1) to hardened, tamper-resistant build platforms (Level 3).

### NCSC guidance

- [NCSC: Vulnerability management — apply updates by default](https://www.ncsc.gov.uk/collection/vulnerability-management/guidance/policy-update-by-default) — The underpinning policy rationale for automatic dependency updates referenced in this document.
