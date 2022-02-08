---
owner_slack: "#govuk-developers"
title: Add a new Ruby version
section: Infrastructure
layout: manual_layout
parent: "/manual.html"
---

The [Ruby language](https://www.ruby-lang.org/en/) is a core part of GOV.UK - most of our applications are written in it.

## Managing different versions of Ruby

Each app can use whatever version of Ruby it wants. We manage this with
[rbenv](https://github.com/rbenv/rbenv).

## Setting up rbenv

We set up rbenv differently depending on what's going on:

- Interactive login shells: `/etc/profile.d/rbenv.sh` sets up rbenv
- Applications: `govuk_setenv` and a `.ruby-version` in the app directory set up rbenv
- Deployment: Capistrano uses a non -login shell so we [set `default_environment`][cap_deploy]
  ([commit][cap_deploy_commit])
- Testing: Jenkins uses a non-login shell so we [add `/usr/lib/rbenv/shims` to the `PATH`][rbenv_path]
- Cronjobs: some cronjobs start with `/bin/bash -l -c` which runs a login shell

[cap_deploy]: https://github.com/alphagov/govuk-app-deployment/blob/master/recipes/ruby.rb#L4
[cap_deploy_commit]: https://github.com/alphagov/alphagov-deployment/commit/b6404e33c354ef63f01c13b202ce0cf2ed2975fc
[rbenv_path]: https://github.com/alphagov/govuk-secrets/blob/master/puppet/hieradata/integration_credentials.yaml

## Add a new Ruby version in puppet

You will need to build a new [fpm](debian-packaging.html#fpm) package with the new Ruby version.
This package can then be copied to Aptly machine, and the new version added to puppet.

### Building the fpm package.

- Add a new recipe for the ruby version in [Packager][packager].
  The folder name will be the Ruby version, and contain a `recipe.rb` file. See previous entries for examples.
  The recipe will require the [SHA256][sha256_checksum] of the version's `tar.gz`, available at [Ruby cache][ruby_cache].

- Once the Packager change is merged, [build the package][jenkins].

- Then test and upload the package to Aptly. See <https://docs.publishing.service.gov.uk/manual/debian-packaging.html#fpm>.

### Add to Puppet

Once it's available as a package in Aptly you can [install it everywhere using Puppet][puppet_rbenv_all].
However, machines only run `apt-get update` periodically ([nightly](https://docs.publishing.service.gov.uk/manual/alerts/security-updates.html))
so it might take time for the package to become available.

You can speed things along by SSH'ing into the relevant machine and running `sudo apt-get update`,
then `govuk_puppet --test`. You should see a successful Ruby install as part of the Puppet run.

You'll need to do that on `jenkins` (and, if impatient, each of the `ci_agent` machines) first to get the PR's tests passing,
and then on the respective machine that your app will run on (e.g. `backend`).

### Update Ruby version in the relevant repos

We use [upgrade-ruby-version][] to automatically raise pull requests in GOV.UK repositories which use Ruby.
See an [example PR](https://github.com/alphagov/upgrade-ruby-version/pull/1) for how to specify the repos and versions.

Once the PRs are raised, you should test the changes before merge, as follows:

1. Most apps will run a test suite through CI. You should check the output of this for any Ruby deprecation warnings. If there are any warnings, they should be fixed.
1. Next, you should build the ruby upgrade branch of the app to Integration, and manually test its features to ensure that the new Ruby version hasn't broken the app.
1. It's worth checking the logs for deprecation warnings at this point (and fixing them), in case there are warnings that weren't flagged by the test suite run.
1. Next, check our monitoring tools, such as Grafana and Sentry.
1. The PR should be safe to merge.
1. Before the application will run with the new version, it will need to be restarted as well as deployed as normal. You can do this by running the `deploy:with_hard_restart` deploy task within the 'Deploy App' job in Jenkins.

> **NOTE** If the application is deployed without being restarted (e.g via continuous deployment) you will need to manually restart. You can do this by running the `app:hard_restart` deploy task within the 'Deploy App' job in Jenkins.

[packager]: https://github.com/alphagov/packager/tree/master/fpm/recipes
[sha256_checksum]: https://emn178.github.io/online-tools/sha256_checksum.html
[ruby_cache]: https://cache.ruby-lang.org/pub/ruby/
[jenkins]: https://ci.integration.publishing.service.gov.uk/job/build_fpm_package
[puppet_rbenv_all]: https://github.com/alphagov/govuk-puppet/blob/master/modules/govuk_rbenv/manifests/all.pp
[upgrade-ruby-version]: https://github.com/alphagov/upgrade-ruby-version
