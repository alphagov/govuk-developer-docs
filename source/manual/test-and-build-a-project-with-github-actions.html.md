---
owner_slack: "#govuk-developers"
title: Test & build a project with GitHub Actions
section: Testing
layout: manual_layout
parent: "/manual.html"
---

[GitHub Actions](https://github.com/features/actions) is an automated workflow
system that GOV.UK uses for [Continuous Integration (CI)][ci]. In
[GOV.UK RFC 123][] we decided that GitHub Actions is the preferred platform for
GOV.UK CI usage where the wider platform integration of Jenkins is not required.

**If your workflow requires the use of secrets, please talk to
[GOV.UK senior tech](/manual/ask-for-help.html#contact-senior-tech)
before deploying it.** This is to help GOV.UK establish consistent and
effective secret management for GitHub Actions across the wider alphagov
GitHub organisation.

## GOV.UK Conventions for GitHub Actions

### Name of CI workflow file

You should name the file used for configuring the CI workflow `ci.yml`.
It should live in the `.github/workflows` directory.

### Name of CI workflow and jobs

The CI workflow configured above should have a `name` property with a
value of `CI`. The workflow should have a number of self-contained jobs
configured, for actions such as running tests, linting and security scans.
These should [use reusable workflows](#reuse-workflows-where-possible) where
possible. For example:

```yaml
jobs:
  security-analysis:
    uses: alphagov/govuk-infrastructure/.github/workflows/brakeman.yml@main

  lint-javascript:
    uses: alphagov/govuk-infrastructure/.github/workflows/standardx.yml@main
    with:
      files: "'app/assets/javascripts/**/*.js'"

  lint-ruby:
    uses: alphagov/govuk-infrastructure/.github/workflows/rubocop.yml@main
```

The jobs and steps do not need to be given a [name attribute][actions-name-attribute]
as the job/step key should be sufficiently descriptive. In contrast, the
`ci.yml` _must_ have a `name` property called `CI`, as this is
[relied upon by our automated tooling](https://github.com/alphagov/govuk-dependabot-merger/pull/30).

We previously recommended that repos should always define a job called `test`.
Historically, this job would be responsible for running the repo's tests, linter
and so on, usually via something like `bundle exec rake`. In January 2023, a
[new convention](https://github.com/alphagov/content-data-admin/commit/89a888bf1d9d303cff50ae65ac9c0821c5c17e93)
was established, giving each task its own 'job' (e.g. 'test-ruby' for running
tests and 'lint-ruby' for running the linter), within an overall 'workflow'
called `CI`. Whilst this decoupling does make it harder to run the entire check suite
locally, it allows us to take advantage of GitHub Action parallelisation, as well
as better code reuse through reusable workflows.

### When the CI workflow should run

The workflow should be configured to run when there is a [`push`][push-event]
to the default branch (typically "main") and when a
[`pull_request`][pull-request-event] is opened. This means CI runs when a branch
is merged (the `push` to main) and it runs against any changes introduced
in a pull request. We prefer to run against a `pull_request` event to all
`push` events, as this allows external contributors to have pull requests
tested and because `pull_request` runs against a version of the codebase
[that is merged with the repository default branch][merge-comment].

Example configuration:

```yaml
# ./github/workflows/ci.yml
name: CI

on:
  push:
    branches:
      - main
  pull_request:
```

We previously recommended CI jobs to run on `[push, pull_request]` as per
[RFC-123][] however this caused duplicate runs of the CI jobs
of a pull request (one for the `push` another for the `pull_request`)
which were both superfluous for our testing, a point of confusion and were
depleting our allowance quotas.

[merge-comment]: https://github.com/alphagov/govuk-developer-docs/pull/3961#discussion_r1171071337
[RFC-123]: https://github.com/alphagov/govuk-rfcs/blob/main/rfc-123-github-actions-ci.md#findings-from-some-initial-explorations-into-using-github-actions

#### Running CI on demand

To run CI on-demand, outside a pull request, for example before opening a PR,
you may configure a repository to have a `workflow_dispatch` event so you can
run it from the GitHub Actions user interface. If you do this you will need
to configure the checkout action to reference the appropriate commit.

Example configuration:

```yml
name: CI

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
  # for example
  test-ruby:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
        with:
          ref: ${{ inputs.ref || github.ref }}
```

### Branch protection rules

Pull Requests must not be merged until the jobs defined in the `CI`
workflow have passed. You should always define a workflow called `CI`.

### Reuse workflows where possible

We define a number of reusable workflows in the govuk-infrastructure repo.

For example, here's [how Content Publisher uses a reusable workflow](https://github.com/alphagov/content-publisher/blob/70cafa40a5680a062d31f0e1d14ede3716318600/.github/workflows/ci.yml#L40-L42) that is [defined in govuk-infrastructure](https://github.com/alphagov/govuk-infrastructure/blob/d31a9792f70b3857b83596e6dacc7f6d591c6b0e/.github/workflows/rubocop.yml):

```yml
name: CI

jobs:
  lint-ruby:
    name: Lint Ruby
    uses: alphagov/govuk-infrastructure/.github/workflows/rubocop.yml@main
```

### Pin untrusted GitHub Actions to a commit SHA

To reduce security risks such as supply chain attacks and unexpectedly
breaking changes, it is important to pin your versions of untrusted (third-party)
GitHub Actions to a commit SHA rather than using a floating version or tag.
GitHub’s [Security Hardening for GitHub Actions][gh-hardening] guidance provides
further details. For example:

```yaml
jobs:
  security-analysis:
    # Instead of: uses: some/action@v2
    # Pin to a specific commit SHA:
    uses: some/action@c86d0dc2cb1a4ca77a7ba2912c5fd6912bf12a05
    # ...
```

Pins can still be updated periodically (manually or via Dependabot), ensuring
that you are in control of version changes. This is particularly important for
any external or untrusted actions that GOV.UK does not maintain directly.

To find the commit SHA for a given version tag, visit the repository on GitHub
and look at the commit history at that specific tag. The format of the  URL for
this is `https://github.com/owner/repository/commits/TAG`. The URL for `v5` of
the `setup-node` action, for example, is
`https://github.com/actions/setup-node/commits/v5/`. Choose the SHA hash of the
first commit in the history. This will be the commit to which the tag has been
applied.

### Only one workflow for a given branch should run at once

Under certain conditions, the deployment system can number releases in the
incorrect order if two pull requests are merged in to `main` at the same time.
This is caused by GitHub sometimes running the CI and release workflows in the wrong order.

To ensure the deployment system numbers releases in the correct order,
you should ensure only one CI run can be active at once for a given branch.
This can be done by adding the following to your CI file:

```yaml
concurrency:
  group: ${{ github.workflow }}-${{ github.repository }}-${{ github.ref_name }}
  cancel-in-progress: false
```

### CI workflow for Ruby gems

This differs to a simple Ruby application because Ruby gems are not tied to
particular Ruby or Rails versions. Therefore we should test against various
combinations of supported versions.
See [example in govspeak](https://github.com/alphagov/govspeak/blob/a42facbbc2365a47f9695b12fdfa6faac46cdb11/.github/workflows/ci.yml).

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
  to relevant repositories through [GitHub terraform deployment](https://github.com/alphagov/govuk-infrastructure/blob/main/terraform/deployments/github/main.tf).

[ci]: https://en.wikipedia.org/wiki/Continuous_integration
[GOV.UK RFC 123]: https://github.com/alphagov/govuk-rfcs/blob/main/rfc-123-github-actions-ci.md
[push-event]: https://help.github.com/en/actions/reference/events-that-trigger-workflows#push-event-push
[pull-request-event]: https://help.github.com/en/actions/reference/events-that-trigger-workflows#pull-request-event-pull_request
[actions-name-attribute]: https://help.github.com/en/actions/reference/workflow-syntax-for-github-actions#name
[build matrix]: https://docs.github.com/en/actions/using-workflows/advanced-workflow-features#using-a-build-matrix
[ruby-branches]: https://www.ruby-lang.org/en/downloads/branches/
[govuk_admin_template]: https://github.com/alphagov/govuk_admin_template
[gh-hardening]: https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions
