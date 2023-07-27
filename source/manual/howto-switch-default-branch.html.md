---
owner_slack: "#govuk-developers"
title: How to switch a Git default branch from master to main
section: GitHub
layout: manual_layout
parent: "/manual.html"
---

These steps are for switching the default branch of a repo to `main`.

1. Rename the `master` branch in GitHub to `main` for that repo. See [instructions from Github for renaming an existing default branch](https://github.com/github/renaming#renaming-existing-branches).
1. Update the [Release app](https://release.publishing.service.gov.uk/applications/):
  - Go to the app entry from the [listing](https://release.publishing.service.gov.uk/applications/).
  - Hit the `Edit` tab.
  - Switch under the dropdown for `GitHub repository default branch`.
1. [Set the Jenkins build number](/manual/test-and-build-a-project-on-jenkins-ci.html#fixing-the-build-number)  (the last `master` build +1).
1. Rebuild the latest `main` branch build which would have started automatically by Jenkins when the branch was renamed, but with the incorrect build number (and therefore is likely to have failed).
1. [Switch your local branch](https://docs.github.com/en/github/administering-a-repository/renaming-a-branch#updating-a-local-clone-after-a-branch-name-changes), otherwise you might rebase the wrong branch by mistake!
1. Update the [list of apps on the Trello card](https://trello.com/c/xVhGGzOE/225-change-default-branch-to-main)

## Additional things to check

- Update [references in Jenkins to pulling down the `master` branch](https://github.com/alphagov/govuk-puppet/search?l=HTML%2BERB&q=master) of the app.
  See [example](https://github.com/alphagov/govuk-puppet/blob/master/modules/govuk_jenkins/templates/jobs/bouncer_cdn.yaml.erb).
- Update the Pact tests to run against the `main` branch
  - There are various places where we reference a `master` branch in the Pact tests. We'll need to remember to update these as we go through the various apps. Examples:
    - [collections](https://github.com/alphagov/collections/pull/2281#discussion_r576018353)
    - [gds-api-adapters](https://github.com/alphagov/gds-api-adapters/blob/ea45d4c1133a2a48b7bbfdc477b7880c330ec7b9/Jenkinsfile#L13-L17)
