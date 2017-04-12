---
owner_slack: '#2ndline'
review_by: 2017-09-24
title: Test & build a project on Jenkins CI
section: Testing
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/infrastructure/testing/testing-projects.md"
---



> **This page was imported from [the opsmanual on github.gds](https://github.gds/gds/opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.gds/gds/opsmanual/tree/master/infrastructure/testing/testing-projects.md)


# Test & build a project on Jenkins CI

Application tests run in a continuous integration (CI) environment.

https://ci.integration.publishing.service.gov.uk/

[Read here about the CI infrastructure](/infrastructure/jenkins-ci.html).

## Setting up

### 1. Create the job in Jenkins

You need to add your repo to the `govuk_ci::master::pipeline_jobs` in [govuk-puppet][pipeline_jobs]. This will create the job in Jenkins.

[pipeline_jobs]: https://github.com/alphagov/govuk-puppet/blob/master/hieradata/common.yaml

### 2. Add a Jenkinsfile

Your repo needs to contain a `Jenkinsfile` in the root which has
details of how the application is built. In most cases the `Jenkinsfile` will need to run the tests for your project. For applications the build process includes [creating a release tag](/2nd-line/releasing-software/index.html). For gems the build process includes releasing the packaged gem to [rubygems.org](https://rubygems.org).

[Read the documentation for this in alphagov/govuk-puppet][puppet-x]

[puppet-x]: https://github.com/alphagov/govuk-puppet/blob/master/modules/govuk_jenkins/files/var/lib/jenkins/groovy_scripts/govuk_jenkinslib.groovy

### 3. Trigger builds from GitHub

Builds are triggered using a GitHub "service". From a project's GitHub
settings, add the "Jenkins (GitHub plugin)" service to point to
`https://ci.integration.publishing.service.gov.uk/github-webhook/`.

See [content-store's configuration for an example][example].

[example]: https://github.com/alphagov/content-store/settings/hooks/1995352

### 4. Branch indexing

Once your Jenkinsfile is on a branch, you can go to your job in new Jenkins and
run "Branch Indexing" from the menu. This should trigger a build of all branches
with a Jenkinsfile, which should be your new branch. Any open branches need to be rebased after you've merged your `Jenkinsfile` into `master`.

### 5. Set up schema testing

Many GOV.UK applications test against the
[content schemas](https://github.com/alphagov/govuk-content-schemas/).

To test your application for each PR on govuk-content-schemas, add it to the [govuk-content-schemas
Jenkinsfile](https://github.com/alphagov/govuk-content-schemas/blob/master/Jenkinsfile).
