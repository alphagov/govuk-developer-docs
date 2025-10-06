---
owner_slack: "#govuk-developers"
title: Configure a new GOV.UK repository
parent: /manual.html
layout: manual_layout
section: GitHub
---

When creating a new GOV.UK repo in Github, you should follow these steps:

- First create and configure it by following the ["Creating and configuring a new repository" guidance][create-repo] in `govuk-infrastructure` repo.
  - _Note that when adding an existing repository (created in the GitHub UI) you will need to import it into terraform state._
- Make a well-written README (see [READMEs for GOV.UK applications](/manual/readmes.html), or the [GDS Way guidance][readmes] for general repositories)
- Add a licence following [Licensing Guidelines](https://gds-way.digital.cabinet-office.gov.uk/manuals/licensing.html#specifying-the-licence)
- Add [Dependency Review](/manual/dependency-review.html) and [CodeQL](/manual/codeql.html) scans to its CI pipeline
- Add it to the [repos.yml](https://github.com/alphagov/govuk-developer-docs/blob/main/data/repos.yml) file in the GOV.UK Developer Docs

## Managing Deployment Access

GOV.UK no longer relies on the use of Github "topic" tags as a way to select and configure Deployment access, to prevent the following situations:

- Accidentally (or intentionally) granting Repositories access to deployment credentials.
- Removing the Github Search API as a "SPoF" (Single Point of Failure) for configuration errors.

By "rationalising" our Repo configuration, we are reducing our reliance on "magic" or poorly-understood processes and thus reducing risk. Instead, granting access to things like Deployment secrets should always be done explicitly through our `govuk-infrastructure` repo.

[create-repo]: https://github.com/alphagov/govuk-infrastructure/blob/main/terraform/deployments/github/README.md#adding-existing-repositories
[readmes]: https://gds-way.digital.cabinet-office.gov.uk/manuals/readme-guidance.html#writing-readmes
