---
owner_slack: "#govuk-developers"
title: Configure a GitHub repo
parent: /manual.html
layout: manual_layout
section: GitHub
---

## When you create a new repo

- Give the [GOV.UK CI Bots][govuk-ci-bots-team] and [GOV.UK Production Admin][govuk-production-team] teams `Admin` access
- Give the [GOV.UK team][govuk-team] `Write` access
- Tag it with the [`govuk`][govuk-topic] topic

If your repo will be continuously deployed, restrict merge access to users with production deploy access with [the `repo_overrides.yml` file][repo-overrides].

## Auto configuration

When your repo is tagged with `govuk`, it will be auto-configured by [govuk-saas-config][], applying many of the rules below.

The govuk-saas-config job runs overnight, but you can kick off a build of the [GitHub Action workflow][] to trigger it sooner.

## Rules

Repositories in GOV.UK must:

- Have the [GOV.UK CI Bots][govuk-ci-bots-team] and [GOV.UK Production Admin][govuk-production-team] teams as `Admin`
- Give the [GOV.UK team][govuk-team] `Write` access
- Have a good description
- Link to relevant documentation
- Have the [`govuk`][govuk-topic] topic
- Have a [good README](/manual/readmes.html)
- Have an entry in [the list of repos](https://github.com/alphagov/govuk-developer-docs/blob/main/data/repos.yml)

Almost all repos should:

- Have [branch protection](https://help.github.com/articles/about-protected-branches) on `main`
- Have [GitHub Actions CI](/manual/test-and-build-a-project-with-github-actions.html) configured
- Have [GitHub Trello Poster](/manual/github-trello-poster.html) enabled

[GitHub Action workflow]: https://github.com/alphagov/govuk-saas-config/blob/163497868926ffe9d7c7d789fb79c5cf8026ab93/.github/workflows/configure-github.yml
[govuk-ci-bots-team]: https://github.com/orgs/alphagov/teams/gov-uk-ci-bots
[govuk-production-team]: https://github.com/orgs/alphagov/teams/gov-uk-production-admin
[govuk-saas-config]: https://github.com/alphagov/govuk-saas-config
[govuk-team]: https://github.com/orgs/alphagov/teams/gov-uk
[govuk-topic]: https://github.com/search?q=topic:govuk
[jenkins-job]: https://deploy.blue.production.govuk.digital/job/configure-github-repos
[repo-overrides]: https://github.com/alphagov/govuk-saas-config/blob/master/github/repo_overrides.yml
