---
owner_slack: "#govuk-frontenders"
title: Test a branch of the components gem
section: Frontend
layout: manual_layout
type: learn
parent: "/manual.html"
related_repos:
 - govuk_publishing_components
---

This document explains how to test a github branch of `govuk_publishing_components` in an application, either locally or for testing a change in the gem on integration.

## Prepare a branch of govuk_publishing_components

Create a branch of `govuk_publishing_components` with the changes that you want to test.

In a separate commit, modify the `.gitignore` file, replacing the `node_modules` line with the following.

```
node_modules/@babel
node_modules/@nodelib
node_modules/@oclif
node_modules/acorn
node_modules/ajv
node_modules/caniuse-lite
node_modules/devtools-protocol
node_modules/es-abstract
node_modules/eslint
node_modules/eslint-plugin-import
node_modules/eslint-plugin-react
node_modules/lodash
node_modules/micromark
node_modules/percy-client
node_modules/postcss
node_modules/puppeteer
node_modules/stylelint
node_modules/table
```

Commit and push the `.gitignore` and `node_modules` directory. This will add to the branch everything needed to make the components gem work - basically all the things that are normally installed as part of installing a gem.

**DO NOT** merge this change to `main` - once you have finished testing your branch, delete this commit.

## Prepare the application to use the gem branch

The application to use the branch of the components gem may vary depending on what you are testing, however the process remains the same.

Create a branch of the application and modify the Gemfile to point to the branch of `govuk_publishing_components`.

```
gem "govuk_publishing_components", git: 'https://github.com/alphagov/govuk_publishing_components.git', branch: 'branch-name'
```

Test your changes locally.

- if you are using the startup scripts to run your application, stop the script, run `bundle update govuk_publishing_components` and restart
- if you are using govuk-docker, stop the application, run `govuk-docker-run bundle update govuk_publishing_components` and restart

You can also push this branch to github and the heroku preview generated from the pull request will use the branch of `govuk_publishing_components`. Once you have pushed to github you can also deploy this branch to integration for further testing. Note that you do not need to do anything with the branch of `govuk_publishing_components` - only the application needs to be deployed to integration.
