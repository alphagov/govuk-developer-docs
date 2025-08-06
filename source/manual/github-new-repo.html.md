---
owner_slack: "#govuk-developers"
title: Configure a new GOV.UK repository
parent: /manual.html
layout: manual_layout
section: GitHub
---

When creating a new GOV.UK repo in Github, you should follow these steps:

## Configure the Repository in `govuk-infrastructure`

Firstly you should configure what you want your new Repository to look like by adding it to the `repos.yml` file the [govuk-infrastructure Repository](https://github.com/alphagov/govuk-infrastructure), within the "github" deployment directory.

The existing Repository configs should serve as good examples, but generally, these are the (known) supported properties:

```yaml
your-repo-name: # Set this to the Repo Name you wish to create
  allow_squash_merge: [false/true]
  branch_protection: [false/true] # Protects "main" branch (Default "true")
  can_be_deployed: [false/true] # Grant secrets to allow deployment and create a namesake ECR Repo
  homepage_url: [string] # Sets a URL for the "Homepage" Github Metadata Link
  need_production_access_to_merge: [false/true]
  pact_publisher: [false/true] # For Pact Test publishers (Default "false")
  publishes_gem: [false/true] # If the Repo publishes a Ruby Gem (Default "false")
  required_pull_request_reviews:
    pull_request_bypassers:
      - "/some-name-here"
    require_code_owner_reviews: [false/true]
  
  required_status_checks:
    standard_contexts: *anchor_name_of_standard_contexts
    additional_contexts: # List of Additional named Github Checks
      - Some Test Name
  
  strict: [false/true]
  teams:
    some_team_name: [read/triage/write/maintain/admin] # Set permissions as necessary.
  up_to_date_branches: [false/true]
  visibility: [public/internal/private] # (Default "public")
```

### Configuration Best Practices

When configuring and creating your Repo, you can change and override many of the default settings we apply for you.  
Generally, you will want to leave most of the defaults set, as this will:

- Apply [branch protection](https://help.github.com/articles/about-protected-branches) rules and configure PRs to be blocked on the outcome of your [GitHub Action CI](/manual/test-and-build-a-project-with-github-actions.html) workflow (if one exists)
- Restrict the merging of PRs for continuously deployed apps, so that only those with Production Deploy or Production Admin access can merge
- Enable vulnerability alerts and security fixes
- Set up the webhook for [GitHub Trello Poster](/repos/github-trello-poster.html)
- Set up the webhook for Slack integrations

Once you have configured the Repository in the YAML file as above, you will want to get this PR'd, reviewed, approved and merged.

You'll then need to [plan and apply the GitHub workspace in Terraform Cloud](https://app.terraform.io/app/govuk/workspaces/GitHub/runs), which automatically updates the collaborators to the [default teams and access levels](https://github.com/alphagov/govuk-infrastructure/blob/83ff43c4e55f3d3273644e80897b58fd351f566a/terraform/deployments/github/main.tf#L76-L112).

If you encounter errors, particularly if the Repo was created by hand (click-ops'd) before trying to manage it as code, then read on...

### Managing an Existing Repo through Terraform

If you want to add an existing Repo to Terraform, this is possible, however you will need to do the following things:

1. Add the Repo to `repos.yml` as above.

2. Import the Repo using the Terraform import block.

To do this, open the `main.tf` file in the `/github` Terrraform deployment and add the following:

```hcl
import {
  to = github_repository.govuk_repos["your-repo-name"]
  id = "your-repo-name"
}
```

You may also need to import the github_branch_protection resource as well, like this:

```hcl
import {
  to = github_branch_protection.govuk_repos["your-repo-name"]
  id = "your-repo-name:main"
}
```

Once these changes are done, open a PR, review, approve and merge. Then apply the Terraform again.

## Other Steps

Once your Repo is configured and created as above, you should follow these next steps:

- Make a well-written README (see [READMEs for GOV.UK applications](/manual/readmes.html), or the [GDS Way guidance](https://gds-way.digital.cabinet-office.gov.uk/manuals/readme-guidance.html#writing-readmes) for general repositories)
- Tag your Repo with the [`govuk`](https://github.com/search?q=topic:govuk) topic
- Add a licence following [Licensing Guidelines](https://gds-way.digital.cabinet-office.gov.uk/manuals/licensing.html#specifying-the-licence)
- Add [Dependency Review](/manual/dependency-review.html) and [CodeQL](/manual/codeql.html) scans to its CI pipeline
- Add it to the [repos.yml](https://github.com/alphagov/govuk-developer-docs/blob/main/data/repos.yml) file in the GOV.UK Developer Docs

 > If your repository access is sensitive, tag it with the [`govuk-sensitive-access`](https://github.com/search?q=topic:govuk-sensitive-access) topic to avoid this automation: you would then need to manually manage its collaborators.

## Managing Deployment Access

GOV.UK no longer relies on the use of Github "topic" tags as a way to select and configure Deployment access, to prevent the following situations:

* Accidentally (or intentionally) granting Repositories access to deployment credentials.
* Removing the Github Search API as a "SPoF" (Single Point of Failure) for configuration errors.

By "rationalising" our Repo configuration, we are reducing our reliance on "magic" or poorly-understood processes and thus reducing risk. Instead, granting access to things like Deployment secrets should always be done explicitly through our `govuk-infrastructure` repo.