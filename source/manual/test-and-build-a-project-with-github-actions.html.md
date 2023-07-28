---
owner_slack: "#govuk-developers"
title: Test & build a project with GitHub Actions
section: Testing
layout: manual_layout
parent: "/manual.html"
---

[GitHub Actions](https://github.com/features/actions) is an automated workflow
system that GOV.UK uses for [Continuous Integration (CI)][ci]. We also have
[Jenkins](/manual/testing-projects.html) (and previously had Concourse) which
provides similar functionality. In [GOV.UK RFC 123][] we decided that
GitHub Actions is the preferred platform for GOV.UK CI usage where the wider
platform integration of Jenkins is not required.

**If your workflow requires the use of secrets, please talk to
[GOV.UK senior tech](mailto:govuk-senior-tech-members@digital.cabinet-office.gov.uk)
before deploying it.** This is to help GOV.UK establish consistent and
effective secret management for GitHub Actions across the wider alphagov
GitHub organisation.

## GOV.UK Conventions for GitHub Actions

### Name of CI workflow file

You should name the file used for configuring the CI workflow `ci.yml`.

### When the CI workflow should run

The workflow should be configured to run when there is a [`push`][push-event]
to the default branch (typically "main") and when a
[`pull_request`][pull-request-event] opened. This means CI runs when a branch
is merged (the `push` to main) and it runs against any changes introduced
in a pull request. We prefer to run against a `pull_request` event to all
`push` events, as this allows external contributors to have pull requests
tested and because `pull_request` runs against a version of the codebase
[that is merged with the repository default branch][merge-comment].

Example configuration:

```yml
# ./github/workflows/ci.yml
on:
  push:
    branches:
      - main
  pull_request:

```

To run CI on-demand, outside a pull request, for example before opening a PR,
you may configure a repository to have a `workflow_dispatch` event so you can
run it from the GitHub Actions user interface. If you do this you will need
to configure the checkout action to reference the appropriate commit.

Example configuration:

```yml
on:
  push:
    branches:
      - main
  pull_request:
  workflow_dispatch:
    inputs:
      ref:
        description: 'The branch, tag or SHA to checkout'
        default: main
        type: string

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
        with:
          ref: ${{ inputs.ref || github.ref }}
```

We previously recommended CI jobs to run on `[push, pull_request]` as per
[RFC-123][] however this caused duplicate runs of the CI jobs
of a pull request (one for the `push` another for the `pull_request`)
which were both superfluous for our testing, a point of confusion and were
depleting our allowance quotas.

[merge-comment]: https://github.com/alphagov/govuk-developer-docs/pull/3961#discussion_r1171071337
[RFC-123]: https://github.com/alphagov/govuk-rfcs/blob/main/rfc-123-github-actions-ci.md#findings-from-some-initial-explorations-into-using-github-actions

### Avoid superfluous naming of workflows, jobs and steps

In workflow files you have the option to specify a
[name attribute][actions-name-attribute] for the workflow itself, the jobs and
each individual step.

The workflow and any jobs should not be given a name as the workflow filename
and job_id should be sufficiently explanatory.

Steps should also not be named, as the text in the run command is normally
sufficiently descriptive. We only should add names to steps where they are
used to either explain a particularly cryptic set of commands or where there
are identically appearing steps that we wish to disambiguate between.

You should also avoid providing a `name` for your `test` job (see below).

### Branch protection rules

Pull Requests [cannot be merged][branch-rule] until the `test` job has passed.
Your workflow should always define a job called `test`.

Some automation relies on the presence of the `test` job. Whilst care has been
taken to support custom names [in some places](https://github.com/alphagov/govuk-saas-config/pull/139),
other places may not support them, so it is safer to just omit the `name`
property for your `test` job.

### Prefer a single or small number of steps within a CI workflow

Rather than having a number of granular steps (such as: "Lint Ruby", "Lint JS",
"Run Ruby tests", "Run JS Tests") prefer a single step (such as `bundle exec
rake`) where more of the CI task configuration is handled in application code.

This is so we can:

- keep CI configurations simple and consistent;
- make it easier to replicate CI checks in a development environment.

### Base your workflow on one of our documented examples

GitHub Actions currently [lack templating functionality][action-templates]
to enable re-use of workflow configuration across projects. Therefore, in order
to maintain consistency across GOV.UK projects, it is beneficial that we
document and re-use common practices.

This documentation contains examples of a number of common build needs for
GOV.UK projects. You are encouraged to base your project's configuration on
these and to follow their conventions. If your preferences, or common action
conventions, deviate from these examples you are encouraged to open a PR to
this repository to propose a change here. This is preferential to taking a
project in a different direction and losing consistency.

## GitHub Action Examples

### Simple Ruby Application

```yml
# .github/workflows/ci.yml
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: ruby/setup-ruby@v1
        with:
          bundler-cache: true
      - run: bundle exec rake
```

Notes:

- [ruby/setup-ruby](https://github.com/ruby/setup-ruby) will automatically
  select the Ruby version based on a `.ruby-version` file and will install
  bundler if a necessary.
  - The [`bundler-cache: true` option](https://github.com/ruby/setup-ruby#caching-bundle-install-automatically)
    automatically runs `bundle install` and caches the result between builds.

### A Ruby Gem

This differs to a simple Ruby application because Ruby gems are not tied to
particular Ruby or Rails versions. Therefore we should test against various
combinations of supported versions.

To do this, we use a [build matrix][]. In this example, we test against three
Ruby versions (`2.7`, `3.0`, `3.1`) and two Rails versions (`6`, `7`). Combined,
this results in 6 variations for the workflow to test against.

```yml
# .github/workflows/ci.yml
on: [push, pull_request]
jobs:
  # Run the test suite against multiple Ruby and Rails versions
  test_matrix:
    strategy:
      fail-fast: false
      matrix:
        # Due to https://github.com/actions/runner/issues/849, we have to use quotes for '3.0'
        ruby: [2.7, '3.0', 3.1]
        # Test against multiple Rails versions
        gemfile: [rails_6, rails_7]
    runs-on: ubuntu-latest
    env:
      BUNDLE_GEMFILE: gemfiles/${{ matrix.gemfile }}.gemfile
    steps:
    - uses: actions/checkout@v3
    - uses: ruby/setup-ruby@v1
      with:
        ruby-version: ${{ matrix.ruby }}
        bundler-cache: true
    - run: bundle exec rake

  # Branch protection rules cannot directly depend on status checks from matrix jobs.
  # So instead we define `test` as a dummy job which only runs after the preceding `test_matrix` checks have passed.
  # Solution inspired by: https://github.community/t/status-check-for-a-matrix-jobs/127354/3
  test:
    needs: test_matrix
    runs-on: ubuntu-latest
    steps:
      - run: echo "All matrix tests have passed 🚀"

  # We have a shared workflow that can be used for most gem publishing needs. You may have to write
  # your own if you have a gem that is released in a complex way.
  publish:
    needs: test
    if: ${{ github.ref == 'refs/heads/main' }}
    permissions:
      contents: write
    uses: alphagov/govuk-infrastructure/.github/workflows/publish-rubygem.yaml@main
    secrets:
      GEM_HOST_API_KEY: ${{ secrets.ALPHAGOV_RUBYGEMS_API_KEY }}
```

For each Rails version, a `*.gemfile` should exist in a top-level directory called `gemfiles`.

```ruby
# gemfiles/rails_7.gemfile
source "https://rubygems.org"

gem "rails", "~> 7"

gemspec path: "../"
```

Notes:

- Our preference is to test the gems we publish against the latest version of
  [all currently supported minor versions of Ruby MRI][ruby-branches].
- For a real world example of this workflow, see [govuk_admin_template][].
- The `ALPHAGOV_RUBYGEMS_API_KEY` secret is an organisation secret that is added
  to individual repositories by a GitHub Admin. Please talk to
  [GOV.UK Senior Tech](mailto:govuk-senior-tech-members@digital.cabinet-office.gov.uk)
  for this to be added to a repo.

### GOV.UK Rails application with Postgres, Redis, Yarn and GOV.UK Content Schemas dependencies

This is an example that suits a relatively complex GOV.UK Rails application
(this was written for [Content Publisher][]) that has software dependencies
(provided by [Docker containers][actions-docker-services]), cloning of a
supplementary repository, and the use of Node.js for JavaScript dependency
management.

```yml
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:9.4
        ports:
          - 5432:5432
        env:
          POSTGRES_HOST_AUTH_METHOD: trust
        options: --health-cmd pg_isready --health-interval 10s --health-timeout 5s --health-retries 5
      redis:
        image: redis
        ports:
          - 6379:6379
        options: --health-cmd "redis-cli ping" --health-interval 10s --health-timeout 5s --health-retries 5
    env:
      RAILS_ENV: test
      REDIS_URL: redis://localhost:6379/0
      TEST_DATABASE_URL: postgresql://postgres@localhost/content-publisher
      GOVUK_CONTENT_SCHEMAS_PATH: vendor/publishing-api/content_schemas
    steps:
      - name: Clone project
        uses: actions/checkout@v2
      - name: Clone publishing api for content schemas
        uses: actions/checkout@v2
        with:
          repository: alphagov/publishing-api
          ref: deployed-to-production
          path: vendor/publishing-api
      - uses: ruby/setup-ruby@v1
        with:
          bundler-cache: true
      - uses: actions/setup-node@v1
      - name: Check for cached node modules
        uses: actions/cache@v1
        with:
          path: node_modules
          key: yarn-${{ hashFiles('**/yarn.lock') }}
          restore-keys: yarn
      - run: yarn install --frozen-lockfile
      - run: bundle exec rails db:setup
      - run: bundle exec rails assets:precompile
      - run: bundle exec rake
```

Notes:

- [Similar service configurations][service-configuration] to PostgreSQL and
  Redis can be applied to other software dependencies such as MySQL, MongoDB
  or Rabbit MQ.
- The `health-cmd` checks are used on services to ensure the build does not
  continue until the service is running.
- Additional repositories are cloned to the vendor directory for a consistent
  location for third party code, this is consistent with Bundler.
- Since the same actions are used in different contexts the `name` option has
  been used in steps to distinguish the different steps.
- The `bundle exec rails assets:precompile` task is used to build a warm cache
  of assets before starting tests to reduce risk of timeouts, this is due to
  an [underlying performance issue][govuk-frontend-issue] with GOV.UK asset
  compilation.
- In the underlying project (Content Publisher) `bundle exec rake` performs:
  Ruby & JS unit testing; Ruby, SCSS, JavaScript and FactoryBot linting; and
  brakeman security audit.
- This example does not include tagging the [main branch with a particular
  release tag][release-tag] when there is a successful main build.

[ci]: https://en.wikipedia.org/wiki/Continuous_integration
[Jenkins]: /manual/testing-projects.html
[GOV.UK RFC 123]: https://github.com/alphagov/govuk-rfcs/blob/main/rfc-123-github-actions-ci.md
[actions-secrets]: https://help.github.com/en/actions/configuring-and-managing-workflows/creating-and-storing-encrypted-secrets
[gem-release]: /manual/publishing-a-ruby-gem.html#releasing-gem-versions
[govuk-puppet]: https://github.com/alphagov/govuk-puppet
[actions-marketplace]: https://github.com/marketplace?type=actions
[push-event]: https://help.github.com/en/actions/reference/events-that-trigger-workflows#push-event-push
[pull-request-event]: https://help.github.com/en/actions/reference/events-that-trigger-workflows#pull-request-event-pull_request
[actions-name-attribute]: https://help.github.com/en/actions/reference/workflow-syntax-for-github-actions#name
[branch-rule]: https://github.com/alphagov/govuk-saas-config/blob/4d68f59f9af61e0f62bb074abc740aa53db300c1/github/lib/configure_repo.rb#L107
[action-templates]: https://github.community/t5/GitHub-Actions/Templates-for-GitHub-Actions/m-p/52811
[build matrix]: https://docs.github.com/en/actions/using-workflows/advanced-workflow-features#using-a-build-matrix
[ruby-branches]: https://www.ruby-lang.org/en/downloads/branches/
[govuk_admin_template]: https://github.com/alphagov/govuk_admin_template
[Content Publisher]: https://github.com/alphagov/content-publisher
[actions-docker-services]: https://help.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idservices
[service-configuration]: https://help.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idservices
[govuk-frontend-issue]: https://github.com/alphagov/govuk-frontend/issues/1671
[release-tag]: /manual/testing-projects.html#fixing-the-build-number
