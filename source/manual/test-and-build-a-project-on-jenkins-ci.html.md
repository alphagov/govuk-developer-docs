---
owner_slack: "#govuk-developers"
title: Test & build a project on Jenkins CI
section: Testing
layout: manual_layout
parent: "/manual.html"
---

Application tests run in a continuous integration (CI) environment.

[https://ci.integration.publishing.service.gov.uk/](https://ci.integration.publishing.service.gov.uk/)

[Read here about the CI infrastructure](/manual/jenkins-ci.html).

## Setting up

### 1. Create the job in Jenkins

You need to add your repo to the `govuk_ci::master::pipeline_jobs` in [govuk-puppet][pipeline_jobs]. This will create the job in Jenkins.

[pipeline_jobs]: https://github.com/alphagov/govuk-puppet/blob/main/hieradata_aws/common.yaml

### 2. Add a Jenkinsfile

Your repo needs to contain a `Jenkinsfile` in the root which has
details of how the application is built. In most cases the `Jenkinsfile` will need to run the tests for your project. For applications the build process includes [creating a release tag](/manual/development-pipeline.html). For gems the build process includes releasing the packaged gem to [rubygems.org](https://rubygems.org).

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

Adding a Jenkins webhook to the repo on GitHub will allow branches to be
built automatically when commits are pushed.

There is a task that can be run to add this webhook to the new repo. Find
out more about [automatically configuring a GitHub repo][auto-config].

[auto-config]: /manual/github.html

### 4. Branch indexing

Once your Jenkinsfile is on a branch, you can go to your job in new Jenkins and
run "Branch Indexing" from the menu. This should trigger a build of all branches
with a Jenkinsfile, which should be your new branch. Any open branches need to be rebased after you've merged your `Jenkinsfile` into `main`.

### 5. Set up schema testing

Many GOV.UK applications test against the
[content schemas](https://github.com/alphagov/publishing-api/blob/main/content_schemas). contained in publishing api

To test your application for each PR against any changes to publishing api's content-schemas, add it to the [publishing-api
Jenkinsfile](https://github.com/alphagov/publishing-api/blob/main/Jenkinsfile).

## Specifying which database to use

The CI machines have installations of a number of database technologies, such
as PostgreSQL, MySQL and MongoDB, these tend to be quite old versions (at the
time of writing PostgreSQL 9.6 and MySQL 5.5). We have utilised Docker as a
way to provide access to newer versions of databases which can be used as
part of your build. These can be accessed with the following connection strings:

- MySQL 8: `mysql2://root:root@127.0.0.1:33068/<your-database-name>`
- PostgreSQL 13: `postgresql://postgres@127.0.0.1:54313/<your-database-name>`

Typically for these to work with a Rails application you'll need to set an
environment variable. For example, in your Jenkinsfile, for an application
that uses `TEST_DATABASE_URL`, you can set:

```
#!/usr/bin/env groovy

library("govuk")

node {
  govuk.setEnvar("TEST_DATABASE_URL", "postgresql://postgres@127.0.0.1:54313/content-publisher-test")

  govuk.buildProject()
}
```

## Fixing the build number

Main branch builds are often tagged with the Jenkins build number so that a
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
def job = Jenkins.instance.getItemByFullName("your-project-name/main")
job.nextBuildNumber = 1234
job.save()
```
