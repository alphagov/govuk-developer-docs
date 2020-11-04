---
owner_slack: "#govuk-developers"
title: Make a GitHub repo private
parent: /manual.html
layout: manual_layout
section: GitHub
---

In cases of an ongoing security incident, or when working on politically sensitive changes, we may want to work in private rather than public. We do this by creating a private fork of the application.

## Creating a private fork

To fork an existing GOV.UK repository and make it private perform the following steps:

1. Visit <https://github.com/alphagov> and click the green 'New' button to create a new repository.
1. Click on the 'import repository' link to import the existing repository.
1. Change the owner to `alphagov`.
1. Set the repository name to the new private name.
1. Set the 'Privacy' setting to 'Private'.
1. Start the import. This may take a while to complete.
1. Click on 'Settings' and then 'Collaborators' to set the permissions on the repository.
1. Add the 'GOV.UK - CI Bots' team so that Jenkins can access the repository for deployment. Make sure it is set to 'write' access because Jenkins needs to access the repository and set the release tag.
1. Add the 'gov-uk' team and set it 'write' access so that developers can create and merge pull requests.
1. Consider adding [a GitHub action](https://github.com/search?q=org%3Aalphagov+%22Use+GitHub+Actions%22&type=Issues) to replace Jenkins CI that will not be running on this new repo.
1. Add a branch protection rule against the master branch. You can [use the settings in another repo](https://github.com/alphagov/government-frontend/settings/branches) as a template.

## Deploying the private repository

### Update govuk-app-deployment

To deploy a private repository, first create a private fork of the `govuk-app-deployment` repository named `govuk-app-deployment-private`.

In the `govuk-app-deployment-private` repository there is a directory for each app in GOV.UK that can be deployed. Find the directory of the app you want to make private and edit the file `<app>/config/deploy.rb` to add a line to set the name of the private repository. For example, for ‘frontend’ add line 2:

```ruby
set :application, "frontend"
set :repo_name, "frontend-private"
```

### Update Jenkins

Perform these actions on staging first, before rolling out to production.

In the relevant environment, disable Puppet on the Jenkins machine, otherwise Puppet will overwrite your changes.  This can be done by SSHing into the Jenkins machine:

```
$ gds govuk connect -e <environment> ssh jenkins
$ govuk_puppet --disable
```

Jenkins must be updated to use the private version of `govuk-app-deployment` so the private version of the app is deployed.  This is done by navigating to the Jenkins UI in your web browser, clicking the 'Configure' link and changing the 'Build' section:

From:

```
export APP_DEPLOYMENT_GIT_URL="git@github.com:alphagov/govuk-app-deployment.git"
```

To:

```
export APP_DEPLOYMENT_GIT_URL="git@github.com:alphagov/govuk-app-deployment-private.git"
```

The app can now be deployed as normal.

After deployment is complete, Puppet can be re-enabled:

```
$ gds govuk connect -e <environment> ssh jenkins
$ govuk_puppet --enable
```

### Testing in private

We do not have CI builds on our private repos by default. To mitigate the risks of this, you can either:

- Add [a GitHub Action](/manual/test-and-build-a-project-with-github-actions.html) to do these things for you
- Or, run the following manual steps locally before pushing:

```
bundle exec rubocop # run the linter
RAILS_ENV=production bundle exec rake assets:precompile # make sure production assets compilation works
bundle exec rake # run all the tests
```

## Keeping repositories in sync

As part of our workflow we will need to keep our private repositories in sync with the public ones. To do this we need to open a terminal, enter the directory of the private repository we want to sync up and add an ‘upstream’ remote.

```
$ git remote add upstream https://github.com/alphagov/frontend.git
```

We can now fetch commits from the upstream public repository and pull them in a new branch which can be merged into master through the usual Pull Request workflow.

```
$ git fetch upstream
$ git diff upstream/master master # check if we need to rebase at all
$ git checkout -b update
$ git pull upstream master
$ git push origin update
```

## Reverting to public

In order to make our private changes public, we need to incorporate them into the public repo.

1. Make sure you have pulled in the latest changes from the public repo into the private repo (detailed in 'Keeping repositories in sync').
1. Merge any pending pull requests into the master branch of the private repo.
1. On the public repo, add the private repo as a new upstream remote: e.g. `git remote add upstream https://github.com/alphagov/frontend-private.git`
1. Create a new branch on the public repo.
1. Rebase the master branch of the private repo onto the new branch:
1. `git fetch upstream`
1. `git rebase upstream/master`
1. `git rebase master`
1. Raise a PR on the public repo for the new branch.
1. Delete the private fork, once the changes have been merged into the public repo.
