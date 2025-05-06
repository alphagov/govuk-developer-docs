---
owner_slack: "#govuk-developers"
title: Configure a new GOV.UK repository
parent: /manual.html
layout: manual_layout
section: GitHub
---

When creating a new GOV.UK repo in Github, you must:

- make a well-written README (see [READMEs for GOV.UK applications](/manual/readmes.html), or the [GDS Way guidance](https://gds-way.digital.cabinet-office.gov.uk/manuals/readme-guidance.html#writing-readmes) for general repositories)
- tag it with the [`govuk`](https://github.com/search?q=topic:govuk) topic
- add a licence following [Licensing Guidelines](https://gds-way.digital.cabinet-office.gov.uk/manuals/licensing.html#specifying-the-licence)
- add [Dependency Review](/manual/dependency-review.html) and [CodeQL](/manual/codeql.html) scans to its CI pipeline
- add it to the [repos.yml](https://github.com/alphagov/govuk-developer-docs/blob/main/data/repos.yml) file
- add it to [repos.yml in govuk-infrastructure](https://github.com/alphagov/govuk-infrastructure/blob/main/terraform/deployments/github/repos.yml). This:
  - applies [branch protection](https://help.github.com/articles/about-protected-branches) rules and configures PRs to be blocked on the outcome of the [GitHub Action CI](/manual/test-and-build-a-project-with-github-actions.html) workflow (if one exists)
  - restricts the merging of PRs for continuously deployed apps, so that only those with Production Deploy or Production Admin access can merge
  - enables vulnerability alerts and security fixes
  - sets up the webhook for [GitHub Trello Poster](/repos/github-trello-poster.html)
  - sets up the webhook for Slack integrations
  - sets some other default repo settings (e.g. delete branch on merge)

You'll then need to [plan and apply the GitHub workspace in Terraform Cloud](https://app.terraform.io/app/govuk/workspaces/GitHub/runs), which automatically updates the collaborators to the [default teams and access levels](https://github.com/alphagov/govuk-infrastructure/blob/83ff43c4e55f3d3273644e80897b58fd351f566a/terraform/deployments/github/main.tf#L76-L112).

 > If your repository access is sensitive, tag it with the [`govuk-sensitive-access`](https://github.com/search?q=topic:govuk-sensitive-access) topic to avoid this automation: you would then need to manually manage its collaborators.
