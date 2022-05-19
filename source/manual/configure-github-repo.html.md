---
owner_slack: "#govuk-developers"
title: Configure a GitHub repo
parent: /manual.html
layout: manual_layout
section: GitHub
---

Repositories in GOV.UK must:

- Have the [GOV.UK CI Bots][govuk-ci-bots-team], [GOV.UK Production Deploy][govuk-production-deploy-team], and [GOV.UK Production][govuk-production-team] teams as `Admin`
- Have a good description
- Link to relevant documentation
- Have the [`govuk`][govuk-topic] topic
- Have a [good README](/manual/readmes.html)

Almost all repos should:

- Have [branch protection](https://help.github.com/articles/about-protected-branches) on `main`
- Have [Jenkins CI](/manual/test-and-build-a-project-on-jenkins-ci.html) configured, if the repo uses Jenkins
- Have [GitHub Trello Poster](/manual/github-trello-poster.html) enabled

[govuk-ci-bots-team]: https://github.com/orgs/alphagov/teams/gov-uk-ci-bots
[govuk-production-team]: https://github.com/orgs/alphagov/teams/gov-uk-production
[govuk-production-deploy-team]: https://github.com/orgs/alphagov/teams/gov-uk-production-deploy
[govuk-topic]: https://github.com/search?q=topic:govuk

## Auto configuration

When your repo is tagged with `govuk`, it will be auto-configured by [govuk-saas-config][]. This will take care of the settings, branch protection and web hooks.

When you create a new repo:

- Give the [GOV.UK CI Bots][govuk-ci-bots-team], [GOV.UK Production Deploy][govuk-production-deploy-team], and [GOV.UK Production][govuk-production-team] teams `Admin` access
- Give the [GOV.UK][govuk-team] `Write` access
- Tag it with the [`govuk`][govuk-topic] topic
- [Kick off a build of the Jenkins job][jenkins-job] to automate the rest

If your repo will be continuously deployed, restrict merge access to users with production deploy access with [the `repo_overrides.yml` file][repo-overrides].

[govuk-team]: https://github.com/orgs/alphagov/teams/gov-uk
[govuk-saas-config]: https://github.com/alphagov/govuk-saas-config
[jenkins-job]: https://deploy.blue.production.govuk.digital/job/configure-github-repos
[alphagov]: https://github.com/alphagov
[repo-overrides]: https://github.com/alphagov/govuk-saas-config/blob/master/github/repo_overrides.yml
