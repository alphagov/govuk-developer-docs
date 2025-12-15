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

You can either [create a repository using the GitHub UI](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-new-repository) or you can create the repository on your local machine first and [upload it to GitHub](https://docs.github.com/en/migrations/importing-source-code/using-the-command-line-to-import-source-code/adding-locally-hosted-code-to-github).

There are two ways to add a repository to alphagov. You can either:

1. [Run terraform to create your repository](#run-terraform-to-create-your-repository)
2. [Create a repository manually and import it into the alphagov organisation](#create-a-repository-manually-and-import-it-into-the-alphagov-organisation)

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

2. contact #govuk-platform-engineering for a review, and after the changes have been merged, to run Terraform.

The repository will be created and populated with required permissions and secrets.

### Create a repository manually and import it into the alphagov organisation

This approach is best used in scenarios where it’s not clear if the repository will become a permanent member of GOV.UK suite of repositories.

To create a repository manually and add the repository to the alphagov organisation you can either:

- Create it on your personal account first and [import into alphagov](https://github.com/new/import).

or

- Set up the [barebones app via UI in alphagov](https://github.com/organizations/alphagov/repositories/new) first and then populate it.

Once the repository has been created in GitHub you need to run the following to add it to GOV.UK infrastructure:

1. [Run terraform to create your repository](#run-terraform-to-create-your-repository)
    - The workflow names must match the names of the workflows in the ci.yml file inside your app. For example, if you have a testing workflow named Test Ruby / Run RSpec, that must exactly match the app workflow or that step won’t run.
2. [Import the repository to terraform](https://github.com/alphagov/govuk-infrastructure/blob/main/terraform/deployments/github/README.md#adding-existing-repositories) so that it can be managed in govuk-infrastructure.

## Add security scans to the CI pipeline

The followng are mandatory for all repositorys:

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
