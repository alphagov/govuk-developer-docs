---
owner_slack: "#govuk-developers"
title: Configure a new GOV.UK repository
parent: /manual.html
layout: manual_layout
section: GitHub
---

## Create a new repository

If you are [creating a new rails app](/manual/setting-up-new-rails-app), there are tailored instructions to follow.

Otherwise these are the general steps to create when creating a new GOV.UK repository:

- First create and configure it by following the ["Creating and configuring a new repository" guidance][create-repo] in `govuk-infrastructure` repo.
  - _Note that when adding an existing repository (created in the GitHub UI) you will need to import it into terraform state._
- Make a well-written README (see [READMEs for GOV.UK applications](/manual/readmes.html), or the [GDS Way guidance][readmes] for general repositories)
- Add a licence following [Licensing Guidelines](https://gds-way.digital.cabinet-office.gov.uk/manuals/licensing.html#specifying-the-licence)

## Set up a GitHub repository for your App

All GitHub repositories belonging to GOV.UK must be [created and managed by Terraform](#run-terraform-to-create-your-repository).

If you have a pre-existing Git repository that is not managed by Terraform, it is possible to [import the repository to into Terraform](https://github.com/alphagov/govuk-infrastructure/blob/main/terraform/deployments/github/README.md#adding-existing-repositories) so that it can be managed. To do that you'll need to add an entry to `terraform/deployments/github/import.tf` in govuk-infrastructure with an entry similar to:

```
import {
  to = github_repository.govuk_repos["content-modelling-e2e"]
  id = "content-modelling-e2e"
}
```

If this file doesn't exist, you'll need to create it. See [example commit](https://github.com/alphagov/govuk-infrastructure/commit/c6774a7d42ca2eb9b0987a51cde8b57e13e0577f).

Alternatively, you can push the commit from your existing repository to the new repository using Git:

```shell
cd existing-repository/
git checkout main
git remote add new-repo "git@github.com:alphagov/new-repo.git"
git push new-repo main
```

To reset your local repository to point to the new remote repository in alphagov, you'll need to check out the new repository afresh and delete the original.

### Run terraform to create your repository

The general instructions for creating a repository via terraform can be found [here](https://github.com/alphagov/govuk-infrastructure/blob/main/terraform/deployments/github/README.md#creating-and-configuring-a-new-repository).

The key steps are:

1. Open a PR to add a new entry to the [repos.yml file in govuk-infrastructure](https://github.com/alphagov/govuk-infrastructure/blob/ddb95aa0470a21785759e5799cb16b2e6ab105bf/terraform/deployments/github/repos.yml). This is where key metadata is defined, including any workflow jobs that must pass in order to merge/deploy.

For example, an entry for a new Ruby on Rails application using reusable workflows could be:

```yaml
new-application:
   can_be_deployed: true
   required_pull_request_reviews:
     require_code_owner_reviews: true
   required_status_checks:
     standard_contexts: *standard_govuk_rails_checks
     additional_contexts:
       - Lint JavaScript / Run Standardx
       - Lint SCSS / Run Stylelint
       - Test JavaScript / Run Jasmine
       - Test Ruby / Run RSpec
```

> [!IMPORTANT]
> The workflow names must match the names of the workflows in the ci.yml file inside your app. For example, if you have a testing workflow named Test Ruby / Run RSpec, that must exactly match the app workflow or that step won’t run.

2. contact #govuk-platform-engineering for a review and, after the changes have been merged, to run Terraform.

The repository will be created and populated with required permissions and secrets.

## Add security scans to the CI pipeline

The following are mandatory for all repositories:

- [Dependency Review](https://docs.publishing.service.gov.uk/manual/dependency-review.html)
- [CodeQL](https://docs.publishing.service.gov.uk/manual/codeql.html)

Rails apps also require:

- [Brakeman](https://docs.publishing.service.gov.uk/manual/brakeman.html)
    - See [Example](https://github.com/alphagov/whitehall/blob/15738e4efbf4d7df113eb3590a5367b34f482ae3/.github/workflows/ci.yml#L13-L30)

## Add repository to GOV.UK Developer Docs

Add it to the [repos.yml](https://github.com/alphagov/govuk-developer-docs/blob/main/data/repos.yml) file in the GOV.UK Developer Docs

## Managing Deployment Access

GOV.UK no longer relies on the use of Github "topic" tags as a way to select and configure Deployment access, to prevent the following situations:

- Accidentally (or intentionally) granting Repositories access to deployment credentials.
- Removing the Github Search API as a "SPoF" (Single Point of Failure) for configuration errors.

By "rationalising" our Repository configuration, we are reducing our reliance on "magic" or poorly-understood processes and thus reducing risk. Instead, granting access to things like Deployment secrets should always be done explicitly through our `govuk-infrastructure` repository.

[create-repo]: https://github.com/alphagov/govuk-infrastructure/blob/main/terraform/deployments/github/README.md#creating-and-configuring-a-new-repository
[readmes]: https://gds-way.digital.cabinet-office.gov.uk/manuals/readme-guidance.html#writing-readmes
