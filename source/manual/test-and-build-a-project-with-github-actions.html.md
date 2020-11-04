---
owner_slack: "#govuk-developers"
title: Test & build a project with GitHub Actions
section: Testing
layout: manual_layout
parent: "/manual.html"
---

[GitHub Actions](https://github.com/features/actions) is an automated workflow
system that GOV.UK uses for [Continuous Integration (CI)][ci], we also have
[Jenkins](/manual/testing-projects.html) and [Concourse](/manual/concourse.html)
that provide similar functionality. In [GOV.UK RFC 123][] we decided that
GitHub Actions is the preferred platform for GOV.UK CI usage where the wider
platform integration of Jenkins is not required.

Please note that we cannot currently make use of the [Secrets][actions-secrets]
in GitHub Action workflows, there are on-going discussions to resolve this. In
the meantime please **do not add any secrets to workflows**. For further
details of this restriction please contact
[GOV.UK senior tech](mailto:govuk-senior-tech@digital.cabinet-office.gov.uk).

Thus, you should continue to use Jenkins for any projects that need the
following:

- access to GDS' internal network to trigger other internal systems to perform
  jobs during or following a build (for example, triggering
  [publishing end-to-end tests][e2e-tests] or triggering a deployment);
- authentication to external systems (for example, [releasing a gem
  automatically][gem-release] during a master build).

## GOV.UK Conventions for GitHub Actions

### Name of CI workflow file

You should name the file used for configuring the CI workflow `ci.yml`.

### When the CI workflow should run

The workflow should be configured to run on [`push`][push-event] and
[`pull_request`][pull-request-event] events. The `push` event occurs for every
push to the repository and this will generate a build against the branch
that was pushed. The `pull_request` event occurs whenever a pull request
is opened and it is triggered again any time the pull request changes (such
as extra commits or rebasing), these differ to the `push` event by merging in
the master branch before running operations. Pull requests from forks of a
repo will only trigger the `pull_request` event.

For example:

```yml
# ./github/workflows/ci.yml
on: [push, pull_request]
```

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
      - uses: actions/cache@v1
        with:
          path: vendor/bundle
          key: bundle-${{ hashFiles('**/Gemfile.lock') }}
          restore-keys: bundle
      - run: bundle install --jobs 4 --retry 3 --deployment
      - run: bundle exec rake
```

Notes:

- [ruby/setup-ruby](https://github.com/ruby/setup-ruby) will automatically
  select the Ruby version based on a `.ruby-version` file and will install
  bundler if a necessary.
- This use [actions/cache](https://github.com/actions/cache) to cache gems
  between runs.
- This uses the [deployment][bundler-deployment] flag for bundler to be
  configured for CI environments, the jobs flag allows parallel installs and
  retries allows re-attempts on failures.

### A Ruby Gem

This differs to a simple Ruby application as Ruby gems are not tied to a
particular Ruby version, therefore for those we should test a variety of
Ruby versions. Do bear in mind that due to the restriction on secrets
usage we cannot currently publish gems through GitHub Actions, this can
still be achieved through Jenkins.

```yml
# .github/workflows/ci.yml
on: [push, pull_request]
jobs:
  test:
    strategy:
      matrix:
        ruby: [2.5, 2.6, 2.7]
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: ruby/setup-ruby@v1
        with:
          ruby-version: ${{ matrix.ruby }}
      - uses: actions/cache@v1
        with:
          path: vendor/bundle
          key: bundle-${{ matrix.ruby }}-${{ hashFiles('**/*.gemspec') }}
          restore-keys: bundle-${{ matrix.ruby }}
      - run: bundle install --jobs 4 --retry 3 --path vendor/bundle
      - run: bundle exec rake
```

Notes:

- The [deployment][bundler-deployment] flag for bundler cannot be used for gems
  as they should not have a Gemfile.lock committed.
- Our preference is to test the gems we publish against the latest version of
  [all currently supported minor versions of Ruby MRI][ruby-branches].

## GOV.UK Rails application with Postgres, Redis, Yarn and GOV.UK Content Schemas dependencies

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
      GOVUK_CONTENT_SCHEMAS_PATH: vendor/govuk-content-schemas
    steps:
      - name: Clone project
        uses: actions/checkout@v2
      - name: Clone GOV.UK Content Schemas
        uses: actions/checkout@v2
        with:
          repository: alphagov/govuk-content-schemas
          ref: deployed-to-production
          path: vendor/govuk-content-schemas
      - uses: ruby/setup-ruby@v1
      - name: Check for cached bundler
        uses: actions/cache@v1
        with:
          path: vendor/bundle
          key: bundle-${{ hashFiles('**/Gemfile.lock') }}
          restore-keys: bundle
      - run: bundle install --jobs 4 --retry 3 --deployment
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
- This example does not include tagging the [master branch with a particular
  release tag][release-tag] when there is a successful master build.

[ci]: https://en.wikipedia.org/wiki/Continuous_integration
[Jenkins]: /manual/testing-projects.html
[GOV.UK RFC 123]: https://github.com/alphagov/govuk-rfcs/blob/master/rfc-123-github-actions-ci.md
[actions-secrets]: https://help.github.com/en/actions/configuring-and-managing-workflows/creating-and-storing-encrypted-secrets
[e2e-tests]: /manual/publishing-e2e-tests.html
[gem-release]: /manual/publishing-a-ruby-gem.html#releasing-gem-versions
[govuk-puppet]: https://github.com/alphagov/govuk-puppet
[actions-marketplace]: https://github.com/marketplace?type=actions
[push-event]: https://help.github.com/en/actions/reference/events-that-trigger-workflows#push-event-push
[pull-request-event]: https://help.github.com/en/actions/reference/events-that-trigger-workflows#pull-request-event-pull_request
[actions-name-attribute]: https://help.github.com/en/actions/reference/workflow-syntax-for-github-actions#name
[action-templates]: https://github.community/t5/GitHub-Actions/Templates-for-GitHub-Actions/m-p/52811
[bundler-deployment]: https://bundler.io/man/bundle-install.1.html#DEPLOYMENT-MODE
[ruby-branches]: https://www.ruby-lang.org/en/downloads/branches/
[Content Publisher]: https://github.com/alphagov/content-publisher
[actions-docker-services]: https://help.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idservices
[service-configuration]: https://help.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idservices
[govuk-frontend-issue]: https://github.com/alphagov/govuk-frontend/issues/1671
[release-tag]: https://docs.publishing.service.gov.uk/manual/testing-projects.html#fixing-the-build-number
