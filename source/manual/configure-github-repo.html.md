---
title: Configure a GitHub repo
parent: /manual.html
layout: manual_layout
section: Tools
owner_slack: "#2ndline"
last_reviewed_on: 2017-10-05
review_in: 6 months
---

Repositories in GOV.UK must:

- Have the [GOV.UK team][team] as `Admin`
- Have a good description
- Link to relevant documentation
- Be tagged with [`govuk`](https://github.com/search?q=topic:govuk)
- Have a [good README](/manual/readmes.html)

Almost all repos should:

- Have [branch protection](https://help.github.com/articles/about-protected-branches) on master
- Have [Jenkins CI](/manual/testing-projects.html) configured
- Have [GitHub Trello Poster](https://github.com/emmabeynon/github-trello-poster) enabled

[team]: https://github.com/orgs/alphagov/teams/gov-uk/members

## Auto configuration

When your repo is tagged with `govuk`, it will be auto-configured by [govuk-saas-config][]. This will take care of the settings, branch protection and web hooks.

If you create a new repo [kick off a build of the Jenkins job][jj] and everything will be done for you.

[govuk-saas-config]: https://github.com/alphagov/govuk-saas-config/tree/master/github
[jj]: https://deploy.integration.publishing.service.gov.uk/job/configure-github-repos
[alphagov]: https://github.com/alphagov
