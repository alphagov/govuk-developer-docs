---
owner_slack: "#govuk-developers"
title: Test & build a project on Jenkins CI
section: Testing
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-07-19
review_in: 6 months
---

Application tests run in a continuous integration (CI) environment.

[https://ci.integration.publishing.service.gov.uk/](https://ci.integration.publishing.service.gov.uk/)

[Read here about the CI infrastructure](/manual/jenkins-ci.html).

## Setting up

### 1. Create the job in Jenkins

You need to add your repo to the `govuk_ci::master::pipeline_jobs` in [govuk-puppet][pipeline_jobs]. This will create the job in Jenkins.

[pipeline_jobs]: https://github.com/alphagov/govuk-puppet/blob/master/hieradata/common.yaml

### 2. Add a Jenkinsfile

Your repo needs to contain a `Jenkinsfile` in the root which has
details of how the application is built. In most cases the `Jenkinsfile` will need to run the tests for your project. For applications the build process includes [creating a release tag](/manual/deploying.html). For gems the build process includes releasing the packaged gem to [rubygems.org](https://rubygems.org).

The following `Jenkinsfile` should be sufficient for most projects:

```groovy
#!/usr/bin/env groovy

library("govuk")

node {
  govuk.buildProject()
}
```

[Read the documentation for this in alphagov/govuk-jenkinslib][jenkinslib]

[jenkinslib]: https://github.com/alphagov/govuk-jenkinslib

### 3. Trigger builds from GitHub

Builds are triggered using a GitHub "service". From a project's GitHub
settings, add the "Jenkins (GitHub plugin)" service to point to:

```
https://ci.integration.publishing.service.gov.uk/github-webhook/
```

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

## Fixing the build number

Master branch builds are often tagged with the Jenkins build number so that a
specific version can be deployed to each environment.

This can fail if the build number is reset, for example if all the old builds
are deleted or if a job is migrated from a different CI server. The error will
be something like this:

```
fatal: tag 'release_1' already exists
```

To fix this, set the build number to the next release number using the [Jenkins
script console](https://ci.integration.publishing.service.gov.uk/script):

```
def job = Jenkins.instance.getItemByFullName("your-project-name/master")
job.nextBuildNumber = 1234
job.save()
```
